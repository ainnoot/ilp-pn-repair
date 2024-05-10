#!/usr/bin/env python3

import sys
from pathlib import Path

import pm4py

from ilp_petri_net_repair import WorkflowNetExpectedException
from argparse import ArgumentParser
from ilp_petri_net_repair import remove_disconnected_objects_2, add_source_and_sink, remove_disconnected_objects, define_ilasp_constants

def parse_args():
    if len(sys.argv) != 4:
        print("Usage: {} [PetriNet PNML] [Picture Folder] [PNML Folder]")
        sys.exit(118)

    return [Path(x) for x in sys.argv[1:]]


if __name__ == '__main__':
    pnml, picture_dir, pnml_dir = parse_args()
    pn, im, fm = pm4py.read_pnml(pnml.as_posix())
    pn, im, fm, (source, sink) = add_source_and_sink(pn, im, fm)
    pn = remove_disconnected_objects_2(pn, source, sink)

    if not pm4py.analysis.check_is_workflow_net(pn):
        raise WorkflowNetExpectedException()

    log_name = pnml.stem
    fig_file_path = (picture_dir / log_name).with_suffix(".png")
    pnml_path = (pnml_dir / log_name).with_suffix(".pnml")

    print("Saving picture to", fig_file_path.as_posix())
    pm4py.save_vis_petri_net(pn, im, fm, fig_file_path.as_posix())

    print("Saving PNML to", pnml_path.as_posix())
    pm4py.write_pnml(pn, im, fm, pnml_path.as_posix())


