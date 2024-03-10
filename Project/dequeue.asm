BITS 64
%include "constants.inc"
global dequeue
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

; dequeue:
;   .queue equ 0
  
;   push rbp
;   mov rbp, rsp
;   sub rsp, 16
;   ;Store the queue
;   mov [rsp + .queue], rdi
;   ;Check if the queue is empty
;   call isEmpty
;   cmp rax, 1
;   je .fexit
;   ;Getting the front element
;   mov rdi, [rsp + .queue]
;   mov rcx, [rdi + Queue.front]
;   imul rcx, 4
;   lea rbx, [rdi + Queue.array]
;   add rbx, rcx
;   mov r13, [rbx]
;   ;Get the new front of the queue
;   mov rax, [rdi + Queue.front]
;   add rax, 1
;   mov rsi, [rdi + Queue.capacity]
;   xor rdx, rdx
;   div rsi
;   mov [rdi + Queue.front], rdx
;   ;Dec the size
;   dec dword [rdi + Queue.size]
;   ;Return the deleted element 
;   mov rax, r13
;   leave
;   ret
;   .fexit:
;     mov rax, -1
;     leave
;     ret

dequeue:
        push    rbp
        mov     rbp, rsp
        sub     rsp, 24
        mov     qword [rbp-24], rdi
        mov     rax, qword [rbp-24]
        mov     rdi, rax
        call    isEmpty
        test    al, al
        je      .L12
        mov     eax, -1
        jmp     .L13

  .L12:
        mov     rax, qword [rbp-24]
        mov     rdx, qword [rax+16]
        mov     rax, qword [rbp-24]
        mov     eax, dword [rax]
        cdqe
        sal     rax, 2
        add     rax, rdx
        mov     eax, dword [rax]
        mov     dword [rbp-4], eax
        mov     rax, qword [rbp-24]
        mov     eax, dword [rax]
        add     eax, 1
        mov     ecx, eax
        mov     rax, qword [rbp-24]
        mov     esi, dword [rax+12]
        mov     eax, ecx
        mov     edx, 0
        div     esi
        mov     ecx, edx
        mov     eax, ecx
        mov     edx, eax
        mov     rax, qword [rbp-24]
        mov     dword [rax], edx
        mov     rax, qword [rbp-24]
        mov     eax, dword [rax+8]
        lea     edx, [rax-1]
        mov     rax, qword [rbp-24]
        mov     dword [rax+8], edx
        mov     eax, dword [rbp-4]
.L13:
        leave
        ret