%% Consider concluded/completed traces
%% Initial model
delta(s1,a,s2).
delta(s1,b,s1).
delta(s2,a,s1).
delta(s2,b,s2).
start(s1).
final(s2).


exec(Id,0,S) :- start(S), trace(Id,_,_).
exec(Id,T+1,S1) :- trace(Id,T+1,Sym), exec(Id,T,S), delta(S,Sym,S1), not remove(S,Sym,S1).

% This should solve the issues with unexpected symbols -> for n symbols, I expect n transitions
accepted(Id) :- final(S), exec(Id,T,S), trace(Id,T,_), not trace(Id,T+1,_).

%% To do: definire gerarchia di costi
%% tradeoff between minimizzare edits/minimizzare stati(opt)
