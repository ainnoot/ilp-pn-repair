"""
Reifies a Petri Net into a set of facts.
"""
from pathlib import Path
from typing import List
from ilp_petri_net_repair.misc import str_sequence
import clingo
from pm4py.objects.petri_net.obj import PetriNet, Marking
from abc import ABC, abstractmethod
from loguru import logger
from itertools import chain

class InvalidWorkflowNetException(Exception):
    pass

class PetriNetReificationScheme(ABC):
    @abstractmethod
    def reify_place(self, place: PetriNet.Place) -> clingo.Function:
        pass

    @abstractmethod
    def reify_transition(self, transition: PetriNet.Transition) -> clingo.Function:
        pass

    @abstractmethod
    def reify_arc(self, arc: PetriNet.Arc) -> clingo.Function:
        pass

    def reify_petri_net(self, petri_net: PetriNet) -> List[clingo.Function]:
        facts = []
        for place in petri_net.places:
            facts.append(self.reify_place(place))

        for transition in petri_net.transitions:
            facts.append(self.reify_transition(transition))

        for arc in petri_net.arcs:
            facts.append(self.reify_arc(arc))

        return facts

    @abstractmethod
    def reify_initial_marking(self, initial_marking: Marking) -> List[clingo.Function]:
        pass

    @abstractmethod
    def reify_final_marking(self, final_marking: Marking) -> List[clingo.Function]:
        pass

    @abstractmethod
    def reify(self, petri_net: PetriNet, initial_marking: Marking, final_marking: Marking):
        pass

class PetriNetReification(PetriNetReificationScheme):
    def __init__(self):
        self.ctl = None
        self.place_seq = str_sequence('p')
        self.transition_seq = str_sequence('t')

    def __initialize_ctl__(self):
        del self.ctl
        self.ctl = clingo.Control()

    def reify_place(self, place: PetriNet.Place):
        return clingo.Function("place", [
            clingo.String(place.name)
        ])

    def reify_transition(self, transition: PetriNet.Transition):
        return clingo.Function("trans", [
            clingo.String(transition.name),
            clingo.String(transition.label)
        ])

    def reify_arc(self, arc: PetriNet.Arc):
        return clingo.Function("arc", [
            clingo.String(arc.source.name),
            clingo.String(arc.target.name),
            clingo.Number(arc.weight)
        ])

    def reify_initial_marking(self, initial_marking: Marking):
        if len(initial_marking) == 0:
            logger.error("Empty initial marking!")
            return []

        return [
            clingo.Function("initial_marking", [
                clingo.String(place.name),
                clingo.Number(cnt)
            ])
            for place, cnt in initial_marking.items()
        ]

    def reify_final_marking(self, final_marking: Marking):
        if len(final_marking) == 0:
            logger.error("Empty final marking!")
            return []

        return [
            clingo.Function("final_marking", [
                clingo.String(place.name),
                clingo.Number(cnt)
            ])
            for place, cnt in final_marking.items()
        ]

    def reify(self, petri_net: PetriNet, initial_marking: Marking, final_marking: Marking):
        self.__initialize_ctl__()
        self.ctl.load((Path(__file__).parent / 'remap.lp').as_posix())

        with self.ctl.backend() as backend:
            for fact in chain(
                self.reify_petri_net(petri_net),
                self.reify_initial_marking(initial_marking),
                self.reify_final_marking(final_marking)
            ):
                ctl_id = backend.add_atom(fact)
                backend.add_rule((ctl_id,))

        self.ctl.ground([("base", [])])
        ans = []
        with self.ctl.solve(yield_=True) as ctl_handler:
            if ctl_handler.get().unsatisfiable:
                raise InvalidWorkflowNetException()

            model = ctl_handler.model()
            for symbol in model.symbols(shown=True):
                ans.append(symbol)

        return ans