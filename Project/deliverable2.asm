BITS 64
%include "constants.inc"
global simulateDfa
section .text
extern strcmp
extern getNextState

simulateDfa:
  .dfa equ 0
  .inputString equ 8
  .currState equ 16

  push rbp 
  mov rbp, rsp
  sub rsp, 32
  ;Store parameters
  mov [rsp + .dfa], rdi
  mov [rsp + .inputString], rsi
 
 ;mov rbx, [rsp + .dfa]
  
  mov r12, [rdi + DFA.startState]
  mov r15, 0
  mov [rsp + .currState], r12
  mov r14, [rsp + .inputString]
  .loop:
    mov cl, byte [r14 + r15]
    cmp cl, 0
    je .endString
    mov rsi, r12
    mov rdx, rcx
    call getNextState
    cmp ax, 0
    jl .false
    mov rdi, [rsp + .dfa]
    mov r12, rax
    mov [rsp + .currState], r12
    inc r15
    jmp .loop

  .endString:

    mov rdi, [rsp + .dfa]
    mov r14, [rdi + DFA.states]
    mov rcx, [rdi + DFA.numStates]

    mov rbx, 0
    .loopA:
        mov rdi, [r14 + State.id]
        mov rsi, [rsp + .currState]
        cmp edi, esi
        je .endFunction
        jmp .secondCheck
        .secondCheck:
        add r14, Transition_size
        inc rbx
        cmp rbx, rcx
        jl .loopA
        jmp .false
    .endFunction:
        mov rdi, [r14 + State.isAccepting]
        cmp di, 1
        je .true
        jmp .false
        .true:
            mov rax, 1
            leave
            ret
        .false:
            mov rax, 0
            leave 
            ret
            
