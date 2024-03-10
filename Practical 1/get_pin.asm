BITS 64
global get_pin

section .data
prompt db "Enter 4-digit PIN: ", 0
input_buffer db 6

section .text
get_pin:
  push rbp
  mov rbp, rsp
; Do not modify anything above this line unless you know what you are doing
; ==========================
; Your code goes here
; 
; Print the message that asks for a pin
; 
; Read the pin from stdin and store it in a buffer
; 
; Convert the pin to an integer
;
  mov rax, 1
  mov rdi, 1
  lea rsi, [prompt]
  mov rdx, 19
  syscall

  mov rax, 0
  mov rdi, 0
  lea rsi, [input_buffer]
  mov rdx, 6
  syscall

  xor rax, rax
  xor rcx, rcx

.loop:
  movzx rdx, byte [input_buffer + rcx]
  cmp rdx, 10
  je .done
  sub rdx, '0'
  imul rax, rax, 10
  add rax, rdx
  inc rcx
  jmp .loop

.done:
; ==========================
; Do not modify anything below this line unless you know what you are doing
  leave
  ret
