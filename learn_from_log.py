from pathlib import Path

from ipl.aalpy_rpni_learner import RPNILearner
from ipl.log_loader import Examples
import sys

if __name__ == '__main__':
    if len(sys.argv) != 5:
        print("Usage: {} [positive traces] [negative traces] [batch size] [output folder]".format(__file__))
        print("  * positive traces: Path to a XES file containing positive traces.")
        print("  * negative traces: Path to a XES file containing positive traces.")
        print("  * batch size: Number of examples that go into the learner.")
        print("  * output folder: Folder that stores intermediate learned models.")
        sys.exit(1)

    _, poslog, neglog, bs, output_folder = sys.argv
    bs = int(bs)
    output_folder = Path(output_folder)

    examples = Examples(poslog, neglog)
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
