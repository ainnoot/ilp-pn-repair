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


original(place(source_place)).  % src
original(place(sink_place)).    % snk
original(place(p1)).            % p1 
original(place(p2)).            % p2 

original(trans(source_transition,workflow_start)).  % src[wstard]
original(trans(sink_transition,workflow_end)).      % wfend[wend]
original(trans(t1,a)).                         % t1[a]
original(trans(t2,b)).                         % t2[b]

original(ptarc(source_place, source_transition, 1)). %src->wfst
original(ptarc(p1, t1, 1)).                     %p1->t1
original(ptarc(p1, t2, 1)).                     %p2->t2
original(ptarc(p2, sink_transition, 1)).             %p2->wfend

original(tparc(source_transition, p1, 1)).      %wfst->p1 [wstart]
original(tparc(t1, p2, 1)).                %t1->p2 [a]
original(tparc(t2, p2, 1)).                %t2->p2 [b]
original(tparc(sink_transition, sink_place, 1)).%wfend->snk [wend]
