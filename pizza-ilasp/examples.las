#pos(example_0, {ok}, {}, {
  trace(0,bi).
  trace(1,cb).
  trace(2,ac).
  trace(3,as).
  trace(4,at).
  trace(5,bo).
  trace(6,ep).
  trace(7,ck).
}).
#pos(example_1, {ok}, {}, {
  trace(0,bi).
  trace(1,cb).
  trace(2,at).
  trace(3,as).
  trace(4,ac).
  trace(5,bo).
  trace(6,ep).
  trace(7,ck).
}).
#pos(example_2, {ok}, {}, {
  trace(0,bi).
  trace(1,cb).
  trace(2,at).
  trace(3,ac).
  trace(4,as).
  trace(5,bo).
  trace(6,ep).
  trace(7,ck).
}).
#pos(example_3, {ok}, {}, {
  trace(0,bi).
  trace(1,cb).
  trace(2,ac).
  trace(3,at).
  trace(4,as).
  trace(5,bo).
  trace(6,ep).
  trace(7,ck).
}).
#pos(example_4, {ok}, {}, {
  trace(0,bi).
  trace(1,cb).
  trace(2,as).
  trace(3,ac).
  trace(4,at).
  trace(5,bo).
  trace(6,ep).
  trace(7,ck).
}).
#pos(example_5, {ok}, {}, {
  trace(0,bi).
  trace(1,cb).
  trace(2,as).
  trace(3,at).
  trace(4,ac).
  trace(5,bo).
  trace(6,ep).
  trace(7,ck).
}).

%%%%%%%%%% NEG EXAMPLES %%%%%%%%%%%%%%%
% no disconnected transitions 
#pos(example_8, {ok}, {}, {
fail :- trans(T,_), not ptarc(_,T,_).
}).

% no disconnected transitions 
#pos(example_9, {ok}, {}, {
fail :- trans(T,_), not tparc(T,_,_).
}).

% except for n13 (bo), only one ptarc per transition
#pos(example_10, {ok}, {}, {
fail :- trans(T,_), T != n13, ptarc(P1,T,_), ptarc(P2,T,_), P1 > P2.
}).

% except for n15 (cb), only one tparc per transition
#pos(example_11, {ok}, {}, {
fail :- trans(T,_), T != n15, tparc(T,P1,_), tparc(T,P2,_), P1 > P2.
}).

% no tparc in initial place
#pos(example_12, {ok}, {}, {
fail :-  tparc(_,n1,_).
}).

% no ptarc in final place
#pos(example_13, {ok}, {}, {
fail :-  ptarc(_,n10,_).
}).

% no place with more than one tparc
#pos(example_14, {ok}, {}, {
fail :- place(P), tparc(T1,P,_), tparc(T2,P,_), T1 > T2.
}).

% no place with more than one ptarc
#pos(example_15, {ok}, {}, {
fail :- place(P), ptarc(P,T1,_), ptarc(P,T2,_), T1 > T2.
}).