#!/bin/bash
LOG_FOLDER=logs/
PNML_DIR=pnml/
FIG_DIR=models_alpha_pm4py
for LOG in $LOG_FOLDER/*.xes; do
    python3 discover_petri_net.py $LOG alpha $PNML_DIR $FIG_DIR
done
