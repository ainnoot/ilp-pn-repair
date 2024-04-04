## Reify a PNML Petri Net into facts

### Original encoding schema

```
place(ID)
  - ID is a unique identifier for each place.

transition(ID, L) 
  - ID is a unique identifier for each transition
  - L is a label for the transition (~ activity name)

arc(Src, Tar, W)
  - Src is a unique identifier for a place OR transition
  - Tar is a unique identifier for a place OR transition
  - W is an integer weight (~ ignore it)

initial_marking(P, C)
  - P is a unique identifier for a place
  - C is the number of tokens in P on the initial marking

final_marking(P, C)
  - P is a unique identifier for a place
  - C is the number of tokens in P on the final marking
```

### Remapped encoding schema (use this one)

```
place(ID)
  - ID is a unique identifier for each place.

transition(P, A, P') 
  - P is an unique identifier for a place (source)
  - P' is a unique identifier for a palce (target) 
  - A is the activity that enables the transition between P and P'

initial_marking(P, C)
  - P is a unique identifier for a place
  - C is the number of tokens in P on the initial marking

final_marking(P, C)
  - P is a unique identifier for a place
  - C is the number of tokens in P on the final marking

activity(A)
  - A is an activity, e.g. a label that appears at least once 
    as the second term in transition/3

output_place(P, T)
  - P is a unique identifier for a place
  - T is a unique identifier for a transition such that P in T*

input_place(P, T)
  - P is a unique identifier for a place
  - T is a unique identifier for a transition such that P in *T
```

Remapping is achieved:

```
input_place(P, T) :-
  place(P), transition(T,L),
  arc(P, T, _).

output_place(P, T) :-
  place(P), transition(T,L),
  arc(T, P, _).

#show activity(A): transition(_,A).
#show output_place/2.
#show input_place/2.
#show transition/2.
#show place/1.
#show initial_marking/2.
#show final_marking/2.
```

### Usage

```
usage: reify_pn [-h] pnml

positional arguments:
  pnml        Path to PNML file.

options:
  -h, --help  show this help message and exit
```

### TODO:

- [x] Move remapping from `reify_pn.py` to `PetriNetReification`
- [ ] Add flags for output file
