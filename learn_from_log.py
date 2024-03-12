from pathlib import Path

from ipl.aalpy_rpni_learner import RPNILearner
from ipl.log_loader import Examples
import sys
from argparse import ArgumentParser
from dataclasses import dataclass

@dataclass(frozen=True)
class CLIArgs:
    log_folder: Path
    batch_size: int
    output_folder: Path
    seed: int
    deterministic: bool

def parse_args():
    parser = ArgumentParser()
    parser.add_argument("log_folder", type=str, help="Path to folder containing pos.xes, neg.xes.")
    parser.add_argument("batch_size", type=int, help="Number of examples that go into the learner at a time.")
    parser.add_argument("output_folder", type=str, help="Folder that stores intermediate learned models.")
    parser.add_argument("-s", "--seed", type=int, default=77, help="Random seed for reproducibility.")
    parser.add_argument("-d", "--deterministic", action="store_true", help="Make log deterministic; remove intersection between negative and positive traces.")

    args = parser.parse_args()
    args = CLIArgs(
        Path(args.log_folder),
        int(args.batch_size),
        Path(args.output_folder),
        int(args.seed),
        bool(args.deterministic)
    )

    poslog = args.log_folder / 'pos.xes'
    neglog = args.log_folder / 'neg.xes'

    if not poslog.exists():
        print("File does not exist:", poslog)
        sys.exit(1)

    if not neglog.exists():
        print("File does not exist:", neglog)
        sys.exit(1)

    return args

if __name__ == '__main__':
    args = parse_args()
    poslog = args.log_folder / 'pos.xes'
    neglog = args.log_folder / 'neg.xes'

    examples = Examples(poslog.as_posix(), neglog.as_posix(), args.deterministic, args.seed)
    learner = RPNILearner()

    for bs_idx, E in enumerate(examples.shuffle().batch(args.batch_size)):
        print("Solving shot: {}".format(bs_idx))
        learner.learn(E)

        if learner.model is None:
            raise RuntimeError("Model is None!")
            sys.exit(1)


    learner.save(args.output_folder.as_posix())

    print("LEARNED MODEL:")
    print(dir(learner.model))
    sys.exit(0)
