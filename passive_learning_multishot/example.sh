#! /usr/bin/bash

if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <log folder> <output folder>"
		echo "log folder: a folder that contains a pos.xes and neg.xes file, respectively positive and negative traces."
		echo "output folder: learned automata will be stored here"
    exit 1
fi

python3 learn_from_log.py "$1" 100 "$2" -s 77 -d
