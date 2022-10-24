/* Kohlkopf, Schaf, Wolf Problem

Bauer möchte mit k,s und w den Fluss überqueren, kann aber immer nur eine Entität mit sich führen.

Das Prädikat zustand/4 gibt an, wo sie die Entitäten {b-Bauer, k-Kohlkopf, s-Schaf, w-Wolf} befinden.
Die Position wird durch l-links r-rechts angegeben, wobei das linke Ufer das Startufer und das Recht das Zielufer ist.
*/
% zustand/4 :- zustand(Bauer,Kohl,Schaf,Wolf).
% start: zustand(l,l,l,l).
% ziel : zustand(r,r,r,r).
opp(l,r).
opp(r,l).


% Unzulässige Ufer-Konstellationen:
% Schaf+Kohl allein - schaf frisst kohl.
unsicher( zustand(l,r,r,_) ).
unsicher( zustand(r,l,l,_) ).
% Wolf+Schaf allein - wolf frisst schaf.
unsicher( zustand(l,_,r,r) ).
unsicher( zustand(r,_,l,l) ).


% Zustandsänderungen
% bewege/2 :- bewege(Vorher,Nachher).

% Bauer bewegt sicht alleine
bewege(zustand(B1,K,S,W),zustand(B2,K,S,W)) :-
    opp(B1,B2),
    \+ unsicher(zustand(B2,K,S,W)).

% Bauer und Kohl
bewege(zustand(B1,K1,S,W),zustand(B2,K2,S,W)) :-
    B1=K1,
    opp(B1,B2),
    opp(K1,K2),
    \+ unsicher(zustand(B2,K2,S,W)).

% Bauer und Schaf
bewege(zustand(B1,K,S1,W),zustand(B2,K,S2,W)) :-
    B1=S1,
    opp(B1,B2),
    opp(S1,S2),
    \+ unsicher(zustand(B2,K,S2,W)).

% Bauer und Wolf
bewege(zustand(B1,K,S,W1),zustand(B2,K,S,W2)) :-
    B1=W1,
    opp(B1,B2),
    opp(W1,W2),
    \+ unsicher(zustand(B2,K,S,W2)).


% Invertierung der Liste durch Akkumulation
accRev([H|T],A,R) :- accRev(T,[H|A],R).
accRev([],A,A).
revList(L,R):- accRev(L,[],R).

% Ausgabe des Wegs
printWeg([]).
printWeg([H|T]) :-
    format(" -> ~q",H),
    printWeg(T).


findeWeg(Ziel, Ziel, Weg):-
    length(Weg,X),
    format("~nWeg der Länge ~d gefunden.~2n",X),
    revList(Weg,RevWeg),
    printWeg(RevWeg).

findeWeg(Zustand, Ziel, Weg):-
    bewege(Zustand,Folgezustand),                       % generiere neuen erlaubten Zustand
    \+ member(Folgezustand, Weg),                       % Zustand wurde noch nicht besucht
    findeWeg(Folgezustand,Ziel, [Folgezustand|Weg]).    % Logging und Rekursion


findeWeg(Start,Ziel):-
    findeWeg(Start, Ziel, [Start]).


test:-
    findeWeg(zustand(l,l,l,l),zustand(r,r,r,r)).
