%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Pre-processing                          : 0.019s
%% Hypothesis Space Generation             : 0.003s
%% Counterexample search                   : 0.448s
%%   - CDOEs                               : 0.013s
%%   - CDPIs                               : 0.43s
%% Hypothesis Search                       : 9.648s
%% Total                                   : 10.117s
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
add(tparc(n40, n13, 1)).
add(tparc(n41, n13, 1)).
add(ptarc(n11, n23, 1)).
add(ptarc(n8, n28, 1)).
add(ptarc(n6, n37, 1)).
remove(tparc(n20, n8, 1)).
remove(tparc(n21, n13, 1)).
remove(tparc(n23, n10, 1)).
remove(tparc(n25, n5, 1)).
remove(tparc(n31, n7, 1)).
remove(tparc(n37, n1, 1)).
remove(tparc(n38, n6, 1)).
remove(ptarc(n8, n23, 1)).
remove(ptarc(n2, n31, 1)).
remove(ptarc(n3, n32, 1)).

