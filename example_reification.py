import sys

from dfa_repair.examples import Examples, Example
from dfa_repair.reify_as_facts import reify_as_facts
from argparse import ArgumentParser

def parse_args():
    p = ArgumentParser()
    p.add_argument("examples", type=str)
    p.add_argument("-v", "--verbose", action="store_true")

    return p.parse_args()


if __name__ == '__main__':
    args = parse_args()
    pt = Examples.from_json(args.examples)

    print("% prefix tree encoding for: {}".format(args.examples))
    for f in reify_as_facts(pt):
        print("{}.".format(f))