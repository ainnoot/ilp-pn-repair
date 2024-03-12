from dataclasses import dataclass
from typing import Tuple
import re


@dataclass(frozen=True)
class Trace:
    events: Tuple[str, ...]
    positive: bool

    def __post_init__(self):
        for event in self.events:
            ans = re.fullmatch("[a-z0-9_]+", event)
            if ans is None:
                err = "Event: {} does not match expected format: [a-z][a-z0-9_]*".format(event)
                raise RuntimeError(err)
