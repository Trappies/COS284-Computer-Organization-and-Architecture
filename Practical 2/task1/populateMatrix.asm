; This makes your function available to other files
BITS 64
global populateMatrix

section .data
; ==========================
; Your data goes here
  alphArr db 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z'
  dimension dq 26
  arrPtr dq 0
; ==========================

section .text
  
  extern malloc
  
populateMatrix:
  .array equ 0
  .size equ 8
  .i equ 16
     
  push rbp
  mov rbp, rsp
  sub rsp, 32
; Do not modify anything above this line unless you know what you are doing
; ==========================
;Allocate the dynamic array
  mov rdi, 208
  call malloc
  mov [rsp + .array], rax
;Allocate each row's memory to the array
mov rcx, 0
mov r12, 0
mov [rsp + .i], rcx

.rloop:
  mov rdi, 26
  call malloc
  mov rcx, [rsp + .i]
  mov rsi, [rsp + .array]
  mov rbx, r12
  mov rdx, 0
  .iloop:
    mov r8b, byte [alphArr + rbx]
    mov [rax + rdx], r8b
    inc rbx
    inc rdx
    cmp rbx, 26
    jl .iloop

  mov rbx, 0
  .floop
    cmp rbx, r12
    jge .fdone
    mov r8b, byte [alphArr + rbx]
    mov [rax + rdx], r8b
    inc rbx
    inc rdx
    cmp rbx, r12
    jmp .floop

  .fdone:
  mov qword [rsi + rcx], rax
  add rcx, 8
  inc r12
  mov [rsp + .i], rcx
  mov [rsp + .array], rsi
  cmp rcx, 200
  jle .rloop
  
  mov rax, [rsp + .array]
  leave
  ret