from pathlib import Path

from ipl.aalpy_rpni_learner import RPNILearner
from ipl.log_loader import Examples
import sys

if __name__ == '__main__':
    if len(sys.argv) != 4:
        print("Usage: {} [log folder] [batch size] [output folder]".format(__file__))
        print("  * log folder: Path to folder containing pos.xes, neg.xes.")
        print("  * batch size: Number of examples that go into the learner.")
        print("  * output folder: Folder that stores intermediate learned models.")
        sys.exit(1)

    _, log_folder, bs, output_folder = sys.argv
    bs = int(bs)
    output_folder = Path(output_folder)
    log_folder = Path(log_folder)

    poslog = log_folder / 'pos.xes'
    neglog = log_folder / 'neg.xes'
    if not poslog.exists():
        print("File does not exist:", poslog)
        sys.exit(1)

    if not neglog.exists():
        print("File does not exist:", neglog)
        sys.exit(1)

    examples = Examples(poslog.as_posix(), neglog.as_posix(), True, 77)
    learner = RPNILearner()

    for bs_idx, E in enumerate(examples.shuffle().batch(bs)):
        print("Solving shot: {}".format(bs_idx))
        learner.learn(E)

        if learner.model is None:
            print("Stopped. RPNI found no model.")
            sys.exit(1)

        model_path = "learned_model_{}.pdf".format(bs_idx)
        print("Saving model to: {}".format(output_folder / model_path))
        learner.model.visualize(output_folder / model_path)
