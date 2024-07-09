#!/bin/bash
# Create model
for MODEL in $1*.pnml; do
python3 reify_petri_net.py $MODEL $1/pi_M.lp
done 

# Create examples
for LOG in $1*.xes; do
python3 reify_log.py $LOG > $1/examples.las
done 