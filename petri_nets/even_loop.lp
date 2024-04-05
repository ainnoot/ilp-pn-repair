% This admits firing sequences:
% START t1 (t2 t1)* END
%                           [T1]
%                         /     \
%   (SRC) -> [SRC] -> (P1)      (P2) -> [END] -> (END)
%                         \ [T2] /      
%
%
%
% Admits as models even loops of (t1 t2), considering src-end:
% src t1 (t2 t1)* end
%
% should be unsatisfiable when k is odd
% should be satisfiable with a unique model when k is even 
%



place("__source_place__").
place("__sink_place__").
place("p1").
place("p2").

trans("__source_trans__","DUMMY-START").
trans("__sink_trans__","DUMMY-END").
trans("t1","tick").
trans("t2","tock").

ptarc("__source_place__", "__source_trans__", 1).
ptarc("p1", "t1", 1).
ptarc("p2", "__sink_trans__", 1).
ptarc("p2", "t2", 1).

tparc("__source_trans__", "p1", 1).
tparc("t1", "p2", 1).
tparc("t2", "p1", 1).
tparc("__sink_trans__", "__sink_place__", 1).
