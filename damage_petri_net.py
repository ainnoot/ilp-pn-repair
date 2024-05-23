"""
aka Petri Net alicification
"""

import sys
from pathlib import Path

import pm4py
from pm4py import read_pnml
from pm4py.objects.petri_net.utils.petri_utils import remove_arc, add_arc_from_to
from pm4py.objects.petri_net.obj import PetriNet
from random import shuffle
from math import ceil

def print_info(pn: PetriNet, header: str):
    print("%" * 80)
    print(header)
    print("  Number of places:", len(pn.places))
    print("  Number of transitions:", len(pn.transitions))
    print("  Number of edges:", len(pn.arcs))
    print("%" * 80)


if __name__ == '__main__':
    if len(sys.argv) != 3:
        print("Usage: {} <petri net pnml> <save directory>".format(
            Path(__file__).name,
        ))
        print("petri net pnml: Path to a PNML file storing a Petri Net and its markings.")
        print("save directory: Path to a directory to save damaged files")
        print("---")
        print("Prints several PNML files, with 20%, 40%, 60% and 80% of the original arcs in the Petri net.")
        sys.exit(1)

    pnml = sys.argv[1]
    savedir = sys.argv[2]
    if Path(savedir).exists() and Path(savedir).is_dir():
        pass
    else:
        Path(savedir).mkdir()

    # Load Petri Net
    pn, im, fm = read_pnml(pnml, auto_guess_final_marking=True)
    total_trans = len(pn.transitions)
    print_info(pn, "Before damaging")

    arcs = []
    for arc in pn.arcs:
        arcs.append(arc)

    for arc in arcs:
        remove_arc(pn, arc)

    print_info(pn, "After damaging")

    shuffle(arcs)
    trans_qt = ceil(len(arcs) * .20)
    a = 0
    b = trans_qt
    splits = ("0.20", "0.40", "0.60", "0.80", "1.00")
    for split_pct in splits:
        print_info(pn, "Damaging round {}%".format(split_pct))

        to_add = arcs[a:b]
        for arc in to_add:
            print(arc.source, "->", arc.target)
            add_arc_from_to(arc.source, arc.target, pn, arc.weight)


        pnml_savepath = Path(savedir, f"{Path(pnml).stem}_damage={split_pct}.pnml").as_posix()
        pm4py.write_pnml(
            pn, im, fm,
            pnml_savepath
        )

        picture_savepath = Path(savedir, f"{Path(pnml).stem}_damage={split_pct}.png").as_posix()
        pm4py.save_vis_petri_net(pn, im, fm , picture_savepath)

        a, b = b, b + trans_qt
