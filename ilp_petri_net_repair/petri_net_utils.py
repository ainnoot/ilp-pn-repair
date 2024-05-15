import sys
from itertools import chain

from pm4py import PetriNet, Marking
from pm4py.objects.petri_net.utils.petri_utils import add_place, add_transition, add_arc_from_to, remove_place, \
    remove_transition
from collections import namedtuple

from ilp_petri_net_repair.utils import normalize_string


def integer_sequence_with_prefix(prefix):
    x = 0
    while True:
        yield f"{prefix}_{x}"
        x += 1

def relabel_everything_because_i_dont_like_how_pm4py_names_things(pn: PetriNet, im: Marking, fm: Marking):
    mapping = dict()
    place_sequence = integer_sequence_with_prefix("p")
    trans_sequence = integer_sequence_with_prefix("t")

    petri_net = PetriNet()
    for p in pn.places:
        p_new = add_place(petri_net, next(place_sequence))
        mapping[p] = p_new

    for t in pn.transitions:
        t_new = add_transition(petri_net, next(trans_sequence), normalize_string(t.label))
        mapping[t] = t_new

    for arc in pn.arcs:
        add_arc_from_to(mapping[arc.source], mapping[arc.target], petri_net, arc.weight)

    new_im = Marking()
    for p, cnt in im.items():
        new_im[mapping[p]] = cnt

    new_fm = Marking()
    for p, cnt in fm.items():
        new_fm[mapping[p]] = cnt

    return (petri_net, new_im, new_fm), mapping

def check_equals_under_mapping(pn1: PetriNet, pn2: PetriNet, mapping, i1: Marking, i2: Marking, f1: Marking, f2: Marking):
    assert len(pn1.places) == len(pn2.places)
    assert len(pn1.transitions) == len(pn2.transitions)
    assert len(pn1.arcs) == len(pn2.arcs)

    # Check that all places have the same out arcs
    for p1 in pn1.places:
        p2 = mapping[p1]
        assert len(p1.out_arcs) == len(p2.out_arcs)
        assert len(p1.in_arcs) == len(p2.in_arcs)

    for t1 in pn1.transitions:
        t2 = mapping[t1]
        assert len(t1.out_arcs) == len(t2.out_arcs)
        assert len(t1.in_arcs) == len(t2.in_arcs)

    for arc in pn1.arcs:
        src1, tar1 = arc.source, arc.target
        src2, tar2 = mapping[src1], mapping[tar1]

        # Check that (src2, tar2) is an arc...
        for y in mapping[src1].out_arcs:
            if y.target.name == tar2.name:
                break
        else:
            assert False, f"Expected to find ({src2} -> {tar2}), because ({src1} -> {tar1}) is an arc"

        # Check that (src2, tar2) is an arc...
        for x in mapping[tar1].in_arcs:
            if x.source.name == src2.name:
                break
        else:
            assert False, f"Expected to find ({src2} <- {tar2}), because ({src1} -> {tar1}) is an arc"

    sorted_cnts_1 = sorted([i for i in f1.values()])
    sorted_cnts_2 = sorted([i for i in f2.values()])
    assert sorted_cnts_1 == sorted_cnts_2, "Wrong final marking counts: {} {}".format(sorted_cnts_1, sorted_cnts_2)

    sorted_cnts_1 = sorted([i for i in i1.values()])
    sorted_cnts_2 = sorted([i for i in i2.values()])
    assert sorted_cnts_1 == sorted_cnts_2, "Wrong initial counts: {} {}".format(sorted_cnts_1, sorted_cnts_2)

    return True

def add_source_and_sink(pn: PetriNet, im: Marking, fm: Marking) -> (PetriNet, Marking, Marking):
    source_place = add_place(pn, "source_place")
    sink_place = add_place(pn, "sink_place")
    source_transition = add_transition(pn, "source_transition", "workflow_start")
    sink_transition = add_transition(pn, "sink_transition", "workflow_end")

    add_arc_from_to(source_place, source_transition, pn, 1)
    for place, token_count in im.items():
        add_arc_from_to(
            source_transition,
            place,
            pn,
            token_count
        )

    add_arc_from_to(sink_transition, sink_place, pn, 1)
    for place, token_count in fm.items():
        add_arc_from_to(
            place,
            sink_transition,
            pn,
            token_count
        )

    new_im = Marking()
    new_im[source_place] = 1
    new_fm = Marking()
    new_fm[sink_place] = 1

    return pn, new_im, new_fm, (source_place, sink_place)

def petri_net_directed_reachability(start, end):
    stack = [(start, [start])]
    visited = set()
    visited.add(start)

    while len(stack) > 0:
        cur, path = stack.pop(0)
        if cur.name == end.name:
            return path

        for arc in cur.out_arcs:
            obj = arc.target
            if obj not in visited:
                stack.append((obj, [*path, obj]))
                visited.add(obj)

    return []

def remove_disconnected_objects_2(pn: PetriNet, start: PetriNet.Place, end: PetriNet.Place):
    # bovino, ma funziona - si può semplificare molto per evitare conti in più

    possible_objects = set() # Places \cup Transitions
    safe = set()
    for p in pn.places:
        possible_objects.add(p)

    for t in pn.transitions:
        possible_objects.add(t)

    for o in possible_objects:
        # Vedo se o è raggiungibile da SOURCE
        # e se o raggiunge SINK
        src_to_o = petri_net_directed_reachability(start, o)
        o_to_snk = petri_net_directed_reachability(o, end)

        # se sì, tutti gli oggetti nel path che ho trovato
        # sono sicuramente da includere nella workflow-net
        if src_to_o != [] and o_to_snk != []:
            for x in chain(src_to_o, o_to_snk):
                safe.add(x)

    # rimuovo le cose per le quali non ho trovato un path
    for o in possible_objects:
        if o not in safe:
            if isinstance(o, PetriNet.Place):
                remove_place(pn, o)
            else:
                remove_transition(pn, o)

    return pn

# TODO: Non termina su alcuni log, c'è qualche bug nella BFS
def remove_disconnected_objects(pn: PetriNet, start: PetriNet.Place, end: PetriNet.Place):
    SearchNode = namedtuple('SearchNode', 'current_node path')
    stack = [SearchNode(start, [start])]
    objects_to_remove = set()

    for place in pn.places:
        objects_to_remove.add(place)

    for trans in pn.transitions:
        objects_to_remove.add(trans)

    visited = set()

    while len(stack) > 0:
        node = stack.pop(0)

        if node.current_node == end:
            for x in node.path:
                objects_to_remove.discard(x)
            continue

        for arc in node.current_node.out_arcs:
            target = arc.target
            if target not in node.path:
                stack.append(
                    SearchNode(target, [*node.path, target])
                )
                visited.add(target)

    for x in objects_to_remove:
        if isinstance(x, PetriNet.Place):
            remove_place(pn, x)
        elif isinstance(x, PetriNet.Transition):
            remove_transition(pn, x)
        else:
            raise RuntimeError("Expected Place or Transition, got {}".format(type(x)))

    return pn
