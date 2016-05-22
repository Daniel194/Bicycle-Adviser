% Autori: Lungu Daniel si Robert Mitrea Dan - Grupa 351

% Bibliotecile utilizate de program.
:-use_module(library(lists)).
:-use_module(library(system)).


% Definirea operatorului not
:-op(900, fy, not).


% Baza de cunostinte alocata dinamic
:-dynamic fapt/3.
:-dynamic interogat/1.
:-dynamic scop/1.
:-dynamic interogabil/3.
:-dynamic regula/3.


% ??????????????????
not(P):- P, !, fail.
not(_).


% scrie_lista(+L).
% Predicatul afiseaza lista L pe ecran.
scrie_lista([]):-nl.
scrie_lista([H|T]):-write(H), write('   '), scrie_lista(T).


% afiseaza_fapte
% Predicatul de mai jos afiseaza o informatie de cum sunt stocate faptele in baza de cunostinte, apoi listeaza faptele.
afiseaza_fapte:- write('Faptele existente in baza de cunostinte:'), nl, nl,
                 write('     (Atribut, Valoare)      '), nl, nl, listeaza_faptele, nl.


% listeaza_faptele
% Predicatul de mai jos listeaza faptele din baza de cunostinte.
listeaza_faptele:- fapt(av(Atr, Val), FC, _), write('   (  '), write(Atr), write(' ,   '), write(Val), write(' )   '),
                                            , write('   ,   '), write(' certitudine '), FC1 is integer(FC), write(FC1), nl, fail.
listeaza_faptele.


% lista_float_int
% ???????????????
lista_float_int([], []).
lista_float_int([Regula|Reguli], [Regula1|Reguli1]):- (Regula \== utiliz, Regula1 is integer(Regula);
                                                       Regula == utiliz, Regula1=Regula),
                                                       lista_float_int(Reguli, Reguli1).


% pronire
% Predicatul principal, acesta va fi predicatul apelat in consola !
pronire:- retractall(interogat(_)), retractall(fapt(_,_,_)),
          repeat, write('   Introduceti una din urmatoarele optiuni :'),
          nl, nl, write('   (Incarca Consulta Reinitiaza Afiseaza_fapte Cum Iesire)  '),
          nl, nl, write('|: '), citeste_line([H|T]), executa([H|T]), H == iesire.


% executa(+X)
% Predicatul care stabileste ce sa se execute dupa apelarea predicatului pornire.
executa([incarca]):- incarca, !, nl, write('    Fisierul dorit a fost incarcat  '), nl.
executa([consulta]):- scopuri_princ, !.
executa([afisare_fapte]):- afiseaza_fapte,!.
executa([cum|L]):- cum(L),!.
executa([iesire]):- !.
executa([_|_]): write(' Comanda incorecta ! '), nl.


% scopuri_princ
% ?????????????
scopuri_princ:- scop(Atr), determinant(Atr), afiseaza_scop(Atr), fail.
scopuri_princ.


% determina(+Atr)
% ??????????????
determina(Atr):- relizare_scop(av(Atr,_),_,[scop(Atr)]),!.
determina(_).


% afiseaza_scop(+Atr)
% ???????????????????
afiseaza_scop(Atr):-nl, fapt(av(Atr,Val), FC,_), FC >= 20, scrie_scop(av(Atr, Val), FC), nl, fail.
afiseaza_scop(_):- nl, nl.

% scire_scop
% ??????????
scire_scop(av(Atr, Val), FC):- transformare(av(Atr, Val), X), scrie_lista(X), write('       '), write('  facotrul de certitudine ete '),
                                FC1 is integer(FC), write(FC1).


% realizare_scop
% ??????????????
realizare_scop(not Scop, Not_FC, Istorie):- realizeaza_scop(Scop, FC, Istorie), Not_FC is -FC, !.
realizare_scop(Scop, FC, _):- fapt(Scop, FC, _), !.
realizare_scop(Scop, FC, Istorie):- pot_interoga(Scop, Istorie), !, realizeaza_scop(Scop, FC, Istorie).
realizare_scop(Scop, FC_curent, Istorie):- fg(Scop, FC_curent, Istorie).


% fg
% ????????????????
fg(Scop, FC_curent, Istorie):- regula(N, premise(Lista), concluzie(Scop, FC)), demonstreaza(N, Lista, FC_premise, Istorie),
                               ajusteaza(FC, FC_premise, FC_nou),actualizeaza(Scop, FC_nou, FC_curent, N), FC_curent == 100, !.
fg(Scop, FC, _):- fapt(Scop, FC, _).


% pot_interoga
% ????????????
pot_interoga(av(Atr, _), Istorie):-not interogat(av(Atr,_)), interogabil(Atr, Optiuni, Mesaj),interogheaza(Atr, Mesaj, Optiuni, Istorie), nl,
                                   asserta(interogat(av(Atr, _))).

% cum
% ?????
cum([]):- write('Scop ?'), nl, write('|:'), citeste_line(Linie), nl, transformare(Scop, Linie), cum(Scop).
cum(L):- transformare(Scop, L), nl, cum(Scop).
cum(not Scop):- fapt(Scop, FC, Reguli), lista_float_int(Reguli, Reguli1), FC < -20, transformare(not Scop, PG),
                append(PG, [a,fost,derivat,cu,ajutorul,'regulilor:'|Reguli1],LL), scrie_lista(LL), nl, afiseaza_reguli(Reguli), fail.
cum(Scop):- fapt(Scop, FC, Reguli), lista_float_int(Reguli, Reguli1), FC > 20, transformare(not Scop, PG),
            append(PG, [a,fost,derivat,cu,ajutorul,'regulilor:'|Reguli1],LL), scrie_lista(LL), nl, afiseaza_reguli(Reguli), fail.
cum(_).


% afis_reguli
% ???????????
afis_reguli([]).
afis_reguli([N|X]): afis_regula(N), premisele(N), afis_reguli(X).

% afis_regula
% ???????????
afis_regula(N):- regula(N, premise(Lista_premise), concluzie(Scop, FC)), NN is integer(N), scrie_lista(['regula     ', NN]),
                 scrie_lista([' Daca']), scrie_lista_premise(Lista_premise), scrie_lista(Lista_premise), scrie_lista([' Atunci  ']),
                 transformare(Scop, Scop_tr), append(['     '], Scop_tr, L1), FC1 is integer(FC), append(L1,[FC1], LL),
                 scrie_lista(LL), nl.


% scrie_lista_premise
% ???????????????????
scrie_lista_premise([]).
scrie_lista_premise([H|T]):- transformare(H,H_tr), write('          '), scrie_lista(H_tr), scrie_lista_premise(T).

% transformare
% ????????????
transformare(av(A,da), [A]):- !.
transformare(not av(A, da), [not, A]):- !.
transformare(av(A,nu), [not, A]):- !.
transformare(av(A,V), [A, este, V]).


% premise
% ???????
premise(N):- regula(N, premise(Lista_premise), _), !, cum_premise(Lista_premise).