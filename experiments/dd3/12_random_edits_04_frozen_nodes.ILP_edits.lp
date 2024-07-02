%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Pre-processing                          : 0.015s
%% Hypothesis Space Generation             : 0.003s
%% Counterexample search                   : 0.402s
%%   - CDOEs                               : 0.007s
%%   - CDPIs                               : 0.393s
%% Hypothesis Search                       : 22.437s
%% Total                                   : 22.859s
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
add(tparc(n34, n13, 1)).
add(tparc(n36, n14, 1)).
add(ptarc(n1, n34, 1)).
add(ptarc(n7, n36, 1)).
remove(tparc(n20, n6, 1)).
remove(ptarc(n8, n17, 1)).
remove(ptarc(n12, n17, 1)).
remove(ptarc(n12, n18, 1)).
remove(ptarc(n6, n19, 1)).
remove(ptarc(n9, n25, 1)).
remove(ptarc(n2, n28, 1)).
remove(ptarc(n16, n38, 1)).

