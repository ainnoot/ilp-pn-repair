%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Pre-processing                          : 0.019s
%% Hypothesis Space Generation             : 0.003s
%% Counterexample search                   : 0.264s
%%   - CDOEs                               : 0.007s
%%   - CDPIs                               : 0.255s
%% Hypothesis Search                       : 0.272s
%% Total                                   : 0.559s
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
add(ptarc(n12, n34, 1)).
add(ptarc(n10, n37, 1)).
remove(tparc(n28, n9, 1)).
remove(tparc(n33, n7, 1)).
remove(tparc(n41, n1, 1)).
remove(ptarc(n15, n24, 1)).
remove(ptarc(n1, n31, 1)).
remove(ptarc(n16, n31, 1)).
remove(ptarc(n16, n32, 1)).
remove(ptarc(n16, n36, 1)).

