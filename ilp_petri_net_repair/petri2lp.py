"""
Reifies a Petri Net into a set of facts.
"""
from typing import List

import clingo
from pm4py.objects.petri_net.obj import PetriNet, Marking
from abc import ABC, abstractmethod
from loguru import logger

class PetriNetReificationScheme(ABC):
    def __init__(self):
        self._facts = list()
    @abstractmethod
    def reify_place(self, place: PetriNet.Place):
        pass

    @abstractmethod
    def reify_transition(self, transition: PetriNet.Transition):
        pass

    @abstractmethod
    def reify_arc(self, arc: PetriNet.Arc):
        pass

    def reify_petri_net(self, petri_net: PetriNet):
        for place in petri_net.places:
            self._facts.append(self.reify_place(place))

        for transition in petri_net.transitions:
            self._facts.append(self.reify_transition(transition))

        for arc in petri_net.arcs:
            self._facts.append(self.reify_arc(arc))

    @abstractmethod
    def reify_initial_marking(self, initial_marking: Marking):
        pass

    @abstractmethod
    def reify_final_marking(self, final_marking: Marking):
        pass

    def reify(self, petri_net: PetriNet, initial_marking: Marking, final_marking: Marking):
        self.reify_petri_net(petri_net)
        self.reify_initial_marking(initial_marking)
        self.reify_final_marking(final_marking)

    @property
    def facts(self) -> List[clingo.Function]:
        return self._facts


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
        for place, cnt in initial_marking.items():
            fact = clingo.Function("initial_marking", [
                clingo.String(place.name),
                clingo.Number(cnt)
            ])
            self.facts.append(fact)

    def reify_final_marking(self, final_marking: Marking):
        for place, cnt in final_marking.items():
            fact = clingo.Function("final_marking", [
                clingo.String(place.name),
                clingo.Number(cnt)
            ])
            self.facts.append(fact)

    def __init__(self):
        super().__init__()


if __name__ == '__main__':
    from pm4py.read import read_pnml
    filename = '../example.pnml'
    pn, im, fm = read_pnml(filename, auto_guess_final_marking=True)

    if fm is None or len(fm) == 0:
        logger.error(f"Missing final marking for Petri Net in {filename=}")

    r = PetriNetReification()
    r.reify(pn, im, fm)
    for fact in r.facts:
        print(fact)

