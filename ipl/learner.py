from typing import Tuple

from ipl.model import Trace
from abc import ABC, abstractmethod, abstractproperty

class Learner(ABC):
    def __init__(self):
        pass

    @abstractmethod
    def learn(self, batch: Tuple[Trace]):
        pass

    @property
    @abstractmethod
    def model(self):
        pass