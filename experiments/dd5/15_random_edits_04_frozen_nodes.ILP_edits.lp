%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Pre-processing                          : 0.019s
%% Hypothesis Space Generation             : 0.003s
%% Counterexample search                   : 0.541s
%%   - CDOEs                               : 0.016s
%%   - CDPIs                               : 0.524s
%% Hypothesis Search                       : 3.305s
%% Total                                   : 3.868s
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
add(ptarc(n11, n23, 1)).
add(ptarc(n8, n28, 1)).
add(ptarc(n5, n36, 1)).
remove(tparc(n20, n8, 1)).
remove(tparc(n21, n13, 1)).
remove(tparc(n23, n10, 1)).
remove(tparc(n31, n7, 1)).
remove(tparc(n34, n6, 1)).
remove(tparc(n37, n1, 1)).
remove(tparc(n38, n6, 1)).
remove(ptarc(n13, n22, 1)).
remove(ptarc(n8, n23, 1)).
remove(ptarc(n2, n31, 1)).
remove(ptarc(n3, n32, 1)).
remove(ptarc(n13, n41, 1)).

