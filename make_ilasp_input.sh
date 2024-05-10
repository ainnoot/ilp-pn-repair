#!/bin/bash
PNML_DIR=models_workflow_net
ILASP_DIR=ilasp_input
for PNML in $PNML_DIR/*.pnml; do
    # https://stackoverflow.com/questions/965053/extract-filename-and-extension-in-bash
    FILENAME=$(basename -- "$PNML")
    LOG_NAME=${FILENAME%.*}
    python3 reify_wf.py $PNML > $ILASP_DIR/$LOG_NAME.bias
    python3 reify_log.py logs/$LOG_NAME.xes > $ILASP_DIR/$LOG_NAME.examples
done
