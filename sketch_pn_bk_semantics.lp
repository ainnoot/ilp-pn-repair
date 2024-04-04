% Appunti a caso, nel paper ci sarà di meglio
% da wrappare qualcosa in removed(...) per le rimozioni (?)

state(0, P, C) :- initial_marking(P, C).
cant_fire(T, Transition) :-
  input_place(P, Transition),
  state(T-1, P, 0).

can_fire(T, Transition),
  step(T), transition(Transition, _),
  state(T-1, P, C), C > 0.

{ fires(T, Tr): transition(Tr,Lab), trace(T,Lab), can_fire(T, Tr) } = 1.

%%% Token game
state(T, P, C - 1) :-
  % Firing a transition removes a token from the input places
  fires(T, Transition),
  input_place(P, Transition),
  state(T-1, P, C).

state(T, P, C + 1) :-
  % Firing a transition adds a token to the output places
  fires(T, Transition),
  output_place(P, Transition),
  state(T-1, P, C).

% Inertia
state(T, P, C) :-
  fires(T, Transition),
  place(P),
  not output_place(Transition),
  not input_place(Transition).


% Can't fire something if empty input place -- redundant
:- fires(T, Tr), input_place(P, Tr), state(T-1, P, 0).

% We hit the final marking?
fail :- final_marking(P, C), last(T), not state(T,P,C).

% positive traces --> {fail} in exclusion set (?)
% negative traces --> {fail} in inclusion set (?)