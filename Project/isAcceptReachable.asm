BITS 64
%include "constants.inc"
global isAcceptReachable
section .data
  c dq 0
struc Queue
      .front resd 1
      align 4
      .rear resd 1
      align 4
      .size resd 1
      align 4 
      .capacity resd 1
      align 8
      .array resq 1
endstruc
section .text
   extern isEmpty
   extern isFull
   extern malloc
   extern free
   extern enqueue
   extern dequeue
   extern createQueue

; isAcceptReachable:
;   .dfa equ 0
;   .boolArr equ 8
;   .queue equ 16
;   .currState equ 24
;   .nextState equ 32
  
;   push rbp
;   mov rbp, rsp
;   sub rsp, 32

;   ;Store the DFA's  
;   mov [rsp + .dfa], rdi
;   ;Create boolean array
;   mov rbx, [rdi + DFA.numStates]
;   mov rdi, rbx
;   call malloc
;   mov r12, 0
;   .loop:
;     mov rbx, 0
;     mov byte [rax + r12], bl
;     inc r12
;     cmp r12, rbx
;     jl .loop
;     jmp .nextPart

;   .nextPart:
;     mov [rsp + .boolArr], rax
;   ;Create queue for BFS
;   mov rdi, rbx
;   call createQueue
;   mov [rsp + .queue], rax
;   ;Enqueue start state
;   mov rdi, rax
;   mov rsi, 0
;   call enqueue
;   mov rax, [rsp + .boolArr]
;   mov byte [rax], 1
;   ;Loop and perform the bfs
;   .while:
;     mov rdi, [rsp + .queue]
;     call isEmpty
;     cmp rax, 1
;     je .endWhile
;     ;Call dequeue
;     mov rdi, [rsp + .queue]
;     call dequeue
;     mov [rsp + .currState], rax
;     ;Check if the current state is an accept state
;     mov rcx, [rsp + .dfa]
;     lea rbx, [rcx + DFA.states]
;     imul rax, State_size
;     add rbx, rax
;     mov rdi, [rbx + State.isAccepting]
;     cmp rdi, 1
;     je .acceptStateReached
;     ;Loop through the transitions
;     mov r14, 0
;     mov r15, [rsp + .dfa]
;     mov r12, [r15 + DFA.transitions]
;     mov r13, [r15 + DFA.numTransitions]
;     .loopS:
;         mov rcx, [r12 + Transition.from]
;         mov rbx, [rsp + .currState]
;         cmp ecx, ebx
;         jz .oneEqu
;         jmp .notEqual
;         .oneEqu:
;             mov rdi, [r12 + Transition.to]
;             mov [rsp + .nextState], rdi
;             mov rdx, [rsp + .boolArr]
;             add rdx, rdi
;             cmp byte [rdx], 0
;             jz .enqueue
;             jmp .notEqual
;             ;Enqueue
;             .enqueue:
;                 mov rdi, [rsp + .queue]
;                 mov rsi, [rsp + .nextState]
;                 call enqueue
;                 mov rdx, [rsp + .boolArr]
;                 mov rdi, [rsp + .nextState]
;                 mov byte [rdx + rdi], 1
;                 jmp .notEqual
;         .notEqual:
;         add r12, Transition_size
;         inc r14
;         cmp r14, r13
;         jl .loopS
;         jmp .while
;   .endWhile:
;     mov rdi, [rsp + .boolArr]
;     call free
;     mov rsi, [rsp + .queue]
;     lea rdi, [rsi + Queue.array]
;     call free
;     mov rdi, [rsp + .queue]
;     call free
;     mov rax, 1
;     leave 
;     ret

;   .acceptStateReached:
;     mov rdi, [rsp + .boolArr]
;     call free
;     mov rsi, [rsp + .queue]
;     lea rdi, [rsi + Queue.array]
;     call free
;     mov rdi, [rsp + .queue]
;     call free
;     mov rax, 0
;     leave 
;     ret

isAcceptReachable:
  push    rbp
  mov     rbp, rsp
  sub     rsp, 64
  mov     qword [rbp-56], rdi
  mov     rax, qword [rbp-56]
  mov     eax, dword [rax+16]
  cdqe
  mov     rdi, rax
  call    malloc
  mov     qword [rbp-16], rax
  mov     dword [rbp-4], 0
  jmp     .L15

  .L16:
        mov     eax, dword [rbp-4]
        mov   rdx, rax
        mov     rax, qword [rbp-16]
        add     rax, rdx
        mov     byte [rax], 0
        add     dword [rbp-4], 1

  .L15:
        mov     rax, qword [rbp-56]
        mov     eax, dword [rax+16]
        cmp     dword [rbp-4], eax
        jl      .L16
        mov     rax, qword [rbp-56]
        mov     eax, dword [rax+16]
        mov     edi, eax
        call    createQueue
        mov     qword [rbp-24], rax
        mov     rax, qword [rbp-56]
        mov     edx, dword [rax+24]
        mov     rax, qword [rbp-24]
        mov     esi, edx
        mov     rdi, rax
        call    enqueue
        mov     rax, qword [rbp-56]
        mov     eax, dword [rax+24]
        mov   rdx, rax
        mov     rax, qword [rbp-16]
        add     rax, rdx
        mov     byte [rax], 1
        jmp     .L17

  .L23:
        mov     rax, qword [rbp-24]
        mov     rdi, rax
        call    dequeue
        mov     dword [rbp-28], eax
        mov     rax, qword [rbp-56]
        mov     rax, qword [rax]
        mov     edx, dword [rbp-28]
        mov   rdx, rdx
        sal     rdx, 3
        add     rax, rdx
        movzx   eax, byte [rax+4]
        test    al, al
        je      .L18
        mov     rax, qword [rbp-16]
        mov     rdi, rax
        call    free
        mov     rax, qword [rbp-24]
        mov     rax, qword [rax+16]
        mov     rdi, rax
        call    free
        mov     rax, qword [rbp-24]
        mov     rdi, rax
        call    free
        mov     eax, 0
        jmp     .L19

.L18:
        mov     dword [rbp-8], 0
        jmp     .L20
.L22:
        mov     rax, qword [rbp-56]
        mov     rcx, qword [rax+8]
        mov     eax, dword [rbp-8]
        mov   rdx, rax
        mov     rax, rdx
        add     rax, rax
        add     rax, rdx
        sal     rax, 2
        add     rax, rcx
        mov     rdx, qword [rax]
        mov     qword [rbp-44], rdx
        mov     eax, dword [rax+8]
        mov     dword [rbp-36], eax
        mov     eax, dword [rbp-44]
        cmp     dword [rbp-28], eax
        jne     .L21
        mov     eax, dword [rbp-40]
        mov     dword [rbp-32], eax
        mov     eax, dword [rbp-32]
        mov   rdx, rax
        mov     rax, qword [rbp-16]
        add     rax, rdx
        movzx   eax, byte [rax]
        xor     eax, 1
        test    al, al
        je      .L21
        mov     edx, dword [rbp-32]
        mov     rax, qword [rbp-24]
        mov     esi, edx
        mov     rdi, rax
        call    enqueue
        mov     eax, dword [rbp-32]
        mov   rdx, rax
        mov     rax, qword [rbp-16]
        add     rax, rdx
        mov     byte [rax], 1

  .L21:
        add     dword [rbp-8], 1
.L20:
        mov     rax, qword [rbp-56]
        mov     eax, dword [rax+20]
        cmp     dword [rbp-8], eax
        jl      .L22
.L17:
        mov     rax, qword [rbp-24]
        mov     rdi, rax
        call    isEmpty
        xor     eax, 1
        test    al, al
        jne     .L23
        mov     rax, qword [rbp-16]
        mov     rdi, rax
        call    free
        mov     rax, qword [rbp-24]
        mov     rax, qword [rax+16]
        mov     rdi, rax
        call    free
        mov     rax, qword [rbp-24]
        mov     rdi, rax
        call    free
        mov     eax, 1
.L19:
        leave
        ret