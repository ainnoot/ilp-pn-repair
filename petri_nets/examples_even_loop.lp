#pos(idp1, {}, {}, {
trace(0,workflow_start). 
trace(1,tick).
trace(2,workflow_end). 
}).

#pos(idp2, {}, {}, {
trace(0,workflow_start). 
trace(1,tick).
trace(2,tock).
trace(3,tick).
trace(4,workflow_end). 
}).

#neg(idp3, {}, {}, {
trace(0,workflow_start). 
trace(1,tick).
trace(2,tock).
trace(3,workflow_end). 
}).

#neg(idp4, {}, {}, {
trace(0,workflow_start). 
trace(1,workflow_end). 
}).