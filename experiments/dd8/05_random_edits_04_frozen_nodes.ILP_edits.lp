%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Pre-processing                          : 0.02s
%% Hypothesis Space Generation             : 0.003s
%% Counterexample search                   : 0.243s
%%   - CDOEs                               : 0.008s
%%   - CDPIs                               : 0.238s
%% Hypothesis Search                       : 0.407s
%% Total                                   : 0.675s
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
add(ptarc(n3, n34, 1)).
add(ptarc(n3, n41, 1)).
remove(tparc(n31, n13, 1)).
remove(ptarc(n9, n28, 1)).
remove(ptarc(n15, n41, 1)).

