%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Pre-processing                          : 0.015s
%% Hypothesis Space Generation             : 0.004s
%% Counterexample search                   : 0.235s
%%   - CDOEs                               : 0.004s
%%   - CDPIs                               : 0.232s
%% Hypothesis Search                       : 0.264s
%% Total                                   : 0.52s
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
add(tparc(n38, n8, 1)).
add(ptarc(n2, n18, 1)).
add(ptarc(n10, n27, 1)).
remove(tparc(n19, n2, 1)).
remove(ptarc(n5, n17, 1)).
remove(ptarc(n7, n17, 1)).
remove(ptarc(n13, n18, 1)).
remove(ptarc(n12, n27, 1)).
remove(ptarc(n11, n30, 1)).
remove(ptarc(n14, n33, 1)).

