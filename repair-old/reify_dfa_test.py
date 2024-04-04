from dfa_repair.dfa import reify_dfa, DFA, DFAReplay

# TODO: Usare Pythomata per il DFA

if __name__ == '__main__':
    dfa = DFA()
    dfa.add_transition(0, 'a', 1)
    dfa.add_transition(0, 'b', 0)
    dfa.add_transition(1, 'b', 0)
    dfa.add_transition(1, 'a', 1)
    dfa.set_accepting(0, True)
    dfa.set_start_state(0)

    for f in reify_dfa(dfa):
        print(f)

    replayer = DFAReplay(dfa)
    ws = [('abababaaaa', False), ('ababab', True), ('b', True)]

    for (w, expected) in ws:
        replayer.reset()
        replayer.step_prefix(w)
        assert expected is replayer.is_accepting()

