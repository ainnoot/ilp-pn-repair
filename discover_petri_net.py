from pathlib import Path

import pm4py
import sys

from pm4py.discovery import (
	discover_petri_net_alpha,
	discover_petri_net_alpha_plus,
	discover_petri_net_inductive,
	discover_petri_net_heuristics,
	discover_petri_net_ilp
)
from pm4py.analysis import reduce_petri_net_invisibles
from ilp_petri_net_repair import relabel_everything_because_i_dont_like_how_pm4py_names_things, \
	check_equals_under_mapping

METHODS = {
	'alpha': discover_petri_net_alpha,
	'alpha_plus': discover_petri_net_alpha_plus,
	'inductive': discover_petri_net_inductive,
	'heuristics': discover_petri_net_heuristics,
	'ilp': discover_petri_net_ilp
}

def parse_args():
	if len(sys.argv) != 5:
		print("Usage: {} [XES Log] [pm4py Discovery Method: {}] [PNML Output Directory] [Picture Directory]".format(__file__, "|".join(METHODS.keys())))
		sys.exit(118)

	log, method, pnml_dir, fig_dir = sys.argv[1:]
	if method not in METHODS:
		raise RuntimeError("Unknown method: got {} expected {}".format(method, METHODS))

	log = pm4py.read_xes(log)
	method = METHODS[method]
	return log, method, Path(pnml_dir), Path(fig_dir)


if __name__ == '__main__':
	log, method, pnml_dir, fig_dir = parse_args()
	pn, im, fm = method(log)
	pn = reduce_petri_net_invisibles(pn)
	(pn_r, im_r, fm_r), mapping = relabel_everything_because_i_dont_like_how_pm4py_names_things(pn, im, fm)
	check_equals_under_mapping(pn, pn_r, mapping, im, im_r, fm, fm_r)

	log_name = Path(sys.argv[1]).stem
	fig_file_path = (fig_dir / log_name).with_suffix(".png")
	pnml_path = (pnml_dir / log_name).with_suffix(".pnml")

	print("Saving picture to", fig_file_path.as_posix())
	pm4py.save_vis_petri_net(pn_r, im_r, fm_r, fig_file_path.as_posix())

	print("Saving PNML to", pnml_path.as_posix())
	pm4py.write_pnml(pn_r, im_r, fm_r, pnml_path.as_posix())
