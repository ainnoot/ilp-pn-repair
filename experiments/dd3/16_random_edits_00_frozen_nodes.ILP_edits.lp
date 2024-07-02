%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Pre-processing                          : 0.014s
%% Hypothesis Space Generation             : 0.003s
%% Counterexample search                   : 0.452s
%%   - CDOEs                               : 0.008s
%%   - CDPIs                               : 0.445s
%% Hypothesis Search                       : 86.986s
%% Total                                   : 87.456s
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
add(tparc(n32, n9, 1)).
add(tparc(n34, n13, 1)).
add(tparc(n36, n14, 1)).
add(ptarc(n7, n36, 1)).
add(ptarc(n1, n37, 1)).
add(ptarc(n8, n39, 1)).
remove(tparc(n20, n6, 1)).
remove(tparc(n26, n16, 1)).
remove(ptarc(n8, n17, 1)).
remove(ptarc(n12, n17, 1)).
remove(ptarc(n12, n18, 1)).
remove(ptarc(n6, n19, 1)).
remove(ptarc(n2, n28, 1)).
remove(ptarc(n15, n34, 1)).
remove(ptarc(n2, n35, 1)).
remove(ptarc(n16, n38, 1)).

