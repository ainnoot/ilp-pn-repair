%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Pre-processing                          : 0.02s
%% Hypothesis Space Generation             : 0.003s
%% Counterexample search                   : 0.25s
%%   - CDOEs                               : 0.008s
%%   - CDPIs                               : 0.241s
%% Hypothesis Search                       : 0.461s
%% Total                                   : 0.735s
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
add(ptarc(n11, n23, 1)).
add(ptarc(n8, n28, 1)).
remove(tparc(n21, n13, 1)).
remove(tparc(n23, n10, 1)).
remove(tparc(n25, n5, 1)).
remove(tparc(n34, n6, 1)).
remove(tparc(n37, n1, 1)).
remove(ptarc(n8, n23, 1)).
remove(ptarc(n2, n31, 1)).
remove(ptarc(n3, n32, 1)).

