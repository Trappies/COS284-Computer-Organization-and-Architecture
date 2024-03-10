BITS 64
%include "constants.inc"
global readDfa
section .data
    filemode db "r"
    line db 0
    demiliter db ","
section .text
extern malloc
extern fopen
extern fclose
extern getline
extern fgets
extern strtok
extern initDfa
extern searchAndSet

readDfa:
  .filename equ 0
  .fp equ 8
  .numS equ 16
  .numT equ 24  
  .dfa equ 32
  .tempArr equ 40
  .tempState equ 48
  push rbp
  mov rbp, rsp
  sub rsp, 64
  ;Store the filename
  mov[rsp + .filename], rdi
  ;Open the file
  mov rsi, filemode
  call fopen
  cmp rax, 0
  je .error
  mov [rsp + .fp], rax
  ;Start reading the file
  ;Get the details from the first line
  mov rdi, line
  mov rsi, 20
  mov rdx, rax
  call fgets
  mov rdi, rax
  mov rsi, demiliter
  call strtok
  ;Store numStates
  movzx rbx, byte [rax]
  sub bl, '0'
  mov [rsp + .numS], rbx
  ;Store numTransitions
  movzx rcx, byte [rax+2]
  sub cl, '0'
  mov [rsp + .numT], rcx
  ;Call initDfa
  mov rdi, [rsp + .numS]
  mov rsi, rcx
  call initDfa
  mov [rsp + .dfa], rax
  ;Get States
  mov rax, [rsp + .fp]
  mov rdi, line
  mov rsi, 20
  mov rdx, rax
  call fgets
  ;Delimit
  mov rdi, rax
  mov rsi, demiliter
  call strtok
  ;Loop through states and store them in array
  mov [rsp + .tempArr], rax
  mov rbx, 0
  mov r15, 0
  mov r14, [rsp + .dfa]
  ;lea r12, [r14 + DFA.states]

  .loop:
    mov rdi, State_size
    call malloc
    mov rcx, [rsp + .tempArr]
    movzx rdi, byte [rcx + r15]
    sub dil, '0'
    mov [rax + State.id], rdi
    mov [rsp + .tempState], rax
    mov rcx, rbx
    imul rcx, State_size
    mov rdi, [r14 + DFA.states]
    add rdi, rcx
    mov r12, [rsp + .tempState]
    mov rsi, r12
    mov rcx, State_size
    rep movsb

    ;add r12, State_size
    add r15, 2
    inc rbx
    mov r8, [rsp + .numS]
    cmp rbx, r8
    jl .loop 
    ;Process the transitions
    mov rax, [rsp + .fp]
    mov rdi, line
    mov rsi, 20
    mov rdx, rax
    call fgets
    ;Delimit
    mov rdi, rax
    mov rsi, demiliter
    call strtok
    mov [rsp + .tempArr], rax
    mov r15, 0
    .loop1:
      mov rcx, [rsp + .tempArr]
      movzx rbx, byte [rcx + r15]
      cmp rbx, 0
      je .outL
      sub rbx, '0'
      mov rdi, [rsp + .dfa]
      mov rsi, rbx
      call searchAndSet
      add r15, 2
      jmp .loop1
  .outL:
  mov rbx, 0
  mov r14, [rsp + .dfa]
  .loopT:
    mov rax, [rsp + .fp]
    mov rdi, line
    mov rsi, 20
    mov rdx, rax
    call fgets
    cmp rax, 0
    je .outT
    ;Delimit
    mov rdi, rax
    mov rsi, demiliter
    call strtok
    mov [rsp + .tempArr], rax
    mov rdi, Transition_size
    call malloc
    ;Store transition
    mov rcx, [rsp + .tempArr]
    movzx rdi, byte [rcx]
    sub dil, '0'
    mov [rax + Transition.from], edi
    
    movzx rdi, byte [rcx + 2]
    sub dil, '0'
    mov [rax + Transition.to], edi

    movzx rdi, byte [rcx + 4]
    mov [rax + Transition.symbol], edi
    mov [rsp + .tempState], rax

    mov rcx, rbx
    imul rcx, Transition_size
    mov rdi, [r14 + DFA.transitions]
    add rdi, rcx
    mov r12, [rsp + .tempState]
    mov rsi, r12
    mov rcx, Transition_size
    rep movsb
    inc rbx
    jmp .loopT
  .outT:
  jmp .success
  ;If the file cannot open return NULL
  .error:
    mov rax, 0
    leave 
    ret
  .success:
    mov rax, [rsp + .dfa]
    leave
    ret

