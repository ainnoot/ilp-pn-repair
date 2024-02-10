#pos(id1, {accepted(id1)},{},{trace(id1,1,b). trace(id1,2,a). trace(id1,3,a).}).
#neg(id2, {accepted(id2)},{},{trace(id2,1,b). trace(id2,2,b). trace(id2,3,b).}).
#neg(id3, {accepted(id3)},{},{trace(id3,1,a). trace(id3,2,b).}).


#modeh(delta(const(state),const(symbol),const(state))).
#modeh(remove(const(state),const(symbol),const(state))).

#constant(state, s1).
#constant(state, s2).
#constant(symbol, a).
#constant(symbol, b).

#bias("
delta(s1,a,s2).
delta(s1,b,s1).
delta(s2,a,s1).
delta(s2,b,s2).
state(S) :- delta(S,_,_).
state(S) :- delta(_,_,S).
symbol(S) :- delta(_,S,_).
newdelta(S1,Sym,S2) :- state(S1), symbol(Sym), state(S2), not delta(S1,Sym,S2).
:- head(delta(S1,Sym,S2)), delta(S1,Sym,S2).
:- head(remove(S1,Sym,S2)), newdelta(S1,Sym,S2).
").


