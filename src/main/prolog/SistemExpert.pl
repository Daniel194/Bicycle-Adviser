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
