BITS 64
%include "constants.inc"
global isEmpty
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

; isEmpty:
; .queue equ 0
;   .result equ 8
  
;   push rbp
;   mov rbp, rsp
;   sub rsp, 16
;   ;Store the queue
;   mov [rsp + .queue], rdi
;   ;Compare the size with 0
;   mov rcx, [rdi + Queue.size]
;   cmp rcx, 0
;   jne .not_empty
;   mov rax, 1
;   leave 
;   ret
  
;   .not_empty:
;     mov rax, 0
;     leave
;     ret

isEmpty:
        push    rbp
        mov     rbp, rsp
        mov     qword [rbp-8], rdi
        mov     rax, qword [rbp-8]
        mov     eax, dword [rax+8]
        test    eax, eax
        sete    al
        pop     rbp
        ret