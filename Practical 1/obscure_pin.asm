global obscure_pin

section .data
; ==========================
; Your data goes here
; ==========================

; void obscure_pin(char* pin)
; Obscures a 4-digit ASCII PIN in place.
; Assumes pin is in rdi.
section .text
obscure_pin:
  push rbp
  mov rbp, rsp
; Do not modify anything above this line unless you know what you are doing
; ==========================
; Your code goes here

  mov rsi, rdi

  mov rdi, rsi
  mov rcx, 4

.obscure_loop:
  mov al, byte [rdi]
  sub al, 48
  xor al, 0xF
  add al, 48
  mov [rdi], al

  inc rdi
  loop .obscure_loop

  ; Reverse the obfuscated PIN
  mov rdi, rsi
  mov rsi, rdi
  lea rsi, [rsi + 3]
  mov rax, 0
  mov rcx, 2

.reverse_loop:
  mov al, byte [rsi]
  mov ah, byte [rdi]
  mov [rdi], al
  mov [rsi], ah
  inc rdi
  dec rsi             
  loop .reverse_loop

; ==========================
; Do not modify anything below this line unless you know what you are doing
  leave
  ret
