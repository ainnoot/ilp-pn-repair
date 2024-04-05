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

### TODO:

- [ ] Same encoding schema as Chitta Baral
- [x] Move remapping from `reify_pn.py` to `PetriNetReification`
- [ ] Add flags for output file
