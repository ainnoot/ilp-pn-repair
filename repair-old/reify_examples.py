from pathlib import Path
from dfa_repair.examples import Examples
from dfa_repair.reify_as_facts import reify_as_facts
from dfa_repair.reify_as_ilasp import ILASPExample
from argparse import ArgumentParser

def parse_args():
    p = ArgumentParser(prog=Path(__file__).stem)
    p.add_argument("examples", type=str, help="Path to a JSON file with positive, negative examples.")
    p.add_argument("-v", "--verbose", action="store_true", help="Verbose & debug output, if you're lucky.")
    p.add_argument('--ilasp', action='store_true', help="Dump to ILASP examples instead of plain ASP facts.")

    return p.parse_args()


if __name__ == '__main__':
    args = parse_args()
    pt = Examples.from_json(args.examples)

    if args.ilasp:
        print("[warn] not complete!")
        for f in ILASPExample.from_examples(pt):
            print(f)
    else:
        print("% prefix tree encoding for: {}".format(args.examples))
        for f in reify_as_facts(pt):
            print("{}.".format(f))