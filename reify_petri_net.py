#!/usr/bin/env python3
from pathlib import Path

import pm4py
from ilp_petri_net_repair import reify_petri_net
from ilp_petri_net_repair.petri_net_utils import relabel_everything_because_i_dont_like_how_pm4py_names_things
from argparse import ArgumentParser
from itertools import chain

def parse_args():
    parser = ArgumentParser(prog="reify_pn", description="Reifies a pm4py.PetriNet object into a set of ASP facts.")
    parser.add_argument('pnml', type=str, help="Path to PNML file.")
    parser.add_argument('model', type=str, help="Path to output model file.")
    parser.add_argument("-r", "--relabel", action='store_true', help="Normalize transitions and places name with a progressive identifier. If missing, preserves original names.")

    return parser.parse_args()


if __name__ == '__main__':
    from pm4py.read import read_pnml
    args = parse_args()
    petri_net_file = args.pnml
    model_file = args.model

    pn, im, fm = read_pnml(petri_net_file, auto_guess_final_marking=True)
    if args.relabel:
        (pn, im, fm), _ = relabel_everything_because_i_dont_like_how_pm4py_names_things(pn, im, fm)

    facts = reify_petri_net(pn, im, fm)
    pn_facts, im_facts, fm_facts = reify_petri_net(pn, im, fm)

    INPUT_MODEL = list(chain(
        ["original({}).".format(x) for x in pn_facts],
        map(lambda x: f"{x}.", im_facts),
        map(lambda x: f"{x}.", fm_facts)
    ))

    with Path(model_file).open('w') as f:
        f.write("\n".join(sorted(INPUT_MODEL)))
        f.flush()