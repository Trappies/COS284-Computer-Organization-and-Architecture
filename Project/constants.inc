%ifndef __CONSTANTS__
%define __CONSTANTS__

SECTION .data
  struc State
    .id: resd 1
    .isAccepting: resb 1
    align 4
  endstruc

  struc Transition
    .from resd 1
    .to resd 1
    .symbol resb 1
    align 4
  endstruc

  struc DFA
    .states resq 1
    .transitions resq 1
    .numStates resd 1
    .numTransitions resd 1
    .startState resd 1
    align 8
  endstruc

%endif ; __CONSTANTS__