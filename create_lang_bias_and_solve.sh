#!/bin/bash
clingo language_bias.lp $1 -n 0 -V0 | sed -E 's/\(([^,]+),(.+)\)/\1 ~ \2./' | ghead -n -1 > temp.lp
ILASP --version=2i background_knowledge.lp temp.lp $1 $2
rm temp.lp