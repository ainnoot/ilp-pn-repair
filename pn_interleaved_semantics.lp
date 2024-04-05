% place(ID)
% trans(ID, LABEL)
% ptarc(PID, TID, W)
% tparc(PID, TID, W)
%
% Ricopiati dal paper
% https://arxiv.org/pdf/1306.3542.pdf
%
%
%

% NOTAZIONE: 
% T* --> OUTPUT PLACES PER LA TRANSIZIONE T (PLACE PER CUI ESISTE UN ARCO (T,P))
% *T --> INPUT PLACES PER LA TRANSIZIONE T (PLACE PER CUI ESISTE UN ARCO (P,T))
%

#const k=1.     % LUNGHEZZA DELLA TRACCIA DA GENERARE
#const ntok=10. % NUMERO MASSIMO DI TOKEN IN UN PLACE
time(0..k+1).   % STEP DI SIMULAZIONE
num(0..ntok).   % NUMERO AMMMISSIBILE DI TOKEN IN UN PLACE DURANTE LA SIMULAZIONE

% MARKING INIZIALE: ESATTAMENTE UN TOKEN SU "__source_place__", NESSUNO ALTROVE
% TODO(ANTONIO): QUESTO È MEGLIO SPOSTARLO NELLO SCRIPT DI REIFICAZIONE
holds("__source_place__", 1, 0).
holds(P,0,0) :- place(P), P != "__source_place__".

% ESISTE ALMENO UN PLACE IN *T CHE NON HA
% ABBASTANZA TOKEN PER SPARARE T
notenabled(T,TS) :-
  ptarc(P,T,N), holds(P,Q,TS), Q < N,
  place(P), trans(T,_), time(TS),
  num(N), num(Q).

% TUTTI I PLACE IN *T SODDISFANO I REQUISITI
% PER SPARARE T
enabled(T,TS) :-
  trans(T,_), time(TS), not notenabled(T,TS).

% Spara esattamente una transizione ad ogni istante di tempo
% tra le abilitate
% (interleaved semantics)

% ALL'INIZIO SPARIAMO SEMPRE __source_trans__
% ALLA FINE SPARIAMO SEMPRE __sink_trans__
% TODO(ANTONIO): QUESTO È MEGLIO SPOSTARLO NELLO SCRIPT DI REIFICAZIONE E POI FARE
% fires(T,0) :- source_trans(T).
% fires(T,k) :- sink_trans(T).

fires("__source_trans__", 0).
fires("__sink_trans__", k).

% INTERLEAVED SEMANTICS: ESATTAMENTE UNA TRANSIZIONE PER ISTANTE DI TEMPO
{ fires(T,TS): enabled(T, TS), trans(T, _) } = 1 :- time(TS), TS > 0, TS < k.

% ALL'ULTIMO ISTANTE DI SIMULAZIONE CI DEVE ESSERE UN TOKEN NEL SINK PLACE
:- not holds("__sink_place__", 1, k+1).

% NO TOKEN RESIDUI
:- holds(P,C,k+1), C > 0, place(P), P != "__sink_place__".

% NESSUN TOKEN PUÒ USCIRE DAL SINK PLACE
% QUINDI LÌ I TOKEN SI POSSONO SOLO ACCUMULARE
% --> SE CI FINISCE QUALCOSA PRIMA DELL'ULTIMO STEP DI SIMULAZIONE HO SBAGLIATO TUTTO
% POSSO GIÀ FERMARMI
:- holds("__sink_place__", C, TS), TS <= k, C > 0.

% LA QUANTITÀ DI TOKEN IN UN PLACE P@{t+1} CAMBIA DA P@{t} SE
% SPARO T ALL'ISTANTE {t} E P IN *T (DECREMENTO) o P IN T* (AUMENTO)
affected(P,TS) :- fires(T,TS), ptarc(P,T,_).
affected(P,TS) :- fires(T,TS), tparc(T,P,_).

% SE P NON È AFFECTED DALLA TRANSIZIONE SPARATA, HO GLI STESSI TOKEN DI PRIMA (~ INERTIA)
holds(P,Q,TS+1) :- holds(P,Q,TS), not affected(P,TS), time(TS+1).

% SE P È AFFECTED FACCIO I CONTI COME FA BARAL

% SPARIAMO LA TRANSIZIONE T ALL'ISTANTE TS
% QUINDI I PLACE IN T* GUADAGNANO Q TOKEN
add(P, Q, T, TS) :-
  fires(T,TS), tparc(T,P,Q), time(TS).

% SPARIAMO LA TRANSIZIONE T ALL'ISTANTE TS
% QUINDI I PLACE IN *T PERDONO Q TOKEN
del(P, Q, T, TS) :-
  fires(T,TS), ptarc(P,T,Q), time(TS).

% TOTALE TOKEN GUADAGNATI DA P
tot_incr(P,QQ,TS) :-
  affected(P,TS),
  QQ = #sum{Q,T: add(P,Q,T,TS)},
  time(TS), num(QQ), place(P).

% TOTALE TOKEN PERSI DA P
tot_decr(P,QQ,TS) :-
  affected(P,TS),
  QQ = #sum{Q,T: del(P,Q,T,TS)},
  time(TS), num(QQ), place(P).

% AGGIORNO LO STATO A T+1 FACENDO LA SOMMA DEGLI INCREMENTI E DECREMENTI DI TOKEN
holds(P,Q,TS+1) :-
  affected(P,TS),
  holds(P,Q1,TS), 
  tot_incr(P,Q2,TS),
  time(TS+1),
  tot_decr(P,Q3,TS),
  place(P),
  num(Q), num(Q1), num(Q2), num(Q3),
  Q = Q1 + Q2 - Q3,
  time(TS).

% NESSUNA P PUÒ PERDERE PIÙ TOKEN DI QUANTI NE HA AL MOMENTO
:- holds(P,Q,TS), tot_decr(P,Q1,TS), Q1 > Q.


% NON SPARARE SE QUALCOSA IN *T NON HA ABBASTANZA TOKEN
:- fires(T,TS), holds(P,Q,TS), ptarc(P,T,W), Q < W.

#show.
%#show fires(T,TS): fires(T,TS).
%#show holds(P,Q,T): holds(P,Q,T), Q > 0.

% LE AZIONI LABELLANO LE TRANSIZIONE
% PROIETTO LA FIRING SEQUENCE CHE SODDISFA I CONSTRAINT
% IN UNA TRACCIA PER LEGGIBILITÀ
#show trace(TS,A): fires(T,TS), trans(T,A).
