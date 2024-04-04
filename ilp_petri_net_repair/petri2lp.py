"""
Reifies a Petri Net into a set of facts.
"""
from typing import List

import clingo
from pm4py.objects.petri_net.obj import PetriNet, Marking
from abc import ABC, abstractmethod
from loguru import logger

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

    def reify(self, petri_net: PetriNet, initial_marking: Marking, final_marking: Marking):
        facts = self.reify_petri_net(petri_net)
        facts.extend(self.reify_initial_marking(initial_marking))
        facts.extend(self.reify_final_marking(final_marking))

        return facts

class PetriNetReification(PetriNetReificationScheme):
    def reify_place(self, place: PetriNet.Place):
        return clingo.Function("place", [
            clingo.String(place.name)
        ])

    def reify_transition(self, transition: PetriNet.Transition):
        return clingo.Function("transition", [
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

        facts = []
        for place, cnt in initial_marking.items():
            fact = clingo.Function("initial_marking", [
                clingo.String(place.name),
                clingo.Number(cnt)
            ])
            facts.append(fact)

        return facts

    def reify_final_marking(self, final_marking: Marking):
        if len(final_marking) == 0:
            logger.error("Empty final marking!")
            return []

        facts = []
        for place, cnt in final_marking.items():
            fact = clingo.Function("final_marking", [
                clingo.String(place.name),
                clingo.Number(cnt)
            ])
            facts.append(fact)
        return facts

