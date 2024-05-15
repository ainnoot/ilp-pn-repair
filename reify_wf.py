#!/usr/bin/env python3
from pathlib import Path

import pm4py
from ilp_petri_net_repair import reify_workflow_net, add_source_and_sink, remove_disconnected_objects, define_ilasp_constants
from ilp_petri_net_repair import WorkflowNetExpectedException
from argparse import ArgumentParser

ALICE_TEMPLATE = """
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% MODE BIAS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
#modeh(ptarc(const(place),const(trans),const(weight))).
#modeh(tparc(const(trans),const(place),const(weight))).
#modeh(rem_ptarc(const(place),const(trans),const(weight))).
#modeh(rem_tparc(const(trans),const(place),const(weight))).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% BIAS CONSTRAINTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
#bias("

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% INPUT MODEL %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
{INPUT_MODEL}

new_tparc(T,P,W) :- trans(T,A), place(P), weight(W), not tparc(T,P,W).
new_ptarc(T,P,W) :- trans(T,A), place(P), weight(W), not ptarc(P,T,W).
:- head(ptarc(P,T,W)), ptarc(P,T,W).
:- head(tparc(T,P,W)), ptarc(T,P,W).
:- head(rem_ptarc(P,T,W)), new_ptarc(P,T,W).
:- head(rem_tparc(T,P,W)), new_tparc(T,P,W).
").

%%%%%%%%%%%%%%%%%%%%%%%%%%%% CONSTANTS DECLARATION %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
{ILASP_CONSTANTS}

"""

def parse_args():
    parser = ArgumentParser(prog="reify_pn", description="Reifies a pm4py.PetriNet object into a set of ASP facts.")
    parser.add_argument('pnml', type=str, help="Path to PNML file.")
    parser.add_argument('bias', type=str, help="Path to output bias file.")
    parser.add_argument('model', type=str, help="Path to output model file.")

    return parser.parse_args()


if __name__ == '__main__':
    from pm4py.read import read_pnml
    args = parse_args()
    petri_net_file = args.pnml
    bias_file = args.bias
    model_file = args.model

    pn, im, fm = read_pnml(petri_net_file, auto_guess_final_marking=True)
    is_wf = pm4py.check_is_workflow_net(pn)
    if not is_wf:
        raise WorkflowNetExpectedException()

    INPUT_MODEL = [str(x) for x in reify_workflow_net(pn, im, fm)]
    INPUT_MODEL.sort() # più facile da leggere
    INPUT_MODEL = "\n".join(f"{x}." for x in INPUT_MODEL)

    with Path(model_file).open('w') as f:
        f.write(INPUT_MODEL)
        f.flush()

    with Path(bias_file).open('w') as f:
        f.write(ALICE_TEMPLATE.format(
            ILASP_CONSTANTS="\n".join(define_ilasp_constants(pn, private="__")),
            INPUT_MODEL=INPUT_MODEL,
        ))
        f.flush()
