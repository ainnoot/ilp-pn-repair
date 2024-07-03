%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Pre-processing                          : 0.02s
%% Hypothesis Space Generation             : 0.003s
%% Counterexample search                   : 0.193s
%%   - CDOEs                               : 0.005s
%%   - CDPIs                               : 0.187s
%% Hypothesis Search                       : 0.207s
%% Total                                   : 0.425s
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
add(ptarc(n3, n34, 1)).
add(ptarc(n3, n41, 1)).
remove(tparc(n31, n13, 1)).
remove(ptarc(n9, n28, 1)).
remove(ptarc(n15, n41, 1)).

