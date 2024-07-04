#!/bin/bash
number_of_edits=(5 10 15 20)
number_of_frozen_elements=(0 4 8 12)
max_edit=20
max_frozen=12
PNML=Syntetic_data_new/dd.pnml
EXAMPLES=Syntetic_data_new/dd.xes
ILASP_DIR=experiments
for ID in {0..3}; do
    FILENAME=$(basename -- "$PNML")
    LOG_NAME=${FILENAME%.*}$ID
    NEW_DIR="$ILASP_DIR/$LOG_NAME"
    mkdir -p "$NEW_DIR"
    # Create model
    python3 reify_petri_net.py $PNML $NEW_DIR/$LOG_NAME.model
    # Create examples
    python3 reify_log.py $EXAMPLES > $NEW_DIR/examples.las

    # Create damaged version (add or remove $max_edit edges)
    clingo damage_net.lp $NEW_DIR/$LOG_NAME.model --rand-freq=1 --sign-def=rnd --seed="$((RANDOM))" --const n="$max_edit" -V0  --out-atomf="%s." | ghead -n -1 | sed 's/\. /.\n/g' | shuf > $NEW_DIR/all_edits.txt

    # Select $max_frozen nodes to freeze in the model (not involved in edits)
    clingo frozen_net.lp $NEW_DIR/$LOG_NAME.model $NEW_DIR/all_edits.txt --rand-freq=1 --sign-def=rnd --seed="$((RANDOM))" --const n="$max_frozen" -V0  --out-atomf="%s." | ghead -n -1 | sed 's/\. /.\n/g' > $NEW_DIR/frozen_nodes.txt

    
    for number in "${number_of_edits[@]}"
    do
        temp_file=$(mktemp)
        # Pick $number edits
        ghead -n $number $NEW_DIR/all_edits.txt  > $temp_file

        for frozen in "${number_of_frozen_elements[@]}"
        do  
            # Pick $frozen nodes 
            ghead -n $frozen $NEW_DIR/frozen_nodes.txt  > $NEW_DIR/"$(printf "%02d" $number)"_random_edits_"$(printf "%02d" $frozen)"_frozen_nodes.damaged_model
            # Create model with edits
            clingo new_petri_net.lp $NEW_DIR/$LOG_NAME.model  $temp_file -V0  --out-atomf="%s." | ghead -n -1 | sed 's/\. /.\n/g' >> $NEW_DIR/"$(printf "%02d" $number)"_random_edits_"$(printf "%02d" $frozen)"_frozen_nodes.damaged_model
        done
    done
done




