# `reify_examples.py`

```
usage: reify_examples [-h] [-v] [--ilasp] examples

positional arguments:
  examples       Path to a JSON file with positive, negative examples.

optional arguments:
  -h, --help     show this help message and exit
  -v, --verbose  Verbose & debug output, if you're lucky.
  --ilasp        Dump to ILASP examples instead of plain ASP facts.
```

Dumps the examples in the `examples` JSON file into a prefix tree. `--ilasp` flag (not complete) dumps to ILASP examples instead of plain ASP facts.

## Example
```bash
python3 reify_examples.py examples.json > input.lp
cat input.lp
prefix(1,0,"a").
neg(1).
prefix(2,1,"b").
pos(2).
prefix(3,2,"a").
neg(3).
prefix(4,3,"b").
prefix(5,4,"a").
prefix(6,5,"b").
pos(6). 
```

# `check_dfa.py`

```
usage: check_dfa [-h] dfa examples

positional arguments:
  dfa         Facts encoding a DFA.
  examples    Facts encoding examples.

optional arguments:
  -h, --help  show this help message and exit
```

Checks the DFA in `dfa` against examples in `examples`, reports missing transitions and wrong behavior on examples.
