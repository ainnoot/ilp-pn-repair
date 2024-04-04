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
```

Remapping is achieved:

```
_transition(P, A, P') :-
  place(P), place(P'), transition(T, A),
  arc(P, T, _), arc(T, P', _).
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

- [ ] Move remapping from `reify_pn.py` to `PetriNetReification`
- [ ] Add flags for output file
