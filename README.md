# Scripts
Python scripts in the folder and the `ilp_petri_net_repair` provide auxiliary functionalities to handle PNML and XES data (e.g., mapping them to ASP facts and ILASP examples). Refer to their usage into the `*.sh` script or in the command line args description.

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
