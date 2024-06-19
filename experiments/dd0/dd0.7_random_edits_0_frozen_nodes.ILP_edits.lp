%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Pre-processing                          : 0.014s
%% Hypothesis Space Generation             : 0.003s
%% Counterexample search                   : 0.283s
%%   - CDOEs                               : 0.004s
%%   - CDPIs                               : 0.28s
%% Hypothesis Search                       : 0.906s
%% Total                                   : 1.207s
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
add(ptarc(n12, n22, 1)).
add(ptarc(n1, n37, 1)).
remove(tparc(n30, n6, 1)).
remove(tparc(n39, n12, 1)).
remove(tparc(n39, n7, 1)).
remove(ptarc(n16, n28, 1)).
remove(ptarc(n12, n33, 1)).

