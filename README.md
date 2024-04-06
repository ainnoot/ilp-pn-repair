## `reify_log`
```
usage: reify_log [-h] log

Reifies a XES event log into a set of ILASP examples.

positional arguments:
  log         Path to XES file.

options:
  -h, --help  show this help message and exit
```

## `reify_pn`
```
usage: reify_pn [-h] pnml

Reifies a pm4py.PetriNet object into a set of ASP facts.

positional arguments:
  pnml        Path to PNML file.

options:
  -h, --help  show this help message and exit
```


## Petri Net encoding
```
place(P) 		
  - P: Unique identifier for a place.

trans(T,L)
  - T: Unique identifier for the transition
  - L: Label of the transition

ptarc(P, T, W)
  - Place P is in *T
  - Firing T removes W tokens from P

tparc(P, T, W)
  - Place P is in T*
  - Firing T adds W tokens to P
```

The `reify_pn` script additionally forces the Petri Net to be a workflow net, introducing special source & sink places and transitions:

```
place("__source_place__").
trans("__source_trans__", "__START__").
place("__sink_place__").
trans("__sink_trans__", "__END__").
```

This assumes input traces are padded with a `__START__` initial activity and `__END__` as a last activity, which are the only activities that can trigger the `__source_trans__` and `__sink_trans__` transitions respectively. Furthermore, it is assumed the initial marked of the obtained Petri Net has a single token on `__source_place__`, and that its final marking has a single token on `__sink_place__`.


