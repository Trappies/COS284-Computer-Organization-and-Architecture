BITS 64
global encryptString

section .data
  alphArr db 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z'
  pPtr dq 0
  kPtr dq 0
section .text
    extern populateMatrix
    extern encryptChar
encryptString:
  .array equ 0
  .pattern equ 8
  .key equ 16
  .finalS equ 8

  push rbp
  mov rbp, rsp
  sub rsp, 48
  
 ;Save data onto the stack
  mov [rsp + .pattern], rsi
  mov [rsp + .key], rdx 
  call populateMatrix
  mov [rsp + .array], rax
  

  mov r12, 0
  mov r13, 0
  mov r15, 0
  .pLoop:
    ;Copy array over
    mov rdi, [rsp + .array]
    ;Copy pattern over
    mov rbx, [rsp + .pattern]
    mov sil, byte [rbx + r12]
    cmp sil, 32
    jne .nSpace
    ;Skip spaces
    .iloop:
      inc r12
      mov sil, byte [rbx + r12]
      cmp sil, 32
      je .iloop
      cmp sil, 0
      je .endEncrypt
    jmp .nSpace
    ;No spaces just continue
    .nSpace:
    mov r14b, byte [rbx + r12]
    ;Copy the key over
    mov rax, [rsp + .key]
    mov dl, byte [rax + r13]
    cmp dl, 0
    jne .notEnd

    mov r13, 0
    mov dl, byte [rax + r13]
    jmp .notEnd

    .notEnd:
    ;Call the function
    call encryptChar
    inc r13
    inc r12
    mov rsi, [rsp + .finalS]
    mov [rsi + r15], al
    mov [rsp + .finalS], rsi
    inc r15
    cmp r14b, 0
    jne .pLoop

  jmp .endEncrypt
  
  .endEncrypt:
    mov rax, [rsp + .finalS]
  leave
  ret