#!/bin/bash
number_of_edits=(3 5 7 10 15 20)
number_of_frozen_elements=(0 5 10 15)
PNML_DIR=Syntetic_data_new
ILASP_DIR=experiments
for PNML in $PNML_DIR/*.pnml; do
    # https://stackoverflow.com/questions/965053/extract-filename-and-extension-in-bash
    FILENAME=$(basename -- "$PNML")
    LOG_NAME=${FILENAME%.*}
    NEW_DIR="$ILASP_DIR/$LOG_NAME"
    mkdir -p "$NEW_DIR"
    python3 reify_petri_net.py $PNML $NEW_DIR/$LOG_NAME.model
    python3 reify_log.py $PNML_DIR/$LOG_NAME.xes > $NEW_DIR/$LOG_NAME.examples
    # Create damaged version (addition or remove)
    for number in "${number_of_edits[@]}"
    do
        clingo damage_net.lp $NEW_DIR/$LOG_NAME.model --rand-freq=1 --sign-def=rnd --seed="$((RANDOM))" --const n="$number" -V0  --out-atomf="%s." | ghead -n -1 | sed 's/\. /.\n/g' > $NEW_DIR/$LOG_NAME."$number"_random_edits.txt
        for frozen in "${number_of_frozen_elements[@]}"
        do
            clingo frozen_net.lp $NEW_DIR/$LOG_NAME.model $NEW_DIR/$LOG_NAME."$number"_random_edits.txt --rand-freq=1 --sign-def=rnd --seed="$((RANDOM))" --const n="$frozen" -V0  --out-atomf="%s." | ghead -n -1 | sed 's/\. /.\n/g' > $NEW_DIR/$LOG_NAME."$number"_random_edits_"$frozen"_frozen_nodes.damaged_model

            clingo new_petri_net.lp $NEW_DIR/$LOG_NAME.model   $NEW_DIR/$LOG_NAME."$number"_random_edits.txt -V0  --out-atomf="%s." | ghead -n -1 | sed 's/\. /.\n/g' >> $NEW_DIR/$LOG_NAME."$number"_random_edits_"$frozen"_frozen_nodes.damaged_model
        done
    done
done




