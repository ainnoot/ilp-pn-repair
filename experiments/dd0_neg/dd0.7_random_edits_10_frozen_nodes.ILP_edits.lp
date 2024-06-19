%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Pre-processing                          : 0.014s
%% Hypothesis Space Generation             : 0.003s
%% Counterexample search                   : 0.2s
%%   - CDOEs                               : 0.002s
%%   - CDPIs                               : 0.198s
%% Hypothesis Search                       : 0.214s
%% Total                                   : 0.434s
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
add(tparc(n40, n3, 1)).
add(ptarc(n9, n36, 1)).
add(ptarc(n3, n37, 1)).
remove(tparc(n21, n5, 1)).
remove(tparc(n25, n10, 1)).
remove(tparc(n33, n10, 1)).
remove(ptarc(n12, n25, 1)).

