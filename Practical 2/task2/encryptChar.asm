BITS 64
global encryptChar

section .data
  alphArr db 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z'
  pPtr dq 0
  kPtr dq 0
section .text
encryptChar:
  .array equ 0
  .size equ 8
  .i equ 16

  push rbp
  mov rbp, rsp
  sub rsp, 32
  ;Get matrix from parameters 
  mov [rsp + .array], rdi

  ;Find column index
  mov rcx, 0
  mov qword [pPtr], rsi
  mov al, byte [pPtr]
  .cloop:
    cmp byte [alphArr + rcx], al
    je .cend
    inc rcx
    cmp rcx, 26
    jl .cloop
  ;Store the index of the column
  .cend:
  mov [rsp + .i], rcx

  ;Find row index
  mov rcx, 0
  mov qword [kPtr], rdx
  mov al, byte [kPtr]
  .rloop:
    cmp byte [alphArr + rcx], al
    je .rend
    inc rcx
    cmp rcx, 26
    jl .rloop

  ;Store the index of the row
  .rend:
  mov [rsp + .size], rcx

  ;Get index of character in matrix
    mov rbx, [rsp + .array]
    mov rdx, [rsp + .size]
    mov rcx, [rsp + .i]
    imul rdx, rdx, 8     ; Calculate the index in the matrix
    mov rdi, [rbx + rdx]
    mov al, byte [rdi + rcx]  ; Get the encrypted rune from the matrix

  leave
  ret