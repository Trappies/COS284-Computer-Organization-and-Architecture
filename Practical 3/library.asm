BITS 64
extern malloc
extern strcpy
extern strcmp
extern allocateBook

global initialiseLibrary
global searchBookByISBN
global addBook
section .data
  c dq 0
  d dq 0
struc Book
      c_isbn resb 13
      c_title resb 50
      align 4
      c_price resd 1
      align 4 
      c_quantity resd 1
endstruc

struc Library
    c_books resb 5*Book_size
    align 4
    c_count resd 1
endstruc

section .text

initialiseLibrary:
  push rbp
  mov rbp, rsp
  mov rdi, Library_size
  call malloc
  ;Save pointer
  mov [c], rax
  ;Place 0 into the counter
  mov ebx, 0
  mov dword [rax + c_count], ebx
  mov rax, [c]
  ;Initialise empty array
  mov rdi, 5
  imul rdi, Book_size
  call malloc
  mov rbx, [c]
  mov [rbx + c_books], rax
  mov rax, rbx
  leave
  ret

addBook:
  .lib equ 0
  .book equ 8

  push rbp
  mov rbp, rsp
  sub rsp, 32
  ;Store the pointers
  mov [rsp + .lib], rdi
  mov [rsp + .book], rsi
  ;Check if the struct is full
  mov rdi, [rsp + .lib]
  mov r14, [rsp + .lib]
  mov r15, [rsp + .book]
  mov ebx, [rdi + c_count]
  cmp rbx, 5
  je return_zero
  ;Check if there are no books
  mov r13, [rdi + c_books]
  mov r12, [rsp + .book]
  cmp rbx, 0
  je return_one
  ;Check if the there is already a book with the same ISBN number
  mov r12, [rsp + .book]
  mov rdi, [rsp + .lib]
  lea rsi, [r12 + c_isbn]
  call searchBookByISBN
  cmp rax, 0
  jne add_one
  ; .loop:
    
  ;   cmp rax, 0
  ;   jne add_one
  ;   add r13, Book_size
  ;   inc r15
  ;   cmp r15, rbx
  ;   jl .loop
  jmp return_one

  add_one:
    mov r12, [rsp + addBook.book]
    mov ebx, [r12 + c_quantity]
    add dword[rax + c_quantity], ebx
    mov rax, 1
    leave
    ret

  return_one:
    mov r14, [rsp + addBook.lib]
    mov rcx, [r14 + c_count]
    imul rcx, Book_size
    lea rdi, [r14 + c_books]
    add rdi, rcx

    mov rsi, r15

    mov rcx, Book_size
    rep movsb

    inc dword [r14 + c_count]
    mov rax, 1
    leave 
    ret
  return_zero:
    mov rax, 0
    leave
    ret

searchBookByISBN:
  .libP equ 0
  .isbnP equ 8
  .finalP equ 16

  push rbp
  mov rbp, rsp
  sub rsp, 32
  ;Store the parameters
  mov [rsp + .libP], rdi
  mov [rsp + .isbnP], rsi
  ;Search for the book in the array
  mov r11, 0
  mov rdi, [rsp + .libP]
  lea r12, [rdi + c_books]
  mov r13, [rdi + c_count]
  .loop:
    lea rdi, [r12 + c_isbn]
    mov rsi, [rsp + .isbnP]
    call strcmp
    cmp rax, 0
    je found
    add r12, Book_size
    inc r11
    cmp r11, r13
    jl .loop
  jmp not_found
  
  found:
    mov rax, r12
    leave
    ret

  not_found:
    mov rax, 0
    leave
    ret