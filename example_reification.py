from dfa_repair.examples import Examples, Example
from dfa_repair.reify_as_ilasp import ILASPExample
from dfa_repair.reify_as_facts import reify_as_facts

if __name__ == '__main__':
    pt = Examples()
    pt.add(Example(('a', 'b', 'a', 'b', 'a'), False))
    pt.add(Example(('a', 'b', 'a'), False))
    pt.add(Example(('a', 'b', 'a', 'b'), True))
    pt.add(Example(('a', 'a', 'b'), True))

    for f in reify_as_facts(pt):
        print("{}.".format(f))

    for e in ILASPExample.from_examples(pt):
        print(e)