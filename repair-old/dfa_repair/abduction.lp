{ remove_delta(delta(X,A,Y)) } :- delta(X,A,Y).
{ add_delta(delta(X,A,Y)) } :- state(X), state(Y), symbol(A), not delta(X,A,Y).
{ accepting(S) } :- state(S), not accepting(S).

