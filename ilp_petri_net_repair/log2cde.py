import sys
from typing import Sequence

import clingo
import pm4py
from pm4py.objects.log.util import pandas_numpy_variants
from dataclasses import dataclass
from string import Template
import textwrap
from abc import ABC, abstractmethod


def extract_variants(log_path):
    log = pm4py.read_xes(log_path)

    variants_dict, case_variant = pandas_numpy_variants.apply(log)
    return variants_dict, case_variant

def pad_trace(trace, start_activity, end_activity):
    return start_activity, *trace, end_activity

@dataclass(frozen=True)
class ContextDependentExample:
    __TEMPLATE__ = "#$POLARITY($IDENTIFIER@$PENALTY, {$INCLUSION_SET}, {$EXCLUSION_SET}, {\n$CONTEXT\n})."
    positive: bool
    identifier: str
    penalty: int
    inclusions: Sequence[clingo.Function]
    exclusions: Sequence[clingo.Function]
    context: str

    def __str__(self):
        t = Template(ContextDependentExample.__TEMPLATE__)
        return t.substitute({
            "POLARITY": "pos" if self.positive else "neg",
            "INCLUSION_SET": ",".join(str(x) for x in self.inclusions),
            "EXCLUSION_SET": ",".join(str(x) for x in self.exclusions),
            "CONTEXT": '\n'.join(textwrap.wrap(self.context, 80, initial_indent='  ', subsequent_indent='  ')),
            "IDENTIFIER": self.identifier,
            "PENALTY": self.penalty
        })

def trace_example(trace, identifier, is_positive):
    padded_trace = pad_trace(trace, '__START__', '__END__')
    facts = [clingo.Function('trace', [clingo.Number(t), clingo.String(e)]) for t, e in enumerate(padded_trace)]

    inclusions, exclusions = ((clingo.Function('recognized',),), tuple())
    if not is_positive:
        exclusions, inclusions = inclusions, exclusions

    return ContextDependentExample(
        True,
        identifier,
        0,
        inclusions,
        exclusions,
        " ".join("{}.".format(x) for x in facts)
    )

class LogReificationScheme(ABC):
    @abstractmethod
    def trace_filter(self, trace) -> bool:
        """
        Returns True if trace is to be reified as a positive example,
        False otherwise.
        """
        pass

    @abstractmethod
    def reify_trace(self, trace) -> ContextDependentExample:
        pass

    @abstractmethod
    def reify_traces(self, traces: Sequence[str]):
        pass