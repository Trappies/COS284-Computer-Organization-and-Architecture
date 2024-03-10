BITS 64
%include "constants.inc"
global sameLanguage
section .data

section .text
extern strcmp
extern initDfa
extern simulateDfa
extern malloc
extern free
extern combineDFA
extern isAcceptReachable

sameLanguage:
  .dfa1 equ 0
  .dfa2 equ 8
  .dfaF equ 16
  .result equ 24
  
  push rbp
  mov rbp, rsp
  sub rsp, 32

  ;Store the DFA's  
  mov [rsp + .dfa1], rdi
  mov [rsp + .dfa2], rsi
  ;Combine the DFA's
  call combineDFA
  mov [rsp + .dfaF], rax
  mov rdi, rax
  ;Run the BFS to check if it reaches an accepting state
  call isAcceptReachable
  mov [rsp + .result], rax ; Store the result
  ;Free the combined DFA
  mov rdi, [rsp + .dfaF]
  call free
  ;Return the result
  mov rax, [rsp + .result]
  leave
  ret
  
