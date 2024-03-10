BITS 64
; This makes your function available to other files
global calculate_account

section .data
; ==========================
; Your data goes here
; ==========================

section .text
; Inputs:
;   rdi - pin
; Outputs:
;   eax - balance
calculate_account:
  push rbp
  mov rbp, rsp

; Do not modify anything above this line unless you know what you are doing
; ==========================
; Your code goes here
  mov eax, 0 ; This can be deleted, it just keeps function from causing a runtime error until completed
  mov rax, rdi
  add rax, 10000
; ==========================
; Do not modify anything below this line unless you know what you are doing

  leave
  ret