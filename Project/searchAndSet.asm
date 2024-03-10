BITS 64
%include "constants.inc"
global searchAndSet

section .text
extern malloc

searchAndSet:
  .dfaP equ 0
  .stateP equ 8
  .finalP equ 16

  push rbp
  mov rbp, rsp
  sub rsp, 32

  mov [rsp + .dfaP], rdi
  mov [rsp + .stateP], rsi

  mov r11, 0
  mov rdi, [rsp + .dfaP]
  mov r12, [rdi + DFA.states]
  mov r13, [rdi + DFA.numStates]
  .loopS:
    mov ecx, dword [r12 + State.id]
    mov esi, dword [rsp + .stateP]
    cmp rcx, rsi
    je found
    add r12, State_size
    inc r11
    cmp r11, r13
    jl .loopS
  jmp not_found
  
  found:
    mov rbx, 1
    mov byte [r12 + State.isAccepting], bl
    mov rax, r12
    leave
    ret

  not_found:
    mov rax, 0
    leave
    ret