#! /usr/bin/bash

if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <log folder> <output folder>"
    exit 1
fi

python3 learn_from_log.py "$1" 100 "$2" -s 77 -d
