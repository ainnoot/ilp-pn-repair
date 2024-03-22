"""
Encodes a set of positive and negative examples as a prefix tree.
"""

from enum import Enum, auto
from typing import Generator, Dict, Optional, Sequence
from dataclasses import dataclass
import clingo
from dfa_repair.exceptions import ExampleHasTwoLabels
import json

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
	@staticmethod
	def from_json(path):
		with open(path, 'r') as f:
			data = json.load(f)

		ex = Examples()
		for example in data['positive']:
			ex.add(Example(example, True))

		for example in data['negative']:
			ex.add(Example(example, False))

		return ex

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