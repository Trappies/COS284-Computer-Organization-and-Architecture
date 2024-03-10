BITS 64
global allocateBook

section .data
c dq 0  
struc Book
      c_isbn resb 13
      c_title resb 50
      align 4
      c_price resd 1
      align 4 
      c_quantity resd 1
endstruc

      

section .text
extern malloc
extern strcpy

allocateBook:
  .isbn equ 0
  .quantity equ 8
  .price equ 16
  .titleArr equ 24

  push rbp
  mov rbp, rsp
  sub rsp, 64
  ;Store all the details onto the stack
  ;mov r11, qword [rdi]
  mov [rsp + .isbn], rdi
  ;mov r12, [rsi]
  mov [rsp + .titleArr], rsi
  movss [rsp + .price], xmm0
  mov [rsp + .quantity], rdx
  ;Call malloc to allocate space to the struct    
  mov rdi, Book_size
  call malloc
  mov [c], rax ;Save the pointer for the struct
  ;Copy isbn into the struct
  lea rdi, qword[rax + c_isbn]
  mov rsi, qword[rsp + .isbn]
  call strcpy
  mov rax, [c]
  ;Copy title into the struct
  lea rdi, [rax + c_title]
  mov rsi, [rsp + .titleArr]
  call strcpy
  mov rax, [c]
  ; Copy quantity into the struct
  movss xmm0, [rsp + .price]
  movss [rax + c_price], xmm0
  ; Copy quantity into the struct
  mov edx, [rsp + .quantity]
  mov [rax + c_quantity], edx
  mov rax, [c]
  leave
  ret