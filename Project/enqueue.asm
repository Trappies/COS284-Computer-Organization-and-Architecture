BITS 64
%include "constants.inc"
global enqueue
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
   extern isFull

; enqueue:
;   .item equ 0
;   .queue equ 8
  
;   push rbp
;   mov rbp, rsp
;   sub rsp, 16
;   ;Store the queue
;   mov [rsp + .queue], rdi
;   mov [rsp + .item], rsi
;   ;Check if the queue is full 
;   call isFull
;   cmp rax, 1
;   je .exit
;   ;Store the item in the queue
;   ;Dealing with queue->rear
;   mov rdi, [rsp + .queue]
;   mov rax, [rdi + Queue.rear]
;   add rax, 1
;   mov rbx, [rdi + Queue.capacity]
;   xor rdx, rdx
;   div rbx
;   mov [rdi + Queue.rear], rdx
;   ;Dealing with queue->array
;   mov rcx, rdx
;   imul rcx, 4
;   lea rbx, [rdi + Queue.array]
;   add rbx, rcx
;   mov rsi, [rsp + .item]
;   mov [rbx], rsi
;   ;Increment the size
;   inc dword [rdi + Queue.size]
;   jmp .exit
;   .exit:
;     leave
;     ret

enqueue:
        push    rbp
        mov     rbp, rsp
        sub     rsp, 16
        mov     qword [rbp-8], rdi
        mov     dword [rbp-12], esi
        mov     rax, qword [rbp-8]
        mov     rdi, rax
        call    isFull
        test    al, al
        jne     .L10
        mov     rax, qword [rbp-8]
        mov     eax, dword [rax+4]
        add     eax, 1
        mov     ecx, eax
        mov     rax, qword [rbp-8]
        mov     esi, dword [rax+12]
        mov     eax, ecx
        mov     edx, 0
        div     esi
        mov     ecx, edx
        mov     eax, ecx
        mov     edx, eax
        mov     rax, qword [rbp-8]
        mov     dword [rax+4], edx
        mov     rax, qword [rbp-8]
        mov     rdx, qword [rax+16]
        mov     rax, qword [rbp-8]
        mov     eax, dword [rax+4]
        cdqe
        sal     rax, 2
        add     rdx, rax
        mov     eax, dword [rbp-12]
        mov     dword [rdx], eax
        mov     rax, qword [rbp-8]
        mov     eax, dword [rax+8]
        lea     edx, [rax+1]
        mov     rax, qword [rbp-8]
        mov     dword [rax+8], edx
        jmp     .L7
.L10:
        nop
.L7:
        leave
        ret