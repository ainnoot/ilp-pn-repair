% This admits firing sequences:
% START t1 (t2 t1)* END
% 
% So it should have a unique solution when k is even, 0 solutions when k is odd

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
