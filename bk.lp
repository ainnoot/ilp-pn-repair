%% Consider concluded traces
%% Starting from an initial model
delta(s1,a,s2).
delta(s1,b,s1).
delta(s2,a,s1).
start(s1).
final(s2).

%% trace 1
trace(id1,1,b).
trace(id1,2,a).
trace(id1,3,a).
%% trace 2
trace(id2,1,b).
trace(id2,2,b).
trace(id2,3,b).

exec(Id,1,S) :- start(S), trace(Id,_,_).
exec(Id,T+1,S1) :- trace(Id,T,Sym), exec(Id,T,S), delta(S,Sym,S1), not remove(S,Sym,S1).

end(Id,S) :- exec(Id,T,S), not exec(Id,T+1,_).

accepted(Id) :- end(Id,S), final(S).

%% Da ILASP
remove(s2,a,s1). %% only from previous delta
delta(s2,a,s2). %% only what is new 

#show accepted/1.
#show exec/3.

