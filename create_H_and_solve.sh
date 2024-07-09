#!/bin/bash
# Create hyp space
clingo $1/pi_H.lp $1/pi_M.lp 0 -W none -V0 | sed -E 's/\(([^,]+),(.+)\)/\1 ~ \2./' | ghead -n -1 > $1/H.lp
# Solve ILP task 
ILASP --version=2i pi_edits.lp pi_semantics.lp $1/H.lp $1/pi_M.lp $1/examples.las struct_examples.las  

