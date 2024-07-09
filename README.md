## `reify_log`
```
usage: reify_log [-h] log

Reifies a XES event log into a set of ILASP examples.

positional arguments:
  log         Path to XES file.

options:
  -h, --help  show this help message and exit
```

## `reify_pn`
```
usage: reify_pn [-h] pnml

Reifies a pm4py.PetriNet object into a set of ASP facts.

positional arguments:
  pnml        Path to PNML file.

options:
  -h, --help  show this help message and exit
```


## Petri Net encoding
```
place(P) 		
  - P: Unique identifier for a place.

trans(T,L)
  - T: Unique identifier for the transition
  - L: Label of the transition

ptarc(P, T, W)
  - Place P is in *T
  - Firing T removes W tokens from P

tparc(P, T, W)
  - Place P is in T*
  - Firing T adds W tokens to P
```
# Requirements
- Install ILASP v4.4.0: https://github.com/ilaspltd/ILASP-releases/releases
- Python lib in requirements.txt


# Repair Petri net with ILASP
Given a directory $DIR with a PNML file (Petri net) and a XES (log), and the file defining the considered edits pi_H.lp, to create the ASP model pi_M.lp and the examples from the log, run:
```
./create_ASP_model_and_examples.sh 
```
To solve the LAS task (considering also the structural requirements in struct_examples.las) run: 
```
./create_H_and_solve.sh
```

# Experiments
### Experiment 1
The following script finds the edits for the models identified with Alpha Miner (Sect 4.1)
```
./exp_1.sh 
```
The results can be found in the directory ./experiments_1/

### Experiment 2
The following script runs the ILASP for each damaged model in /experiments_2/ (Sect 4.2)
```
./exp_2.sh
```
The results can be found in the file ./experiments_2/results.txt
To create a new random set of damaged models, run 
```
./exp_2_create_damaged_model.sh
```
