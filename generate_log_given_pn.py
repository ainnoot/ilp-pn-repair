import pm4py
from pm4py.algo.simulation.playout.petri_net import algorithm as simulator
import sys

def parse_args():
	if len(sys.argv[1:]) != 3:
		print("Usage: {} [pnml] [num_traces] [xes output]".format(__file__))
		sys.exit(1)

	return sys.argv[1], int(sys.argv[2]), sys.argv[3]

if __name__ == '__main__':
	pnml, log_size, log_file = parse_args()
	pn, im, fm = pm4py.read_pnml(pnml)

	parameters={ simulator.Variants.BASIC_PLAYOUT.value.Parameters.NO_TRACES: log_size }

	log = simulator.apply(pn, im, fm, variant=simulator.Variants.BASIC_PLAYOUT, parameters=parameters)

	pm4py.write_xes(log, log_file)

