# Cose che forse si possono provare

## Capire in cosa è diverso da qua
* DFA da esempi positivi negativi in P 
* probabilmente non abbiamo l'assunzione che L è un "characteristic set" o qualcosa del genere
* `https://cstheory.stackexchange.com/questions/42365/oncina-garcia-rpni-algorithm-for-learning-dfas`
* (survey) `https://arxiv.org/pdf/2209.14031.pdf`
* dataset: `https://github.com/apferscher/ble-learning-passive`
* A logic framework for incremental learning of process models `https://www.researchgate.net/publication/262234805_A_Logic_Framework_for_Incremental_Learning_of_Process_Models`

## Rappresentare log come prefix tree

Rappresentando le tracce con `trace/3` si generano `sum(|pi| for pi in L)` simboli + si sprecano tante valutazioni quando esistono tracce prefissi di altre tracce, perché ogni traccia è un insieme di simboli distinti. Si può provare ad usare un prefix tree così:

```
pi_0 = abc
pi_1 = abd
pi_2 = aefg

         a
        / \
       b   e
      / \   \
     c   d   e 
             | 
             f 
             |
             g

node(0,a).
node(1,b).
node(2,e).
node(4,c).
node(5,d).
node(6,e).
node(7,f).
node(8,g).
child(1,0).
child(2,0).
child(5,1).
child(4,1).
child(6,2).
child(7,6).
child(8,7).
trace(4, pi_0).
trace(5, pi_1).
trace(8, pi_2).
```

In questo modo si risparmiano i simboli per tracce completamente/parzialmente incluse in altre tracce.

Il codice per l'automa si può adattare così (credo/spero):

```
% delta/3
% accepting/1
% state/1
% init/1

root(X) :- node(X), not child(X,_).

state(P, S)  :- init(S), root(P).
state(P', S') :- 
  child(P', P),  % P' è child di P
  state(P,S),    % valutando P, l'automa è nello stato S
  delta(S,A,S'), % passo da S a S' leggendo A
  node(P,A).     % in P c'è il simbolo A

accepts(TID) :- 
  trace(P, TID),  % Il nodo P è la fine della traccia TID
  state(P, S),    % l'automa quando valuta P si trova nello stato S
  accepting(S).   % che è accepting state

rejects(TID) :- 
  trace(_,TID),
  not accepts(TID).
```

Pro: Se aggiungo fatti `node/2`, `child/2` sto popolando un "esempio parziale". Quando aggiungo un `trace/2` sto taggando un branch/prefisso come "traccia completa". Quindi con il prefix tree ragionare su esempi parziali/esempi completi è uguale. Lavorando pulito con ID nodo incrementali, non dovrebbero mai esserci collisioni di fatti e penso si possa fare pulito con il multishot di `clingo`.
Contro: Non so se riesce ad adattare per ILASP?


