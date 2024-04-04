import os
from typing import Tuple

from ipl.learner import Learner
from ipl.model import Trace
from aalpy.learning_algs import run_RPNI


class RPNILearner(Learner):
    def __init__(self):
        super().__init__()
        self.examples = list()
        self.last_model = None
        self.learning_shot = 0

    def learn(self, batch: Tuple[Trace]):
        for trace in batch:
            self.examples.append((trace.events, trace.positive))
        model = run_RPNI(self.examples, automaton_type='dfa', print_info=False)
        self.learning_shot += 1
        model.make_input_complete()
        model.minimize()
        self.last_model = model

    @property
    def model(self):
        return self.last_model


    def save(self, path):
        filename = "model_{}.pdf".format(self.learning_shot)
        self.last_model.save(os.path.join(path, filename))
