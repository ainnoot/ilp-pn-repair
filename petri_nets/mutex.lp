% admits "a" or "b" as models, but not both a, b
% (a | b) & (~a | ~b)

%                   a, t1
%                __[]__
%               /       \
%  () -> [] -> ()       () -> [] -> ()
% src   wfst   p1       p2   wfend  snk
%                \__[]_/
%                    b, t2
%


place(source_place).  % src
place(sink_place).    % snk
place(p1).            % p1 
place(p2).            % p2 

trans(source_trans,workflow_start).  % src[wstard]
trans(sink_trans,workflow_end).      % wfend[wend]
trans(t1,a).                         % t1[a]
trans(t2,b).                         % t2[b]

ptarc(source_place, source_trans, 1). %src->wfst
ptarc(p1, t1, 1).                     %p1->t1
ptarc(p1, t2, 1).                     %p2->t2
ptarc(p2, sink_trans, 1).             %p2->wfend

tparc(source_trans, p1, 1).      %wfst->p1 [wstart]
tparc(t1, p2, 1).                %t1->p2 [a]
tparc(t2, p2, 1).                %t2->p2 [b]
tparc(sink_trans, sink_place, 1).%wfend->snk [wend]
