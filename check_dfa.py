import clingo
import sys 
from argparse import ArgumentParser
from pathlib import Path

def parse_args():
	p = ArgumentParser(prog=Path(__file__).stem)
	p.add_argument("dfa", type=str, help="Facts encoding a DFA.")
	p.add_argument("examples", type=str, help="Facts encoding examples.")

	return p.parse_args()

if __name__ == '__main__':
	args = parse_args()
	DFA_STEP_PRG = Path(__file__).parent / 'dfa_repair' / 'dfa.lp'

	ctl = clingo.Control()
	ctl.load(DFA_STEP_PRG.as_posix())
	ctl.load(args.dfa)
	ctl.load(args.examples)

	ctl.ground([("base",[])])

	h = ctl.solve()
	with ctl.solve(yield_=True) as H:
		model = H.model()
		issues = model.symbols(shown=True)
		if len(issues) == 0:
			print("No issues! DFA is good!")
		else:
			print("Found issues:")
			for atom in issues:
				print("* ", atom)
