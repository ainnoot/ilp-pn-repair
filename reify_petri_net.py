#!/usr/bin/env python3
from pathlib import Path

import pm4py
from ilp_petri_net_repair import reify_petri_net, define_ilasp_constants
from argparse import ArgumentParser
from itertools import chain

def parse_args():
    parser = ArgumentParser(prog="reify_pn", description="Reifies a pm4py.PetriNet object into a set of ASP facts.")
    parser.add_argument('pnml', type=str, help="Path to PNML file.")
    parser.add_argument('model', type=str, help="Path to output model file.")

    return parser.parse_args()


if __name__ == '__main__':
    from pm4py.read import read_pnml
    args = parse_args()
    petri_net_file = args.pnml
    model_file = args.model

    pn, im, fm = read_pnml(petri_net_file, auto_guess_final_marking=True)
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