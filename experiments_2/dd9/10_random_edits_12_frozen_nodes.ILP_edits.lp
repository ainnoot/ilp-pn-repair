%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Pre-processing                          : 0.02s
%% Hypothesis Space Generation             : 0.003s
%% Counterexample search                   : 0.358s
%%   - CDOEs                               : 0.01s
%%   - CDPIs                               : 0.345s
%% Hypothesis Search                       : 0.548s
%% Total                                   : 0.93s
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
add(ptarc(n3, n34, 1)).
add(ptarc(n15, n35, 1)).
remove(tparc(n23, n16, 1)).
remove(tparc(n26, n15, 1)).
remove(tparc(n30, n11, 1)).
remove(tparc(n33, n14, 1)).
remove(tparc(n36, n5, 1)).
remove(tparc(n36, n13, 1)).
remove(ptarc(n4, n31, 1)).
remove(ptarc(n10, n38, 1)).

