%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Pre-processing                          : 0.02s
%% Hypothesis Space Generation             : 0.003s
%% Counterexample search                   : 0.363s
%%   - CDOEs                               : 0.01s
%%   - CDPIs                               : 0.351s
%% Hypothesis Search                       : 9.212s
%% Total                                   : 9.601s
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
add(ptarc(n3, n34, 1)).
add(ptarc(n3, n41, 1)).
remove(tparc(n31, n13, 1)).
remove(tparc(n33, n1, 1)).
remove(ptarc(n4, n20, 1)).
remove(ptarc(n12, n24, 1)).
remove(ptarc(n9, n28, 1)).
remove(ptarc(n6, n28, 1)).
remove(ptarc(n14, n34, 1)).
remove(ptarc(n15, n41, 1)).

