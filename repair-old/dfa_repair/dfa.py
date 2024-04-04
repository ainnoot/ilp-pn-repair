from collections import defaultdict

# TODO: usare Pythomata per DFA, tenere solo DFAReplayer
# TODO: Warning, error vari per simboli che non esistono e altre cose del genere

class DFA:
    def __init__(self):
        self._transitions = defaultdict(lambda: dict(), dict())
        self._start = None
        self._accepting = set()

    @property
    def transitions(self):
        for src_state, symbol_dst in self._transitions.items():
            for symbol, dst_state in symbol_dst.items():
                yield src_state, symbol, dst_state

    @property
    def starting_state(self):
        return self._start

    @property
    def accepting_states(self):
        return self._accepting

    def set_start_state(self, state):
        self._start = state

    def set_accepting(self, state, value):
        if value:
            self._accepting.add(state)
        else:
            self._accepting.remove(state)

    def add_transition(self, src_state, symbol, dst_state):
        self._transitions[src_state][symbol] = dst_state

class DFAReplay:
    def __init__(self, dfa):
        self.dfa = dfa
        self.current_state = None
        self.current_prefix = None
        self.reset()

    def reset(self):
        self.current_state = self.dfa.starting_state
        self.current_prefix = []

    def step(self, symbol):
        self.current_prefix.append(symbol)
        self.current_state = self.dfa._transitions[self.current_state][symbol]

    def step_prefix(self, prefix):
        for symbol in prefix:
            self.step(symbol)

    def is_accepting(self):
        return self.current_state in self.dfa.accepting_states


def reify_dfa(dfa: DFA):
    import clingo
    prg = []
    for src, sym, dst in dfa.transitions:
        prg.append(clingo.Function('delta', [
            clingo.Number(src),
            clingo.String(sym),
            clingo.Number(dst)
        ]))

    prg.append(clingo.Function('start', [clingo.Number(dfa.starting_state)]))

    for acc in dfa.accepting_states:
        prg.append(clingo.Function('accepting', [clingo.Number(acc)]))

    return prg