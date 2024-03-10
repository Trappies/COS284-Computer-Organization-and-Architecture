BITS 64
%include "constants.inc"
global isFull
section .data
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

; isFull:
;   .queue equ 0
;   .result equ 8
  
;   push rbp
;   mov rbp, rsp
;   sub rsp, 16
;   ;Store the queue
;   mov [rsp + .queue], rdi

;   mov rcx, [rdi + Queue.size]
;   mov rdx, [rdi + Queue.capacity]
;   cmp rcx, rdx
;   jne .notFull
;   mov rax, 1
;   leave
;   ret

;   .notFull:
;   mov rax, 0
;   leave 
;   ret

isFull:
        push    rbp
        mov     rbp, rsp
        mov     qword [rbp-8], rdi
        mov     rax, qword [rbp-8]
        mov     eax, dword [rax+8]
        mov     edx, eax
        mov     rax, qword [rbp-8]
        mov     eax, dword [rax+12]
        cmp     edx, eax
        sete    al
        pop     rbp
        ret