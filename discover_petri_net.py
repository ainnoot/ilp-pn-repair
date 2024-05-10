import pm4py
import sys
from pm4py.discovery import (
	discover_petri_net_alpha,
	discover_petri_net_alpha_plus,
	discover_petri_net_inductive,
	discover_petri_net_heuristics,
	discover_petri_net_ilp
)

METHODS = {
	'alpha': discover_petri_net_alpha,
	'alpha_plus': discover_petri_net_alpha_plus,
	'inductive': discover_petri_net_inductive,
	'heuristics': discover_petri_net_heuristics,
	'ilp': discover_petri_net_ilp
}

def parse_args():
	if len(sys.argv) != 3:
		print("Usage: {} [log] [method: {}]".format(__file__, "|".join(METHODS.keys())))
		sys.exit(118)

	log, method = sys.argv[1:] 
	if method not in METHODS:
		raise RuntimeError("Unknown method: got {} expected {}".format(method, METHODS))

	log = pm4py.read_xes(log)
	method = METHODS[method]
	return log, method

if __name__ == '__main__':
	log, method = parse_args()
	pn, im, fm = method(log)

	pm4py.save_vis_petri_net(pn, im, fm, "{}-{}.png".format(sys.argv[1], sys.argv[2]))
	pm4py.write_pnml(pn, im, fm, "{}-{}.pnml".format(sys.argv[1], sys.argv[2]))
