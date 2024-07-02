#!/bin/bash
for ILASP_DIR in experiments/*/ ; do
    for MODEL in $ILASP_DIR*.damaged_model; do
        FILENAME=$(basename -- "$MODEL")
        LOG_NAME=${FILENAME%.*}
        # Create hypothesis space
        clingo language_bias.lp $ILASP_DIR$FILENAME -W none -n 0 -V0 | sed -E 's/\(([^,]+),(.+)\)/\1 ~ \2./' | ghead -n -1 > $ILASP_DIR$LOG_NAME.search_space.lp
        # Solve ILP task 
        timeout 600 ILASP --version=2i background_knowledge.lp $ILASP_DIR$LOG_NAME.search_space.lp $ILASP_DIR$FILENAME $ILASP_DIR/examples.las > $ILASP_DIR$LOG_NAME.ILP_edits.lp
        # If timeout, write comment
        exit_status=$?
        if [[ $exit_status -eq 124 ]]; then
            echo "%Timeout for: ${FILENAME}" > $ILASP_DIR$LOG_NAME.ILP_edits.lp
        fi
    done
done