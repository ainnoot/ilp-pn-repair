from typing import Generator, Dict, Optional, Sequence
from dataclasses import dataclass

import clingo

from dfa_repair.exceptions import ExampleAlreadyExists, ExampleHasTwoLabels


@dataclass(frozen=True)
class Example:
	word: Sequence[str]
	label: bool

class Node:
	def __init__(self, id: int, value: str, parent: Optional['Node']):
		self.id: int = id
		self.value: str = value
		self.parent: Optional[Node] = parent
		self.children: Dict[str, Node] = dict()
		self.label = None

	@property
	def is_complete(self):
		return self.label is not None

class Examples:
	def __init__(self):
		self.root: Node = Node(0, '', None)
		self.i = 1

	def add(self, ex: Example) -> Node:
		cur = self.root
		for e in ex.word:
			if e in cur.children:
				cur = cur.children[e]

			else:
				node = Node(self.i, e, cur)
				self.i += 1
				cur.children[e] = node
				cur = node

		if cur.is_complete and cur.label is not ex.label:
			raise ExampleHasTwoLabels()

		cur.label = ex.label
		return cur

	def __iter__(self):
		stack = [(self.root, tuple())]
		while len(stack) > 0:
			top, seq = stack.pop()
			if top.is_complete:
				yield Example(seq, top.label)

			for value, node in top.children.items():
				stack.append((node, (*seq, value)))

	def reify(self):
		facts = []

		stack = [*self.root.children.values()]
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


if __name__ == '__main__':
	pt = Examples()
	pt.add(Example(('a', 'b', 'a', 'b', 'a'), False))
	pt.add(Example(('a', 'b', 'a'), False))
	pt.add(Example(('a', 'b', 'a', 'b'), True))
	pt.add(Example(('a', 'a', 'b'), True))

	for f in pt.reify():
		print("{}.".format(f))