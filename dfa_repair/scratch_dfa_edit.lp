% Edit operations:
%  - add delta(S,A,S')
%  - remove delta(S,A,S')
%  - accepting(S)
%  - remove accepting(S)

{ add(delta(S,A,S'): state(S'), not delta(S,A,S') } :- state(S), symbol(A).
{ remove(S,A,S') } :- delta(S,A,S').
{ add_accepting(S) } :- not accepting(S), state(S).
{ remove_accepting(S) } :- accepting(S).

% state(S) enable delta(S,_,_) e delta(_,_,S) con le choice sopra
{ state(S) } :- possible_new_state(S).


% probabilmente add_* è superfluo, si può aggiungere direttamente accepting/1, delta/3
% stando attenti alla BK?
% --> per ILASP non importa tanto minimizza da solo |H|
% --> per ASP è utile avere add/1, remove/1 per fare in modo più semplice i weak
% e distinguere le aggiunte da fatti che erano nell'automa originale
% :~ add(state(S)). [1@1, adding_a_state, S]
% :~ add(delta(S,A,S')). [1@1, adding_a_delta, (S,A,S')]

% remove/1 serve per fare "not remove" nelle regole