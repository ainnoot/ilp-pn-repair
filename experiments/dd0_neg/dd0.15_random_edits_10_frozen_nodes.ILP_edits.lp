%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Pre-processing                          : 0.014s
%% Hypothesis Space Generation             : 0.003s
%% Counterexample search                   : 0.399s
%%   - CDOEs                               : 0.006s
%%   - CDPIs                               : 0.393s
%% Hypothesis Search                       : 0.985s
%% Total                                   : 1.402s
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
add(tparc(n22, n6, 1)).
add(tparc(n38, n6, 1)).
add(ptarc(n7, n17, 1)).
add(ptarc(n7, n36, 1)).
add(ptarc(n6, n39, 1)).
remove(tparc(n17, n10, 1)).
remove(tparc(n24, n9, 1)).
remove(tparc(n25, n2, 1)).
remove(ptarc(n12, n19, 1)).
remove(ptarc(n9, n21, 1)).
remove(ptarc(n9, n22, 1)).
remove(ptarc(n5, n28, 1)).
remove(ptarc(n7, n35, 1)).
remove(ptarc(n13, n39, 1)).
remove(ptarc(n3, n39, 1)).

