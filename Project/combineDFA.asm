BITS 64
%include "constants.inc"
global combineDFA
section .data

section .text
extern strcmp
extern initDfa
extern malloc

; combineDFA:
;   .dfa1 equ 0
;   .dfa2 equ 8
;   .dfaF equ 16
;   .numSt equ 24
;   .numTr equ 32
;   .tempState1 equ 40
;   .tempState2 equ 48
;   .from equ 56
;   .to equ 64
;   .fromT equ 72
;   .toT equ 80
;   .tt equ 88

;   push rbp
;   mov rbp, rsp
;   sub rsp, 96

;   mov [rsp + .dfa1], rdi
;   mov [rsp + .dfa2], rsi

;   mov rcx, [rdi + DFA.numStates]
;   imul rcx, [rsi + DFA.numStates]
;   mov [rsp + .numSt], rcx

;   mov rcx, [rdi + DFA.numTransitions]
;   imul rcx, [rsi + DFA.numTransitions]
;   mov [rsp + .numTr], rcx
;   ;Call initDFA
;   mov rdi, [rsp + .numSt]
;   mov rsi, [rsp + .numTr]
;   call initDfa
;   ;Initialise starting state
;   mov dword [rax + DFA.startState], 0
;   mov [rsp + .dfaF], rax

;   ;Getting the combined states
;   mov r15, [rsp + .dfa1]
;   mov r14, [rsp + .dfa2]
;   mov r13, [rsp + .dfaF]
;   mov rbx, 0
;   .loopO:
;     mov r12, 0
;     jmp .loopI
;     .loopI:
;       mov rdi, State_size
;       call malloc
;       ;Set the state id to idVal
;       mov r8, rbx
;       imul r8, [r14 + DFA.numStates]
;       add r8, r12
;       mov dword [rax + State.id], r8d
;       mov [rsp + .tt], rax 
;       ;Get whether the state is accepting or not
;       ;Get first state
;       mov rax, [r15 + DFA.states]
;       mov r9, rbx
;       imul r9, State_size
;       add rax, r9
;       mov [rsp + .tempState1], rax
;       ;Get second state
;       mov rax, [r14 + DFA.states]
;       mov r9, r12
;       imul r9, State_size
;       add rax, r9
;       mov [rsp + .tempState2], rax
;       ;Check isAccepting
;       movzx r9, byte [rax + State.isAccepting]
;       cmp r9, 1
;       je .secondTrue
;       jmp .secondFalse

;       .secondTrue:
;         mov rax, [rsp + .tempState1]
;         movzx r9, byte [rax + State.isAccepting]
;         cmp r9, 0
;         je .setTrue
;         jmp .setFalse

;       .secondFalse:
;         mov rax, [rsp + .tempState1]
;         movzx r9, byte [rax + State.isAccepting]
;         cmp r9, 0
;         je .setFalse
;         jmp .setTrue

;       .setTrue:
;         mov rax, [rsp + .tt]
;         mov rsi, 1
;         mov byte [rax + State.isAccepting], sil
;         mov [rsp + .tt], rax

;         mov rdi, [r13 + DFA.states]
;         imul r8, State_size
;         add rdi, r8
;         mov r9, [rsp + .tt]
;         mov rsi, r9
;         mov rcx, State_size
;         rep movsb
;         jmp .incLoop
;       .setFalse:
;         mov rax, [rsp + .tt]
;         mov rsi, 0
;         mov byte [rax + State.isAccepting], sil
;         mov [rsp + .tt], rax

;         mov rdi, [r13 + DFA.states]
;         imul r8, State_size
;         add rdi, r8
;         mov rsi, [rsp + .tt]
;         mov rcx, State_size
;         rep movsb
;         jmp .incLoop
;       .incLoop:
;       inc r12
;       mov rax, [r14 + DFA.numStates]
;       cmp r12d, eax
;       jl .loopI
;       jmp .afterI
;     .afterI:
;       inc rbx
;       mov rax, [r15 + DFA.numStates]
;       cmp ebx, eax
;       jl .loopO
;       jmp .nextTr

;   .nextTr:
;   ;Getting the combined transitions
;   mov rdi, [rsp + .dfa1]
;   mov rsi, [rsp + .dfa2]
;   mov r14, [rsp + .dfaF]
;   mov rbx, 0
;   mov r13, 0
;   .loopOT:
;     mov r12, 0
;     jmp .loopIT
;     .loopIT:
;       ;Test if they have the same symbol 
;       mov rax, [rdi + DFA.transitions]
;       mov r9, rbx
;       imul r9, Transition_size
;       add rax, r9
;       movzx rax, byte [rax + Transition.symbol]
;       mov rdx, [rsi + DFA.transitions]
;       mov r9, r12
;       imul r9, Transition_size
;       add rdx, r9
;       movzx rdx, byte [rdx + Transition.symbol]
;       cmp rax, rdx
;       jne .afterIT
;       ;Set transitions
;       ;Get from
;       mov rax, [rdi + DFA.transitions]
;       mov r9, rbx
;       imul r9, Transition_size
;       add rax, r9
;       mov rcx, [rax + Transition.from]
;       mov [rsp + .fromT], rcx

;       mov rax, [rsi + DFA.transitions]
;       mov r9, r12
;       imul r9, Transition_size
;       add rax, r9
;       mov rcx, [rax + Transition.from]
;       mov r11, [rsi + DFA.numStates]
;       mov r8, [rsp + .fromT]
;       imul r8, r11
;       add r8, rcx
;       mov [rsp + .from], r8
;       ;Get to
;       mov rax, [rdi + DFA.transitions]
;       mov r9, rbx
;       imul r9, Transition_size
;       add rax, r9
;       mov rcx, [rax + Transition.to]
;       mov [rsp + .toT], rcx

;       mov rax, [rsi + DFA.transitions]
;       mov r9, r12
;       imul r9, Transition_size
;       add rax, r9
;       mov rcx, [rax + Transition.to]
;       mov r11, [rsi + DFA.numStates]
;       mov r8, [rsp + .toT]
;       imul r8, r11
;       add r8, rcx
;       mov [rsp + .to], r8
;       ;Set transition
;       mov rax, [r14 + DFA.transitions]
;       mov r9, r13
;       imul r9, Transition_size
;       add rax, r9
;       mov ecx, dword [rsp + .from]
;       mov [rax + Transition.from], rcx
;       mov ecx, dword [rsp + .to]
;       mov [rax + Transition.to], rcx
;       mov [rax + Transition.symbol], rdx
;       ;Increment transition counter
;       inc r13
;       inc r12
;       cmp r12, [rsi + DFA.numTransitions]
;       jl .loopIT
;       jmp .afterIT
;     .afterIT:
;       inc rbx
;       cmp rbx, [rdi + DFA.numTransitions]
;       jl .loopOT
;       jmp .returnDFA

;   .returnDFA:
;     mov rax, [rsp + .dfaF] 
;     leave
;     ret

combineDFA:
  push    rbp
  mov     rbp, rsp
  sub     rsp, 80
  mov qword[rbp-72], rdi
  mov qword[rbp-80], rsi
  mov rax, qword[rbp-72]
  mov edx, dword[rax+16]
  mov rax, qword[rbp-80]
  mov eax, dword[rax+16]
  imul eax, edx
  mov dword[rbp-24], eax
  mov rax, qword [rbp-72]
  mov edx, dword [rax+20]
  mov rax, qword [rbp-80]
  mov eax, dword [rax+20]
  imul eax, edx
  mov dword [rbp-28], eax
  mov edx, dword [rbp-28]
  mov eax, dword [rbp-24]
  mov esi, edx
  mov edi, eax
  mov eax, 0
  call initDfa
  cdqe
  mov qword [rbp-40], rax
  mov rax, qword[rbp-40]
  mov dword[rax+24], 0
  mov dword [rbp-4], 0
  jmp .L25
  .L32:
    mov dword [rbp-8], 0
    jmp .L26

  .L31:
    mov rax, qword[rbp-80]
    mov eax, dword[rax+16]
    imul eax, dword[rbp-4]
    mov edx, eax
    mov eax, dword[rbp-8]
    add eax, edx
    mov dword [rbp-52], eax
    mov rax, qword [rbp-40]
    mov rax, qword [rax]
    mov edx, dword [rbp-52]
    mov rdx, rdx
    sal rdx, 3
    add rdx, rax
    mov eax, dword [rbp-52]
    mov dword [rdx], eax
    mov rax, qword [rbp-72]
    mov rax, qword [rax]
    mov edx, dword [rbp-4]
    mov rdx, rdx
    sal rdx, 3
    add rax, rdx
    movzx eax, byte [rax+4]
    test al, al
    je .L27
    mov rax, qword [rbp-80]
    mov rax, qword [rax]
    mov edx, dword [rbp-8]
    mov rdx, rdx
    sal rdx, 3
    add rax, rdx
    movzx eax, byte [rax+4]
    xor eax, 1
    test al, al
    jne .L28
  
  .L27:
        mov     rax, qword [rbp-72]
        mov     rax, qword [rax]
        mov     edx, dword [rbp-4]
        mov   rdx, rdx
        sal     rdx, 3
        add     rax, rdx
        movzx   eax, byte [rax+4]
        xor     eax, 1
        test    al, al
        je      .L29
        mov     rax, qword [rbp-80]
        mov     rax, qword [rax]
        mov     edx, dword [rbp-8]
        mov   rdx, rdx
        sal     rdx, 3
        add     rax, rdx
        movzx   eax, byte [rax+4]
        test    al, al
        je      .L29

.L28:
        mov     ecx, 1
        jmp     .L30
.L29:
        mov     ecx, 0
.L30:
        mov     rax, qword [rbp-40]
        mov     rax, qword [rax]
        mov     edx, dword [rbp-52]
        mov   rdx, rdx
        sal     rdx, 3
        add     rdx, rax
        mov     eax, ecx
        and     eax, 1
        mov     byte [rdx+4], al
        add     dword [rbp-8], 1

.L26:
        mov     rax, qword [rbp-80]
        mov     eax, dword [rax+16]
        cmp     dword [rbp-8], eax
        jl      .L31
        add     dword [rbp-4], 1
.L25:
        mov     rax, qword [rbp-72]
        mov     eax, dword [rax+16]
        cmp     dword [rbp-4], eax
        jl      .L32
        mov     dword [rbp-12], 0
        mov     dword [rbp-16], 0
        jmp     .L33
.L37:
        mov     dword [rbp-20], 0
        jmp     .L34

.L36:
        mov     rax, qword [rbp-72]
        mov     rcx, qword [rax+8]
        mov     eax, dword [rbp-16]
        mov   rdx, rax
        mov     rax, rdx
        add     rax, rax
        add     rax, rdx
        sal     rax, 2
        add     rax, rcx
        movzx   ecx, byte [rax+8]
        mov     rax, qword [rbp-80]
        mov     rsi, qword [rax+8]
        mov     eax, dword [rbp-20]
        mov   rdx, rax
        mov     rax, rdx
        add     rax, rax
        add     rax, rdx
        sal     rax, 2
        add     rax, rsi
        movzx   eax, byte [rax+8]
        cmp     cl, al
        jne     .L35
        mov     rax, qword [rbp-72]
        mov     rcx, qword [rax+8]
        mov     eax, dword [rbp-16]
        mov   rdx, rax
        mov     rax, rdx
        add     rax, rax
        add     rax, rdx
        sal     rax, 2
        add     rax, rcx
        mov     edx, dword [rax]
        mov     rax, qword [rbp-80]
        mov     eax, dword [rax+16]
        mov     ecx, edx
        imul    ecx, eax
        mov     rax, qword [rbp-80]
        mov     rsi, qword [rax+8]
        mov     eax, dword [rbp-20]
        mov   rdx, rax
        mov     rax, rdx
        add     rax, rax
        add     rax, rdx
        sal     rax, 2
        add     rax, rsi
        mov     eax, dword [rax]
        add     eax, ecx
        mov     dword [rbp-44], eax
        mov     rax, qword [rbp-72]
        mov     rcx, qword [rax+8]
        mov     eax, dword [rbp-16]
        mov   rdx, rax
        mov     rax, rdx
        add     rax, rax
        add     rax, rdx
        sal     rax, 2
        add     rax, rcx
        mov     edx, dword [rax+4]
        mov     rax, qword [rbp-80]
        mov     eax, dword [rax+16]
        mov     ecx, edx
        imul    ecx, eax
        mov     rax, qword [rbp-80]
        mov     rsi, qword [rax+8]
        mov     eax, dword [rbp-20]
        mov   rdx, rax
        mov     rax, rdx
        add     rax, rax
        add     rax, rdx
        sal     rax, 2
        add     rax, rsi
        mov     eax, dword [rax+4]
        add     eax, ecx
        mov     dword [rbp-48], eax
        mov     rax, qword [rbp-40]
        mov     rcx, qword [rax+8]
        mov     eax, dword [rbp-12]
        mov   rdx, rax
        mov     rax, rdx
        add     rax, rax
        add     rax, rdx
        sal     rax, 2
        lea     rdx, [rcx+rax]
        mov     eax, dword [rbp-44]
        mov     dword [rdx], eax
        mov     rax, qword [rbp-40]
        mov     rcx, qword [rax+8]
        mov     eax, dword [rbp-12]
        mov   rdx, rax
        mov     rax, rdx
        add     rax, rax
        add     rax, rdx
        sal     rax, 2
        lea     rdx, [rcx+rax]
        mov     eax, dword [rbp-48]
        mov     dword [rdx+4], eax
        mov     rax, qword [rbp-72]
        mov     rcx, qword [rax+8]
        mov     eax, dword [rbp-16]
        mov   rdx, rax
        mov     rax, rdx
        add     rax, rax
        add     rax, rdx
        sal     rax, 2
        add     rcx, rax
        mov     rax, qword [rbp-40]
        mov     rsi, qword [rax+8]
        mov     eax, dword [rbp-12]
        mov   rdx, rax
        mov     rax, rdx
        add     rax, rax
        add     rax, rdx
        sal     rax, 2
        lea     rdx, [rsi+rax]
        movzx   eax, byte [rcx+8]
        mov     byte [rdx+8], al
        add     dword [rbp-12], 1

.L35:
        add     dword [rbp-20], 1
.L34:
        mov     rax, qword [rbp-80]
        mov     eax, dword [rax+20]
        cmp     dword [rbp-20], eax
        jl      .L36
        add     dword [rbp-16], 1
.L33:
        mov     rax, qword [rbp-72]
        mov     eax, dword [rax+20]
        cmp     dword [rbp-16], eax
        jl      .L37
        mov     rax, qword [rbp-40]
        leave
        ret