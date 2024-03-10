BITS 64
; This makes your function available to other files
global calculate_balance

section .data
; ==========================
; Your data goes here
  rem dq 0
; ==========================

section .text
; Calculate balance based on account number and pin
; Inputs:
;   rdi - account number
;   rsi - pin
; Outputs:
;   eax - balance
calculate_balance:
  push rbp
  mov rbp, rsp
  
; Do not modify anything above this line unless you know what you are doing
; ==========================
; Your code goes here
; Adding the pin to the account number
  mov rax, rdi
  add rax, rsi 
; Multiply the result by P
  mul rsi
  ;XOR operation of the outer right bracket
  mov rbx, rdi
  xor rbx, rsi
  ; AND operation of the two outer brackets
  and rax, rbx
  ; MOD the result with 50000
  mov rdx, 0
  mov rcx, 50000
  div ecx 
  mov [rem], rdx
  mov rax, [rem]
  ;ADD 50000 to the remainder of the of the 
  add rax, rcx
   ; This can be deleted, it just keeps function from causing a runtime error until completed
; ==========================
; Do not modify anything below this line unless you know what you are doing
  leave
  ret