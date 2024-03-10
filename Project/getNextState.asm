BITS 64
%include "constants.inc"
global getNextState

section .text
extern strcmp

getNextState:
  .dfaP equ 0
  .currState equ 8
  .inputChar equ 16

  push rbp
  mov rbp, rsp
  sub rsp, 32
  mov [rsp + .dfaP], rdi
  mov [rsp + .currState], rsi
  mov [rsp + .inputChar], rdx

  mov r11, 0
  mov rdi, [rsp + .dfaP]
  mov r12, [rdi + DFA.transitions]
  mov r13, [rdi + DFA.numTransitions]
  .loopS:
    mov rcx, [r12 + Transition.from]
    mov rbx, [rsp + .currState]
    cmp ecx, ebx
    jz .oneEqu
    jmp .notEqual
    .oneEqu:
        mov rcx, [r12 + Transition.symbol]
        mov rsi, [rsp + .inputChar]
        cmp cl, sil
        je found
        jmp .notEqual
    
    .notEqual:
    add r12, Transition_size
    inc r11
    cmp r11, r13
    jl .loopS
  jmp not_found
  
  found:
    mov rbx, [r12 + Transition.to]
    mov rax, rbx
    leave
    ret

  not_found:
    mov rax, -1
    leave
    ret