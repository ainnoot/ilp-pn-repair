%%%%% is workflow net? %%%%
#pos(ad00000, {ok}, {}, {
%% project the petri net on a bipartite graph
%% w- prefix to avoid clashes between predicate names
wedge(X,Y) :- ptarc(X,Y,_).
wedge(X,Y) :- tparc(X,Y,_).
wsource(X) :- initial_marking(X,_).
wsink(X) :- final_marking(X,_).

%% src, snk reach themselves
wreach(X,X) :- wsink(X).
wreach(X,X) :- wsource(X).
%% transitive closure wedge/2
wreach(X,Y) :- wedge(X,Y).
wreach(X,Z) :- wreach(X,Y), wedge(Y,Z).

%% objects: places & transitions
wobject(P) :- place(P).
wobject(T) :- trans(T,_).

%% every place, trans in a directed path starting from src and ending in snk
%% two paths: src->o, o->snk
fail :- wobject(X), wsource(S), not wreach(S,X).
fail :- wobject(X), wsink(S), not wreach(X,S).
fail :- wedge(S,_), wsink(S).
fail :- wedge(_,S), wsource(S).
}).

%#pos(ad00, {ok}, {}, {
%% No two labels per transition
%fail :- trans(T,L), trans(T,L1), L > L1.
%% Just one edge per (place,transition)
%fail :- ptarc(P,T,W), ptarc(P,T,W2), W >W2.
%fail :- tparc(T,P,W), tparc(T,P,W2), W >W2.
%}).