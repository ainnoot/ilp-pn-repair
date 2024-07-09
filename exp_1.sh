DIR=experiments_1/
## Alpha 
# Create hyp space
clingo $DIR/pi_H.lp $DIR/alpha.model 0 -W none -V0 | sed -E 's/\(([^,]+),(.+)\)/\1 ~ \2./' | ghead -n -1 > $DIR/search_space_alpha.lp
# Solve ILP task 
ILASP --version=2i pi_edits.lp pi_semantics.lp $DIR/search_space_alpha.lp $DIR/alpha.model $DIR/examples.las struct_examples.las  > $DIR/result_alpha.lp

## Alpha ++
# Create hyp space
clingo $DIR/pi_H.lp $DIR/alpha_pp.model 0 -W none -V0 | sed -E 's/\(([^,]+),(.+)\)/\1 ~ \2./' | ghead -n -1 > $DIR/search_space_alpha_pp.lp
# Solve ILP task 
ILASP --version=2i pi_edits.lp pi_semantics.lp $DIR/search_space_alpha_pp.lp $DIR/alpha_pp.model $DIR/examples.las struct_examples.las  > $DIR/result_alpha_pp.lp