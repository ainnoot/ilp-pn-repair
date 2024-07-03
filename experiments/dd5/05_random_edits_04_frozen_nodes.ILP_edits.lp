%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Pre-processing                          : 0.019s
%% Hypothesis Space Generation             : 0.003s
%% Counterexample search                   : 0.238s
%%   - CDOEs                               : 0.008s
%%   - CDPIs                               : 0.23s
%% Hypothesis Search                       : 0.392s
%% Total                                   : 0.654s
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
add(ptarc(n11, n23, 1)).
add(ptarc(n8, n28, 1)).
remove(tparc(n23, n10, 1)).
remove(tparc(n25, n5, 1)).
remove(ptarc(n2, n31, 1)).

