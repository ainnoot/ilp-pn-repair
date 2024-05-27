final_marking(n10,1).
initial_marking(n1,1).
original(label(ac)).
original(label(as)).
original(label(at)).
original(label(bi)).
original(label(bo)).
original(label(cb)).
original(label(ck)).
original(label(ep)).
original(place(n1)).
original(place(n10)).
original(place(n11)).
original(place(n2)).
original(place(n3)).
original(place(n4)).
original(place(n5)).
original(place(n6)).
original(place(n7)).
original(place(n8)).
original(place(n9)).
original(ptarc(n2,n13,1)).
original(tparc(n15,n3,1)).
original(tparc(n16,n10,1)).
original(tparc(n17,n5,1)).
original(trans(n12,bi)).
original(trans(n13,bo)).
original(trans(n14,as)).
original(trans(n15,cb)).
original(trans(n16,ck)).
original(trans(n17,ep)).
original(trans(n18,ac)).
original(trans(n19,at)).

frozen(X) :- original(place(X)).
frozen(X) :- original(trans(X,_)).