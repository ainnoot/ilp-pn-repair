#pos(idp1, {ok}, {}, {
trace(0,workflow_start). 
trace(1,tick).
trace(2,workflow_end). 
}).

#pos(idp2, {ok}, {}, {
trace(0,workflow_start). 
trace(1,tick).
trace(2,tock).
trace(3,tick).
trace(4,workflow_end). 
}).

#pos(idp2, {fail}, {}, {
trace(0,workflow_start). 
trace(1,tick).
trace(2,tock).
trace(3,workflow_end). 
}).

#pos(idp0, {ok}, {}, {
%% No two labels per transition
fail :- trans(T,L), trans(T,L1), L > L1.
%% Just one edge per (place,transition)
fail :- ptarc(P,T,W), ptarc(P,T,W2), W >W2.
fail :- tparc(T,P,W), tparc(T,P,W2), W >W2.

%% Transitions must have at least one input place, at least one output place
% invalid_trans(T) :- trans(T,_), not ptarc(_,T,_).
% invalid_trans(T) :- trans(T,_), not tparc(T,_,_).
% fail :- trans(T,_), invalid_trans(T).
}).