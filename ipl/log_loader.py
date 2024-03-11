import pm4py
from ipl.model import Trace
from random import shuffle
from numpy.random import RandomState

__all__ = [
	'Examples'
]

def normalize(concept_name):
	tokens = concept_name.split(' ')
	return '_'.join(t.lower() for t in tokens)


def normalize_trace(trace: pm4py.objects.log.obj.Trace):
	trace_tuple = []
	for e in trace:
		concept_name = e['concept:name']
		trace_tuple.append(normalize(concept_name))
	return tuple(trace_tuple)


def load_logs(positive_log, negative_log):
	poslog = pm4py.read_xes(positive_log, return_legacy_log_object=True)
	neglog = pm4py.read_xes(negative_log, return_legacy_log_object=True)

	traces = []
	for pi in poslog:
		trace = normalize_trace(pi)
		traces.append(Trace(trace, True))

	for pi in neglog:
		trace = normalize_trace(pi)
		traces.append(Trace(trace, False))

	return tuple(traces)


class Examples:
	def __init__(self, positive, negative, seed=77):
		self.randomness = RandomState(seed)
		self.examples = load_logs(positive, negative)
		self.batch_size_ = None
		self.num_examples = len(self.examples)

	def batch(self, n):
		self.batch_size_ = n
		return self

	def shuffle(self):
		shuffled_examples = list(self.examples)
		self.randomness.shuffle(shuffled_examples)
		self.examples = tuple(shuffled_examples)
		return self

	def __iter__(self):
		if self.batch_size_ is None:
			self.batch_size_ = 5
			print("[!] Have you set batch_size?")

		bs = self.batch_size_
		for idx in range(0, self.num_examples, bs):
			yield tuple(self.examples[idx:idx+bs])
