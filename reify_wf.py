#!/usr/bin/env python3

import sys
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

    return parser.parse_args()


if __name__ == '__main__':
    from pm4py.read import read_pnml
    args = parse_args()
    petri_net_file = args.pnml

    pn, im, fm = read_pnml(petri_net_file, auto_guess_final_marking=True)
    is_wf = pm4py.check_is_workflow_net(pn)
    if not is_wf:
        raise WorkflowNetExpectedException()

    print(ALICE_TEMPLATE.format(
        ILASP_CONSTANTS="\n".join(define_ilasp_constants(pn, private="__")),
        INPUT_MODEL="\n".join(f"{fact}." for fact in reify_workflow_net(pn, im, fm)),
    ))
