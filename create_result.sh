#!/bin/bash
for directory in experiments/*/ ; do
  echo %%%%%%%%%%%%%%%%%%%%%%% 
  echo $directory
  echo %%%%%%%%%%%%%%%%%%%%%%% 
  edits="$directory"all_edits.txt
  # change original edits to make it consistent
  sed -i.bak -e 's/edit(add, */remove(/g' -e 's/edit(remove, */add(/g' "$edits"
  considered_edits=$(mktemp)
  # For each ILP result in current dir
  for f in "$directory"/*ILP_edits.lp; do
    file=$(basename -- "$f")
    number_edits=${file%%_random_edits*}
    number_edits=${number_edits##*_}
    ghead -n $number_edits $edits  > $considered_edits

    filtered_content=$(grep -v '^\s*$\|^\s*%' "$f")
    echo "$filtered_content" | sed 's/, /,/g' > "$f.v2"

    matching_lines=$(comm -12 <(sort "$f.v2") <(sort "$considered_edits") | wc -l)

    percentage=$(echo "scale=2; $matching_lines / $number_edits * 100" | bc)


    if [ -s "$f.v2" ]; then
      time=$(sed -n '8s/[^[:digit:].]//gp' "$f")
      echo "$file has $percentage% of matching in $time seconds."
    else
      echo "$file timed out"
    fi

  done
done

