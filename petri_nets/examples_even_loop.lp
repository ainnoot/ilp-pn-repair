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

