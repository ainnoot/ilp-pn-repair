"""
Reifies a Petri Net into a set of facts.
"""
from typing import Generator, Tuple, List

import clingo
from pm4py.objects.petri_net.obj import PetriNet, Marking
from pm4py.analysis import check_is_workflow_net
from ilp_petri_net_repair import WorkflowNetExpectedException, BadMarkingException, UnsupportedSilentTransition
from ilp_petri_net_repair.utils import normalize_string
def validate_initial_marking(im: Marking):
    return validate_unique_token(im)

def validate_final_marking(fm: Marking):
    return validate_unique_token(fm)

def validate_unique_with_name_and_count(m: Marking, name: str, count: int):
    items = list(m.items())
    name_, count_ = items[0][0].name, items[0][1]
    return name == name_ and count_ == count

def validate_unique_token(m: Marking):
    items = list(m.items())
    count_ = items[0][1]
    return count_ == 1


def reify_final_marking(place: PetriNet.Place, cnt: int):
    return clingo.Function("final_marking", [
        clingo.Function(place.name),
        clingo.Number(cnt)
    ])

def reify_initial_marking(place: PetriNet.Place, cnt: int):
    return clingo.Function("source_marking", [
        clingo.Function(place.name),
        clingo.Number(cnt)
    ])

def reify_arc(arc: PetriNet.Arc):
    src, tgt = arc.source, arc.target
    predicate_name = 'ptarc' if isinstance(src, PetriNet.Place) else 'tparc'

    return clingo.Function(predicate_name, [
            clingo.Function(arc.source.name),
            clingo.Function(arc.target.name),
            clingo.Number(arc.weight)
        ])

def reify_place(place: PetriNet.Place):
    return clingo.Function("place", [
        clingo.Function(place.name)
    ])


def reify_trans(trans: PetriNet.Transition):
    if trans.label is None:
        raise UnsupportedSilentTransition("Got: {}".format(trans))

    return clingo.Function("trans", [
        clingo.Function(trans.name),
        clingo.Function(normalize_string(trans.label))
    ])

def reify_label(label: str):
    return clingo.Function("label", [clingo.Function(normalize_string(label))])


def reify_workflow_net(pn: PetriNet, im: Marking, fm: Marking) -> Generator[clingo.Symbol, None, None]:
    if not check_is_workflow_net(pn):
        raise WorkflowNetExpectedException()

    if not validate_final_marking(fm):
        raise BadMarkingException()

    if not validate_initial_marking(im):
        raise BadMarkingException()

    for p, cnt in im.items():
        yield reify_initial_marking(p, cnt)

    for p, cnt in fm.items():
        yield reify_final_marking(p, cnt)

    for place in pn.places:
        yield reify_place(place)

    for trans in pn.transitions:
        yield reify_trans(trans)
        yield reify_label(trans.label)

    for arc in pn.arcs:
        yield reify_arc(arc)

def reify_petri_net(pn: PetriNet, im: Marking, fm: Marking) -> Tuple[List[clingo.Symbol], List[clingo.Symbol], List[clingo.Symbol]]:
    pn_facts = []
    im_facts = []
    fm_facts = []

    for p, cnt in im.items():
        im_facts.append(clingo.Function('initial_marking', [
            clingo.Function(p.name),
            clingo.Number(cnt)
        ]))

    for p, cnt in fm.items():
        fm_facts.append(clingo.Function('final_marking', [
            clingo.Function(p.name),
            clingo.Number(cnt)
        ]))

    for place in pn.places:
        pn_facts.append(clingo.Function('place', [clingo.Function(place.name)]))

    for trans in pn.transitions:
        pn_facts.append(clingo.Function('trans', [
            clingo.Function(trans.name),
            clingo.Function(normalize_string(trans.label))
        ]))

        pn_facts.append(clingo.Function('label', [
            clingo.Function(normalize_string(trans.label))
        ]))

    for arc in pn.arcs:
        src, tgt = arc.source, arc.target
        predicate_name = 'ptarc' if isinstance(src, PetriNet.Place) else 'tparc'

        pn_facts.append(clingo.Function(predicate_name, [
            clingo.Function(arc.source.name),
            clingo.Function(arc.target.name),
            clingo.Number(arc.weight)
        ]))

    return pn_facts, im_facts, fm_facts


def define_ilasp_constants(pn: PetriNet, private: str) -> Generator[str, None, None]:
    mask = "#constant({type}, {constant_value})."

    for p in pn.places:
        if p.name.startswith(private):
            continue

        yield mask.format(type="place", constant_value=p.name)

    for t in pn.transitions:
        if t.label is None:
            raise UnsupportedSilentTransition("Got: {}".format(t))

        if t.name.startswith(private):
            continue

        yield mask.format(type="transition", constant_value=t.name)
        yield mask.format(type="label", constant_value=normalize_string(t.label))

    yield mask.format(type="weight", constant_value="1")
