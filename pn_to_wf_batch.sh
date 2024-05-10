#!/bin/bash
PNML_ALPHA_DIR=pnml/
PNML_WF_DIR=models_workflow_net
FIG_DIR=models_workflow_net
for PNML in $PNML_ALPHA_DIR/*.pnml; do
    python3 pn_to_wf.py $PNML $FIG_DIR $PNML_WF_DIR
done
