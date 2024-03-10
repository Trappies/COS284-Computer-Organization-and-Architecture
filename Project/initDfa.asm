%include "constants.inc"
global initDfa
extern malloc

section .text
;
; DFA *init_dfa(int numStates, int numTransitions)
;
initDfa:
  .numStates equ 0
  .numTransitions equ 4
  .dfa equ 8

  push rbp
  mov rbp, rsp
  ; Store the function arguments in the stack
  sub rsp, 16
  mov [rsp + initDfa.numStates], edi
  mov [rsp + initDfa.numTransitions], esi

  ; Allocate memory for a DFA struct
  ; Store the DFA pointer in the stack
  ; 
  ; DFA *dfa = malloc(sizeof(DFA));
  ; 
  mov rdi, DFA_size
  call malloc
  mov [rsp + initDfa.dfa], rax

  ; 
  ; dfa->numStates = numStates;
  ; dfa->numTransitions = numTransitions;
  ; dfa->startState = 0;
  ; 
  mov esi, [rsp + initDfa.numStates]
  mov [rax + DFA.numStates], esi
  mov esi, [rsp + initDfa.numTransitions]
  mov [rax + DFA.numTransitions], esi
  xor esi, esi
  mov [rax + DFA.startState], esi

  ; Allocate memory for the states array
  ; Store the states array pointer in the DFA struct
  ; 
  ; dfa->states = malloc(numStates * sizeof(State));

  mov edi, [rsp + initDfa.numStates]
  imul edi, edi, State_size
  call malloc
  mov rdi, [rsp + initDfa.dfa]
  mov [rdi + DFA.states], rax

  ; Allocate memory for the transitions array
  ; Store the transitions array pointer in the DFA struct
  ; 
  ; dfa->transitions = malloc(numTransitions * sizeof(Transition));
  ; 
  mov edi, [rsp + initDfa.numTransitions]
  imul edi, edi, Transition_size
  call malloc
  mov rdi, [rsp + initDfa.dfa]
  mov [rdi + DFA.transitions], rax

  ; Return the DFA pointer
  ; 
  ; return dfa;
  ;
  mov rax, [rsp + initDfa.dfa]
  leave
  ret