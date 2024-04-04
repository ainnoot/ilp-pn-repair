%% trace 1 -> pos
trace(id1,1,b).
trace(id1,2,a).
trace(id1,3,a).
%% trace 2 -> pos
trace(id2,1,b).
trace(id2,2,b).
trace(id2,3,b).
%% trace 3 -> neg
trace(id3,1,a).
trace(id3,2,b).

#show accepted/1.