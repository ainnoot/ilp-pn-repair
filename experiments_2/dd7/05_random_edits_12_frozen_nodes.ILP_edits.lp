%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Pre-processing                          : 0.02s
%% Hypothesis Space Generation             : 0.003s
%% Counterexample search                   : 0.284s
%%   - CDOEs                               : 0.01s
%%   - CDPIs                               : 0.275s
%% Hypothesis Search                       : 0.384s
%% Total                                   : 0.693s
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
add(tparc(n32, n3, 1)).
remove(tparc(n30, n10, 1)).
remove(ptarc(n11, n22, 1)).
remove(ptarc(n11, n31, 1)).
remove(ptarc(n15, n32, 1)).

