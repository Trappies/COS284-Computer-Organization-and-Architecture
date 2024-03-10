BITS 64
; This makes your function available to other files
global greeting

section .data
; ==========================
; Your data goes here
; ==========================
  welcome_message db "Welcome to the Bank of <<Redacted>>", 0

section .text
; void greeting()
; This function prints a greeting to the screen
greeting:
  push rbp
  mov rbp, rsp
; Do not modify anything above this line unless you know what you are doing
; ==========================
; Your code goes here
  mov rax, 1          
  mov rdi, 1          
  lea rsi, [welcome_message]
  mov rdx, 35         
  syscall
; ==========================
; Do not modify anything below this line unless you know what you are doing
  leave
  ret