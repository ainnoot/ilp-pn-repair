root(0).
state(0,S) :- start(S).

state(X,S') :- prefix(X,P,A), state(P,S), delta(S,A,S').

% X = P||A, but DFA unable to read A after recognizing P
fault(missing(S,A)):- prefix(X,P,A), state(P,S), not delta(S,A,_).

% Rejecting a positive string,
% Accepting a negative string
fault(false_pos(X)) :- pos(X), state(X,S), not accepting(S).
fault(false_neg(X)) :- neg(X), state(X,S), accepting(S).

:- fault(_).

#show.
#show fault/1.