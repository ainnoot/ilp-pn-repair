import sys

import clingo

from ilp_petri_net_repair import PetriNetReification
from argparse import ArgumentParser

def parse_args():
    parser = ArgumentParser(prog="reify_pn")
    parser.add_argument('pnml', type=str, help="Path to PNML file.")

    return parser.parse_args()


if __name__ == '__main__':
    from pm4py.read import read_pnml
    args = parse_args()
    petri_net_file = args.pnml

    pn, im, fm = read_pnml(petri_net_file, auto_guess_final_marking=True)

    r = PetriNetReification()
    ctl = clingo.Control()
    ctl.load('ilp_petri_net_repair/remap.lp')
    with ctl.backend() as backend:
        for fact in r.reify(pn, im, fm):
            ctl_id = backend.add_atom(fact)
            backend.add_rule([ctl_id])

    ctl.ground([("base", [])])
    with ctl.solve(yield_=True) as ctl_handler:
        model = ctl_handler.model()
        for symbol in model.symbols(shown=True):
            print(symbol)
