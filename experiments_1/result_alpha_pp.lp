%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Pre-processing                          : 0.032s
%% Hypothesis Space Generation             : 0.005s
%% Counterexample search                   : 0.511s
%%   - CDOEs                               : 0.003s
%%   - CDPIs                               : 0.508s
%% Hypothesis Search                       : 0.024s
%% Total                                   : 0.572s
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
add(tparc(t_1, p_0, 1)).
add(ptarc(p_2, t_1, 1)).
add(ptarc(p_4, t_1, 1)).
add(ptarc(p_1, t_5, 1)).
remove(place(p_5)).
