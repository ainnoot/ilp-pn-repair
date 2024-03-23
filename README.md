# 

```python
usage: reify_examples [-h] [-v] [--ilasp] examples

positional arguments:
  examples       Path to a JSON file with positive, negative examples.

optional arguments:
  -h, --help     show this help message and exit
  -v, --verbose  Verbose & debug output, if you're lucky.
  --ilasp        Dump to ILASP examples instead of plain ASP facts.
```

Dumps the examples in the `EXAMPLES` JSON file into a prefix tree. `--ilasp` flag (not complete) dumps to ILASP examples instead of plain ASP facts.
