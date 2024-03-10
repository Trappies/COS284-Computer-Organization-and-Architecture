BITS 64
%include "constants.inc"
global createQueue
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
   extern malloc

; createQueue:
;   .cap equ 0
;   .queue equ 8
  
;   push rbp
;   mov rbp, rsp
;   sub rsp, 16
;   ;Store the queue
;   mov [rsp + .cap], rdi
;   ;Allocate memory for the queue
;   mov rdi, Queue_size
;   call malloc
;   mov rbx, [rsp + .cap]
;   mov [rax + Queue.capacity], rbx
;   mov rbx, 0
;   ;Set size and front of the queue
;   mov [rax + Queue.size], rbx
;   mov [rax + Queue.front], rbx
;   mov rbx, [rsp + .cap]
;   sub rbx, 1
;   mov [rax + Queue.rear], rbx
;   mov [rsp + .queue], rax
;   mov rbx, [rsp + .cap]
;   imul rbx, 4
;   mov rdi, rbx
;   call malloc
;   mov rbx, [rsp + .queue]
;   mov [rbx + Queue.array], rax
;   ;Return the Queue
;   mov rax, rbx
;   leave
;   ret

createQueue:
        push    rbp
        mov     rbp, rsp
        sub     rsp, 32
        mov     dword [rbp-20], edi
        mov     edi, 24
        call    malloc
        mov     qword [rbp-8], rax
        mov     rax, qword [rbp-8]
        mov     edx, dword [rbp-20]
        mov     dword [rax+12], edx
        mov     rax, qword [rbp-8]
        mov     dword [rax+8], 0
        mov     rax, qword [rbp-8]
        mov     edx, dword [rax+8]
        mov     rax, qword [rbp-8]
        mov     dword [rax], edx
        mov     eax, dword [rbp-20]
        sub     eax, 1
        mov     edx, eax
        mov     rax, qword [rbp-8]
        mov     dword [rax+4], edx
        mov     rax, qword [rbp-8]
        mov     eax, dword [rax+12]
        mov     eax, eax
        sal     rax, 2
        mov     rdi, rax
        call    malloc
        mov     rdx, rax
        mov     rax, qword [rbp-8]
        mov     qword [rax+16], rdx
        mov     rax, qword [rbp-8]
        leave
        ret