%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Pre-processing                          : 0.016s
%% Hypothesis Space Generation             : 0.003s
%% Counterexample search                   : 0.88s
%%   - CDOEs                               : 0.002s
%%   - CDPIs                               : 0.877s
%% Hypothesis Search                       : 0.026s
%% Total                                   : 0.925s
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
add(tparc(t_1, p_0, 1)).
add(ptarc(p_2, t_1, 1)).
add(ptarc(p_4, t_1, 1)).
add(ptarc(p_1, t_5, 1)).
remove(place(p_5)).

