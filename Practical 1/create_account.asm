; This tells the function that these exist outside of this file
extern greeting
extern get_pin
extern obscure_pin
extern calculate_balance
extern calculate_account

; This makes your function available to other files
global create_account

section .data
; ==========================
; Your data goes here
  acc_ptr dq 0
  pin_ptr dq 0
  bal_ptr dq 0
  acc_num_val dd 0
  pin_val dd 0
  ob_pin dq 0
  pin_msg db "Your obscured PIN is:"
  bal_msg db "Your balance is:"
  acc_msg db "Your account number is:"
  a_pin db 0
  newline db 10, 0
  buf times 10 db 0
; ==========================

section .text
; void create_account(char *account_number, char *obscured_pin, char *balance)
; 
; Inputs:
;   rdi - account number
;   rsi - pin
;   rdx - balance
; 
; README:
; A lot has been given to start you off. You should be able to complete this without fully understanding how
; the functions work. I recommend using the foundation provided, however, you are free to change it as you see fit.
create_account:
  push rbp
  mov rbp, rsp
  sub rsp, 32

  ;mov qword [acc_ptr], rdi
  mov qword [pin_ptr], rsi
  mov qword [bal_ptr], rdx

  ; Greet the user (Diplomacy)
  call greeting
  mov rax, 1
  mov rdi, 1
  lea rsi, [newline]
  mov rdx, 1
  syscall
  ; Get the pin as a 32 bit integer
  call get_pin ; Call get_pin function
  mov [pin_val], eax  ; save pin

  ; Calculate the account number
  mov edi, eax
  call calculate_account
  mov [acc_num_val], eax  ; save account number
 
  ; Calculate the balance
  mov edi, eax  ; set account number as the first argument to calculate balance
  mov esi, [pin_val]  ; set pin as the second argument to calculate balance
  call calculate_balance

  mov [bal_ptr], rax
  ; Convert the balance to ascii and store it in the balance pointer

  ; Convert the pin to ascii and store it in the pin pointer
  ; ; dec rcx
  ; ; xor rdi, rdi
  ; ; .loop2:
  ; ;   cmp rcx, 1
  ; ;   je .exit_l
  ; ;   mov al, [rsi+rdi]
  ; ;   mov ah, [rsi+rcx]
  ; ;   mov [rsi+rdi], ah
  ; ;   mov [rsi+rcx], al
  ; ;   inc rdi
  ; ;   dec rcx
  ; ;   ;cmp rdi, rcx
  ; ;   jmp .loop2
  ; ; .exit_l
  ; mov qword [pin_ptr], rsi
  ; Convert the account number to ascii and store it in the account number pointer
  
  ;Output account message
    mov rax, 1
    mov rdi, 1
    lea rsi , [acc_msg]
    mov rdx, 23
    syscall

    mov rax, 1
    mov rdi, 1
    lea rsi, [newline]
    mov rdx, 1
    syscall

  ;Conversion
  mov eax, [acc_num_val]
  mov rdi, buf
  xor rcx, rcx
  
  .loop3:
    mov rdx, 0
    mov rbx, 10
    div rbx
    add dl, '0'
    mov [acc_ptr+rcx], dl
    inc rcx
    cmp rax, 0
    jne .loop3

  mov al, [acc_ptr+4]
  mov ah, [acc_ptr]
  mov [acc_ptr+4], ah
  mov [acc_ptr], al

  mov al, [acc_ptr+1]
  mov ah, [acc_ptr+3]
  mov [acc_ptr +1], ah
  mov [acc_ptr+3], al
  mov rsi, acc_ptr
  ;Output account number
    mov rax, 1
    mov rdi, 1
    ;lea rsi, [acc_ptr]
    mov rdx, 5 ; I changed from 1 to 5 - Joshua
    syscall

    mov rax, 1
    mov rdi, 1
    lea rsi, [newline]
    mov rdx, 1
    syscall
; Output balance message
mov rax, 1
mov rdi, 1
lea rsi, [bal_msg]
mov rdx, 16
syscall

mov rax, 1
mov rdi, 1
lea rsi, [newline]
mov rdx, 1
syscall

; Convert balance to ASCII and store it in buf
mov eax, [bal_ptr]
mov rsi, buf
xor rcx, rcx

.bal_loop:
    mov rdx, 0
    mov rbx, 10
    div rbx
    add dl, '0'
    mov [rsi+rcx], dl
    inc rcx
    cmp rax, 0
    jne .bal_loop

; Reverse the string in buf
mov rcx, 5 ; Change this value to match the number of digits in your balance.
dec rcx
xor rdi, rdi

.loop2:
    cmp rcx, 1
    je .exit_l
    mov al, [rsi+rdi]
    mov ah, [rsi+rcx]
    mov [rsi+rdi], ah
    mov [rsi+rcx], al
    inc rdi
    dec rcx
    jmp .loop2

.exit_l:

; Output balance
mov rax, 1
mov rdi, 1
lea rsi, [buf]
mov rdx, 5 ; Change this value to match the number of digits in your balance.
syscall

mov rax, 1
mov rdi, 1
lea rsi, [newline]
mov rdx, 1
syscall

  ; ; Obsfucate the pin

  ; Output pin message
    mov rax, 1
    mov rdi, 1
    lea rsi, [pin_msg]
    mov rdx, 21
    syscall
    
    mov rax, 1
    mov rdi, 1
    lea rsi, [newline]
    mov rdx, 1
    syscall
  ;Conversion
  mov eax, [pin_val]
  mov rsi, buf
  xor rcx, rcx

  .loop:
    mov rdx, 0
    mov rbx, 10
    div rbx
    add dl, '0'
    mov [rsi+rcx], dl
    inc rcx
    cmp rax, 0
    jne .loop

  mov al, [rsi+3]
  mov ah, [rsi]
  mov [rsi+3], ah
  mov [rsi], al

  mov al, [rsi+1]
  mov ah, [rsi+2]
  mov [rsi+1], ah
  mov [rsi+2], al
  mov qword [pin_ptr], rsi
  ; Output obscured pin
    mov rdi, qword[pin_ptr]
    call obscure_pin
    ;mov , rsi
    mov rax, 1
    mov rdi, 1
    mov rdx, 4
    syscall

    mov rax, 1
    mov rdi, 1
    lea rsi, [newline]
    mov rdx, 1
    syscall
  leave
  ret
