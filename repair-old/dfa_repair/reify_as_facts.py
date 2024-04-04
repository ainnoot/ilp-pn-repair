"""
Reifies an Examples object into ASP facts.
"""

import clingo

def reify_as_facts(examples):
    facts = []

    stack = [*examples.root.children.values()]
    while stack:
        top = stack.pop()
        node_id = clingo.Number(top.id)
        node_parent_id = clingo.Number(top.parent.id if top.parent is not None else -1)
        node_value = clingo.String(top.value)

        facts.append(clingo.Function('prefix', [node_id, node_parent_id, node_value]))
        if top.is_complete:
            predicate_name = 'pos' if top.label else 'neg'
            facts.append(clingo.Function(predicate_name, [node_id]))

        stack.extend(top.children.values())

    return facts
