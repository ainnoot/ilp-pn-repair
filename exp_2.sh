#!/bin/bash

ILASP_DIR=experiments_2
############
# Create Hyp Space and Run ILASP
############
for DIR in $ILASP_DIR/*/ ; do
    for MODEL in $DIR*.damaged_model; do
        FILENAME=$(basename -- "$MODEL")
        LOG_NAME=${FILENAME%.*}
        # Create hypothesis space
        clingo $ILASP_DIR/pi_H.lp $DIR$FILENAME 0 -W none -V0 | sed -E 's/\(([^,]+),(.+)\)/\1 ~ \2./' | ghead -n -1 > $DIR$LOG_NAME.search_space.lp
        # Solve ILP task 
        timeout 600 ILASP --version=2i pi_edits.lp pi_semantics.lp $DIR$LOG_NAME.search_space.lp $DIR$FILENAME $DIR/examples.las struct_examples.las  > $DIR$LOG_NAME.ILP_edits.lp
        # If timeout, write comment
        exit_status=$?
        if [[ $exit_status -eq 124 ]]; then
            echo "%Timeout for: ${FILENAME}" > $DIR$LOG_NAME.ILP_edits.lp
        fi
    done
done

############
# Extract Results
############
for DIR in $ILASP_DIR/*/ ; do
  echo %%%%%%%%%%%%%%%%%%%%%%% 
  echo $DIR
  echo %%%%%%%%%%%%%%%%%%%%%%% 
  edits="$DIR"all_edits.txt
  # change original edits to make it consistent
  sed -i.bak -e 's/edit(add, */remove(/g' -e 's/edit(remove, */add(/g' "$edits"
  considered_edits=$(mktemp)
  # For each ILP result in current dir
  for f in "$DIR"/*ILP_edits.lp; do
    file=$(basename -- "$f")
    number_edits=${file%%_random_edits*}
    number_edits=${number_edits##*_}
    ghead -n $number_edits $edits  > $considered_edits

    filtered_content=$(grep -v '^\s*$\|^\s*%' "$f")
    echo "$filtered_content" | sed 's/, /,/g' > "$f.v2"

    matching_lines=$(comm -12 <(sort "$f.v2") <(sort "$considered_edits") | wc -l)

    percentage=$(echo "scale=2; $matching_lines / $number_edits * 100" | bc)

    time=$(sed -n '8s/[^[:digit:].]//gp' "$f")
    echo "$file has $percentage% of matching in $time seconds."

  done
done
