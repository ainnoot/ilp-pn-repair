"""
Reifies an Examples object into ILASP examples.

TODO: Inclusions (pos(X), neg(X) ? see dfa.lp)
TODO: ctx? (~ a single word? a branch of the prefix tree?)
TODO: define HP, call ILASP
"""


from enum import Enum
import clingo
from typing import Sequence
from dataclasses import dataclass

from dfa_repair.examples import Example, Examples


class ILASPExampleType(Enum):
    POSITIVE = "pos"
    NEGATIVE = "neg"

@dataclass(frozen=True)
class ILASPExample:
    __uid = 0

    type: ILASPExampleType
    identifier: str
    inclusions: Sequence[clingo.Symbol]
    exclusions: Sequence[clingo.Symbol]
    ctx: str

    @staticmethod
    def from_examples(es: Examples):
        ILASPExample.__uid += 1

        return [ILASPExample(
            ILASPExampleType.POSITIVE if e.label else ILASPExampleType.NEGATIVE,
            'eid_{}'.format(ILASPExample.__uid),
            [clingo.Function('placeholder...')],
            [clingo.Function('placeholder...')],
            "%%% Placeholder Ctx %%%"
        ) for e in es]

    def __str__(self):
        return "#{}({},{{ {} }},{{ {} }},{{\n\t{}\n}}).".format(
            self.type.value,
            self.identifier,
            ", ".join(str(x) for x in self.inclusions),
            ", ".join(str(x) for x in self.exclusions),
            self.ctx
        )

