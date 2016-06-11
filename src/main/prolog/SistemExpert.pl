% Autori: Lungu Daniel si Robert Mitrea Dan



% Incarcarea librariilor necesare
:-use_module(library(lists)).
:-use_module(library(system)).
:-use_module(library(file_systems)).
:-use_module(library(sockets)).


% Definirea operatorului not
:-op(900,fy,not).


% Baza de cunostinte alocata dinamic
:-dynamic fapt/3.
:-dynamic interogat/1.
:-dynamic scop/1.
:-dynamic interogabil/3.
:-dynamic regula/3.
:-dynamic are_solutii/0.


% Specifica faptul ca predicatul citeste_cuvant nu se afla grupa in fisier.
:-discontiguous citeste_cuvant/3.


% Definirea unui operator care intoarce negatul.
not(P):-P,!,fail.
not(_).


inceput:-prolog_flag(argv, [PortSocket|_]), atom_chars(PortSocket,LCifre), number_chars(Port,LCifre),
         socket_client_open(localhost: Port, Stream, [type(text)]), proceseaza_text_primit(Stream,0).


proceseaza_text_primit(Stream,C):- read(Stream,CevaCitit), proceseaza_termen_citit(Stream,CevaCitit,C).


proceseaza_termen_citit(Stream,salut,C):- write(Stream,'salut, bre!\n'), flush_output(Stream), C1 is C+1, proceseaza_text_primit(Stream,C1).
proceseaza_termen_citit(Stream,'ce mai faci?',C):- write(Stream,'ma plictisesc...\n'), flush_output(Stream), C1 is C+1, proceseaza_text_primit(Stream,C1).
proceseaza_termen_citit(Stream, X + Y,C):- Rez is X+Y, write(Stream,Rez),nl(Stream), flush_output(Stream), C1 is C+1, proceseaza_text_primit(Stream,C1).
proceseaza_termen_citit(Stream, X, _):- (X == end_of_file ; X == exit), close(Stream).
proceseaza_termen_citit(Stream, Altceva,C):- write(Stream,'nu inteleg ce vrei sa spui: '),write(Stream,Altceva),nl(Stream), flush_output(Stream),
                                             C1 is C+1, proceseaza_text_primit(Stream,C1).


% scrie_lista(+L)
% Predicatul de mai jos afiseaza lista de elemente L.
scrie_lista([]):-nl.
scrie_lista([H|T]):- write(H), tab(1), scrie_lista(T).


% afiseaza_fapte
% Predicatul de mai jos afiseaza un mesaj inainte ca a afiseze lista de fapte.
afiseaza_fapte:- write('Fapte existente în baza de cunostinte:'), nl,nl, write(' (Atribut,valoare) '), nl,nl, listeaza_fapte,nl.


% listeaza_fapte
% Predicatul de mai jos afiseaza toate faptele din baza de cunostinte.
listeaza_fapte:- fapt(av(Atr,Val),FC,_), write('('),write(Atr),write(','), write(Val), write(')'), write(','), write(' certitudine '),
	             FC1 is integer(FC),write(FC1), nl,fail.
listeaza_fapte.


% lista_float_int(+ L,- L)
% Predicatul de mai jso transforma valorile de float in int.
lista_float_int([],[]).
lista_float_int([Regula|Reguli],[Regula1|Reguli1]):- (Regula \== utiliz, Regula1 is integer(Regula);
                                                      Regula ==utiliz, Regula1=Regula), lista_float_int(Reguli,Reguli1).


% pornire
% Predicatul principal, aceta va fi apelat din consola prima data.
% Predicatul curata baza de cunostinte, asteapta un raspuns de la utilizator, pe care il citeste, apoi il executa.
% Predicatul face acest lucru pana cand se tasteaza optiunea de iesire.
pornire:- retractall(interogat(_)), retractall(fapt(_,_,_)), retractall(are_solutii), repeat, write('Introduceti una din urmatoarele optiuni: '), nl,nl,
	      write(' (Incarca Consulta Reinitiaza  Afisare_fapte  Cum  Sterge  Iesire) '), nl,nl,write('|: '),citeste_linie([H|T]),
	      executa([H|T]), H == iesire.


% executa(+L)
% Predicatul de mai jos executa optiunea primita de la predicatul pornire.
executa([incarca]):- incarca,!,nl, write('Fisierul dorit a fost incarcat'),nl.
executa([consulta]):- scopuri_princ,!.
executa([reinitiaza]):- retractall(interogat(_)), retractall(fapt(_,_,_)), retractall(are_solutii), !.
executa([afisare_fapte]):- afiseaza_fapte,!.
executa([cum|L]):- cum(L),!.
executa([sterge]):- retractall(interogat(_)),retractall(fapt(_,_,_)), retractall(scop(_)),retractall(interogabil(_,_,_)),
                    retractall(are_solutii), retractall(regula(_,_,_)), !.
executa([iesire]):-!.
executa([_|_]):- write('Comanda incorecta! '),nl.


% scopuri_prin.
% Predicatul de mai jos determina si afiseaza scopurile principale.
scopuri_princ:- scop(Atr),determina(Atr), lista_fapte(Atr ,L), bubble_sort(L, [], S), afiseaza_scop(S),fail.
scopuri_princ:- \+ are_solutii, write('Nu exista solutii !'), nl.
scopuri_princ.


% determina(+Atr).
% Predicatul de mai jos determina scopul principal.
determina(Atr):- realizare_scop(av(Atr,_),_,[scop(Atr)]),!.
determina(_).


% bubble_sort(+ List,+ Acc,- Sorted)
% Predicatul de mai jos aplica metoda bubble sort ca sa sorteze o lista de fapte.
bubble_sort([],Acc,Acc).
bubble_sort([H|T],Acc,Sorted):- bubble(H,T,NT,Max),bubble_sort(NT,[Max|Acc],Sorted).


% bubble(+H,+T, -NT, -Max).
% Predicatul de mai jos realizeaza permutarea prin metoda bulelor.
bubble(X,[],[],X).
bubble(el(av(Atr1,Val1),FC1),[el(av(Atr2,Val2),FC2)|T],[el(av(Atr2,Val2),FC2)|NT],Max):-FC1<FC2, bubble(el(av(Atr1,Val1),FC1),T,NT,Max).
bubble(el(av(Atr1,Val1),FC1),[el(av(Atr2,Val2),FC2)|T],[el(av(Atr1,Val1),FC1)|NT],Max):-FC1>=FC2,bubble(el(av(Atr2,Val2),FC2),T,NT,Max).


% afiseaza_scop(+L).
% Predicatul de mai jos afiseaza scopul.
afiseaza_scop([el(av(Atr,Val),FC)|T]):- nl, scrie_scop(av(Atr,Val),FC), assert(are_solutii), nl, afiseaza_scop(T), fail.
afiseaza_scop(_):- nl, nl.


% lista_fapte(+ Atr, - L)
% Predicatul de mai jos intoarce lista de fapte din baza de cunostinte
lista_fapte(Atr ,L):- findall(el(av(Atr,Val),FC), Val^FC^(fapt(av(Atr,Val),FC,_), FC >= 50), L).


% scrie_scop(+ av(Atr,Val), + FC).
% Predicatul de mai jos afiseaza scopul primit.
scrie_scop(av(Atr,Val),FC):- transformare(av(Atr,Val), X), scrie_lista(X),tab(2), write(' '), write('factorul de certitudine este '),
	                         FC1 is integer(FC),write(FC1).


% realizare_scop(+ Scop,- FC,- Istorie).
% Predicatul de mai jos realizeaza scopul principal.
realizare_scop(not Scop,Not_FC,Istorie):- realizare_scop(Scop,FC,Istorie), Not_FC is - FC, !.
realizare_scop(Scop,FC,_):- fapt(Scop,FC,_), !.
realizare_scop(Scop,FC,Istorie):- pot_interoga(Scop,Istorie), !,realizare_scop(Scop,FC,Istorie).
realizare_scop(Scop,FC_curent,Istorie):- fg(Scop,FC_curent,Istorie).


% fg(+ Scop,- FC_curent,- Istorie).
% Predicatul de mai jos determina noul FC.
fg(Scop,FC_curent,Istorie):- regula(N, premise(Lista), concluzie(Scop,FC)), demonstreaza(N,Lista,FC_premise,Istorie), ajusteaza(FC,FC_premise,FC_nou),
	                         actualizeaza(Scop,FC_nou,FC_curent,N), FC_curent == 100,!.
fg(Scop,FC,_):- fapt(Scop,FC,_).


% pot_interoga(+ Av, - Istorie).
% Predicatul de mai jos determina daca se poate interoga.
pot_interoga(av(Atr,_),Istorie):- not interogat(av(Atr,_)), interogabil(Atr,Optiuni,Mesaj), interogheaza(Atr,Mesaj,Optiuni,Istorie),nl,
	                              asserta( interogat(av(Atr,_)) ).


% cum(+L)
% Predicatul de mai jos determina cum s-a ajuns la faptul respectiv.
cum([]):- write('Scop? '),nl, write('|:'),citeste_linie(Linie),nl,transformare(Scop,Linie), cum(Scop).
cum(L):-  transformare(Scop,L),nl, cum(Scop).
cum(not Scop):- fapt(Scop,FC,Reguli), lista_float_int(Reguli,Reguli1), FC < -20,transformare(not Scop,PG),
	            append(PG,[a,fost,derivat,cu, ajutorul, 'regulilor: '|Reguli1],LL), scrie_lista(LL),nl,afis_reguli(Reguli),fail.
cum(Scop):- fapt(Scop,FC,Reguli), lista_float_int(Reguli,Reguli1), FC > 20,transformare(Scop,PG),
	        append(PG,[a,fost,derivat,cu, ajutorul, 'regulilor: '|Reguli1],LL), scrie_lista(LL),nl,afis_reguli(Reguli), fail.
cum(_).


% afis_reguli(+L).
% Predicatul de mai jos afiseaza regulile.
afis_reguli([]).
afis_reguli([N|X]):- afis_regula(N), premisele(N), afis_reguli(X).
afis_regula(N):- regula(N, premise(Lista_premise), concluzie(Scop,FC)),NN is integer(N), scrie_lista(['regula  ',NN]), scrie_lista(['  Daca']),
	             scrie_lista_premise(Lista_premise), scrie_lista(['  Atunci']), transformare(Scop,Scop_tr), append(['   '],Scop_tr,L1),
	             FC1 is integer(FC),append(L1,[FC1],LL), scrie_lista(LL),nl.


% scrie_lista_premise(+L).
% Predicatul de mai jos afiseaza lista de premise.
scrie_lista_premise([]).
scrie_lista_premise([H|T]):- transformare(H,H_tr), tab(5),scrie_lista(H_tr), scrie_lista_premise(T).


% transformare(+ Av, - A)
% Predicatul de mai jos transforma Av in A.
transformare(av(A,da),[A]):- !.
transformare(not av(A,da), [not,A]):- !.
transformare(av(A,nu),[not,A]):- !.
transformare(av(A,V),[A,este,V]).


% premisele(+N).
% Predicatul de mai jos intoarce lista de premise N.
premisele(N):- regula(N, premise(Lista_premise), _), !, cum_premise(Lista_premise).


% cum_premise(+L).
% Predicatul de mai jos demonstreaza lista de premise.
cum_premise([]).
cum_premise([Scop|X]):- cum(Scop), cum_premise(X).


% interogheaza(+ Atr,+ Mesaj,+ Optiuni,+ Istorie).
% Predicatul de mai jos interogheaza userul.
interogheaza(Atr,Mesaj,[da,nu],Istorie):- !,write(Mesaj),nl, de_la_utiliz(X,Istorie,[da,nu]), det_val_fc(X,Val,FC),
	                                      asserta( fapt(av(Atr,Val),FC,[utiliz]) ).
interogheaza(Atr,Mesaj,Optiuni,Istorie):- write(Mesaj),nl, citeste_opt(VLista,Optiuni,Istorie), assert_fapt(Atr,VLista).


% citeste_opt(- X,+ Optiuni,+ Istorie).
% Predicatul de mai jos citeste optiunile existente la o intrebare.
citeste_opt(X,Optiuni,Istorie):- append(['('],Optiuni,Opt1), append(Opt1,[')'],Opt), scrie_lista(Opt), de_la_utiliz(X,Istorie,Optiuni).


% de_la_utiliz(- X,+ Istorie,+ Lista_opt).
% Predicatul de mai jos citeste raspunsul de la utilizator.
de_la_utiliz(X,Istorie,Lista_opt):- repeat,write(': '),citeste_linie(X), proceseaza_raspuns(X,Istorie,Lista_opt).


% proceseaza_raspuns(+L ,+Istorie,+ Lista_opt).
% Predicatul de mai jos proceseaza raspunsul.
proceseaza_raspuns([de_ce],Istorie,_):- nl,afis_istorie(Istorie),!,fail.
proceseaza_raspuns([X],_,Lista_opt):- member(X,Lista_opt).
proceseaza_raspuns([X,fc,FC],_,Lista_opt):- member(X,Lista_opt),float(FC).


% assert_fapt(+ Atr,+ L).
% Predicatul de mai jos insereaza fapt-ul in baza de cunstinte.
assert_fapt(Atr,[Val,fc,FC]):- !,asserta( fapt(av(Atr,Val),FC,[utiliz]) ).
assert_fapt(Atr,[Val]):- asserta( fapt(av(Atr,Val),100,[utiliz])).


% det_val_fc(+ L,+ Val,- FC).
% Predicatul de mai jos determina factorul de certitudine.
det_val_fc([nu],da,-100).
det_val_fc([nu,FC],da,NFC):- NFC is -FC.
det_val_fc([nu,fc,FC],da,NFC):- NFC is -FC.
det_val_fc([Val,FC],Val,FC).
det_val_fc([Val,fc,FC],Val,FC).
det_val_fc([Val],Val,100).


% afis_istorie(+L).
% Predicatul de mai jos afiseaza istoria.
afis_istorie([]):- nl.
afis_istorie([scop(X)|T]):- scrie_lista([scop,X]),!, afis_istorie(T).
afis_istorie([N|T]):- afis_regula(N),!,afis_istorie(T).


% demonstreaza(+ N,- ListaPremise,+ Val_finala,+ Istorie).
% Predicatul de mai jos demonstreaza valoarea final prin intoarcerea listei de premise.
demonstreaza(N,ListaPremise,Val_finala,Istorie):- dem(ListaPremise,100,Val_finala,[N|Istorie]),!.


% dem(- L,+ Val_actuala, + Val_finala,+ Istorie).
% Predicatul de mai jos demonstreza Valoarea finala.
dem([],Val_finala,Val_finala,_).
dem([H|T],Val_actuala,Val_finala,Istorie):- realizare_scop(H,FC,Istorie), Val_interm is min(Val_actuala,FC), Val_interm >= 20,
	                                        dem(T,Val_interm,Val_finala,Istorie).


% actualizeaza(+ Scop,+ FC_nou,+ FC,+ RegulaN).
% Predicatul de mai jos actualizeaza factorul de certitudine.
actualizeaza(Scop,FC_nou,FC,RegulaN):- fapt(Scop,FC_vechi,_), combina(FC_nou,FC_vechi,FC), retract( fapt(Scop,FC_vechi,Reguli_vechi) ),
	                                   asserta( fapt(Scop,FC,[RegulaN | Reguli_vechi]) ),!.
actualizeaza(Scop,FC,FC,RegulaN):- asserta( fapt(Scop,FC,[RegulaN]) ).


% ajusteaza(+ FC1,+ FC2,- FC).
% Predicatul de mai jos ajuseteaza factorul de certitudine.
ajusteaza(FC1,FC2,FC):- X is FC1 * FC2 / 100, FC is round(X).


% combina(+FC1,+FC2,-FC).
% Predicatul de mai jos combina factorii de certitudine F1 cu F2 in FC.
combina(FC1,FC2,FC):- FC1 >= 0,FC2 >= 0, X is FC2*(100 - FC1)/100 + FC1, FC is round(X).
combina(FC1,FC2,FC):- FC1 < 0,FC2 < 0, X is - ( -FC1 -FC2 * (100 + FC1)/100), FC is round(X).
combina(FC1,FC2,FC):- (FC1 < 0; FC2 < 0), (FC1 > 0; FC2 > 0), FCM1 is abs(FC1),FCM2 is abs(FC2), MFC is min(FCM1,FCM2),
	                   X is 100 * (FC1 + FC2) / (100 - MFC), FC is round(X).


% incarca
% Predicatul de mai jos citeste path-ul catre un fisier pe care il va incarca in baza de cunstinte.
incarca:- write('Introduceti numele fisierului care doriti sa fie incarcat: '),nl, write('|:'),read(F), file_exists(F),!,incarca(F).
incarca:- write('Nume incorect de fisier! '),nl,fail.


% incarca(+F).
% Predicatul de mai jos curata baza de cunostinte apoi incarca in baza de conostinte regulile sau intrebarile din fisierul F.
incarca(F):- see(F),incarca_reguli,seen,!.


% incarca_reguli.
% Predicatul de mai jos incarca regulile in baza de cunostinte
incarca_reguli:- repeat,citeste_propozitie(L), proceseaza(L),L == [end_of_file],nl.


% proceseaza(+ L).
% Predicatul de mai jos proceseaza regula L si o incarca in baza de cunostinte procesata prin R.
proceseaza([end_of_file]):-!.
proceseaza(L):- trad(R,L,[]), assertz(R), !.


% trad(-R, + L1, + L2).
% Predicatul de mai jos converteste regulile, intrebarile si scopurile scrise in limbaj natural intr-o forma corespunzatoare pentru baza de cunostinte.
trad(scop(X)) --> [scopul,cautat,e,X].
trad(interogabil(Atr,M,P)) -->  ['#',Atr],lista_optiuni(M),afiseaza(Atr,P).
trad(regula(N,premise(Daca),concluzie(Atunci,F))) --> identificator(N),daca(Daca),atunci(Atunci,F).
trad('Eroare la parsare'-L,L,_).


% lista_optiuni(- M).
% Predicatul de mai jos scoate { din lista de optiuni de la o intrebare.
lista_optiuni(M) --> ['{'],lista_de_optiuni(M).


% lista_de_optiuni(- L).
% Predicatul de mai jos converteste o lista de optiuni de la o intrebare intr-o lista.
lista_de_optiuni([Element]) -->  [Element,'}'].
lista_de_optiuni([Element|T]) --> [Element,','],lista_de_optiuni(T).


% afiseaza(+ Atr,- P).
% Predicatul de mai jos intoarce intrebarea.
afiseaza(_,P) -->  ['#','#','#',P].
afiseaza(P,P) -->  [].


% identificator(- N).
% Predicatul de mai jos intoarce prin N numarul regulii.
identificator(N) --> [regula,nr,N].


% daca(- Daca).
% Predicatul de mai jos scoate cuvintele 'premisele sunt' din lista de premise.
daca(Daca) --> [premisele, sunt],lista_premise(Daca).


% lista_premise(- L)
% Predicatul de mai jos intoarce lista de premise L.
lista_premise([Daca]) --> propoz(Daca),[',',atunci].
lista_premise([Prima|Celalalte]) --> propoz(Prima),[si],lista_premise(Celalalte).
lista_premise([Prima|Celalalte]) --> propoz(Prima),[','],lista_premise(Celalalte).


% atunci(- Atunci,- FC).
% Predicatul de mai jos intoarce concuziile si factorul de certitudine pentru concluzia respectiva.
atunci(Atunci,FC) --> propoz(Atunci),[cu, fc],[FC].
atunci(Atunci,100) --> propoz(Atunci).


% propoz(-A)
% Predicatul de mai jos paraseaza premisele/concluziile scrise in limbaj natural in forma corespunzatoare pentru baza de cunostinte.
propoz(not av(Atr,da)) --> [Atr, nu, este, adevarat].
propoz(av(Atr,Val)) --> [Atr, are, valoarea, Val].
propoz(av(Atr,da)) --> [Atr, este, adevarat].


% citeste_linie(-L).
% Predicatul de mai jos citeste o linie.
citeste_linie([Cuv|Lista_cuv]):- get_code(Car), citeste_cuvant(Car, Cuv, Car1), rest_cuvinte_linie(Car1, Lista_cuv).


% rest_cuvinte_linie(+ Car,- L).
% Predicatul de mai jos determina daca trebuie oprit cititul.
% -1 este codul ASCII pt EOF
rest_cuvinte_linie(-1, []):- !.    
rest_cuvinte_linie(Car,[]):- (Car==13;Car==10), !.
rest_cuvinte_linie(Car,[Cuv1|Lista_cuv]):- citeste_cuvant(Car,Cuv1,Car1),rest_cuvinte_linie(Car1,Lista_cuv).


% citeste_propozitie(-L).
% Predicatul de mai jos citeste o propozitie si o intoarce prin L.
citeste_propozitie([Cuv|Lista_cuv]):- get_code(Car),citeste_cuvant(Car, Cuv, Car1), rest_cuvinte_propozitie(Car1, Lista_cuv).


% rest_cuvinte_propozitie(+Car,-L)
% Predicatul de mai jos returneaza restul cuvintelor din propozitie.
rest_cuvinte_propozitie(-1, []):- !.
rest_cuvinte_propozitie(Car,[]):- Car==46, !.
rest_cuvinte_propozitie(Car,[Cuv1|Lista_cuv]):- citeste_cuvant(Car,Cuv1,Car1), (Cuv1 \== nr, Car2 = Car1; Cuv1 == nr, get_code(Car2)),
                                                rest_cuvinte_propozitie(Car2,Lista_cuv).


% citeste_cuvant(+ Caracter,- Cuvant,- Caracter1)
% Predicatul de mai jos citeste un cuvatn de tip caracter special sau numar.
citeste_cuvant(-1,end_of_file,-1):- !.
citeste_cuvant(Caracter,Cuvant,Caracter1):- caracter_cuvant(Caracter),!, name(Cuvant, [Caracter]),get_code(Caracter1).
citeste_cuvant(Caracter, Numar, Caracter1):- caracter_numar(Caracter),!, citeste_tot_numarul(Caracter, Numar, Caracter1).


% citeste_tot_numarul(+ Caracter,- Numar,- Caracter1).
% Predicatul de mai jos citeste tot numarul din fisier.
citeste_tot_numarul(Caracter,Numar,Caracter1):- determina_lista(Lista1,Caracter1), append([Caracter],Lista1,Lista), transforma_lista_numar(Lista,Numar).


% determina_lista(- Lista,- Caracter1).
% Predicatul de mai jos intoarce o lista formata din numere.
determina_lista(Lista,Caracter1):- get_code(Caracter),(caracter_numar(Caracter), determina_lista(Lista1,Caracter1), append([Caracter],Lista1,Lista);
	                               \+(caracter_numar(Caracter)), Lista=[],Caracter1=Caracter).


% transforma_lista_numar(+ L,- N).
% Predicatul de mai jos transofram lista L in numarul N.
transforma_lista_numar([],0).
transforma_lista_numar([H|T],N):- transforma_lista_numar(T,NN), lungime(T,L), Aux is 10**L, HH is H-48,N is HH*Aux+NN.


% lungime(+ L, - Nr).
% Predicatul de mai jos determina lungimea unei liste ( L ) si il returneaza prin Nr.
lungime([],0).
lungime([_|T],L):- lungime(T,L1), L is L1+1.


% citeste_cuvant(+ Caracter,- Cuvant,- Caracter1).
% Predicatul de mai jos grupeaza o propozite afla intre apostrofe (39 este codul ASCII pt ' ) intr-un singur cuvant.
citeste_cuvant(Caracter,Cuvant,Caracter1):- Caracter==39,!, pana_la_urmatorul_apostrof(Lista_caractere),
	                                        L=[Caracter|Lista_caractere], name(Cuvant, L),get_code(Caracter1).


% pana_la_urmatorul_apostrof(- Lista_caractere)
% Predicatul de mai jos intoarce toata propozitia pana la urmatorul apostrofe
pana_la_urmatorul_apostrof(Lista_caractere):- get_code(Caracter), (Caracter == 39,Lista_caractere=[Caracter];
	                                          Caracter\==39, pana_la_urmatorul_apostrof(Lista_caractere1), Lista_caractere=[Caracter|Lista_caractere1]).


% citeste_cuvant(+ Caracter,- Cuvant,- Caracter1)
% Predicatul de mai jos citste un cuvant. Prima data verifica daca caracterul este litera mare sau mica, numar sau caracterele - _
% daca este litera mare il converteste in litera mica.
citeste_cuvant(Caracter,Cuvant,Caracter1):- caractere_in_interiorul_unui_cuvant(Caracter),!,  ((Caracter>64,Caracter<91),!,
	                                        Caracter_modificat is Caracter+32;
	                                        Caracter_modificat is Caracter), citeste_intreg_cuvantul(Caractere,Caracter1),
	                                        name(Cuvant,[Caracter_modificat|Caractere]).


% citeste_intreg_cuvantul(- Lista_Caractere,- Caracter1).
% Predicatul de mai jos intoarce tot cuvantal printr-o lista.
citeste_intreg_cuvantul(Lista_Caractere,Caracter1):- get_code(Caracter), (caractere_in_interiorul_unui_cuvant(Caracter),
	                                                 ((Caracter>64,Caracter<91),!, Caracter_modificat is Caracter+32; Caracter_modificat is Caracter),
	                                                 citeste_intreg_cuvantul(Lista_Caractere1, Caracter1),
	                                                 Lista_Caractere=[Caracter_modificat|Lista_Caractere1];
	                                                 \+(caractere_in_interiorul_unui_cuvant(Caracter)), Lista_Caractere=[], Caracter1=Caracter).


% citeste_cuvant(+ Caracter,- Cuvant,- Caracter1).
% Predicatul de mai jos citeste un cuvant indiferent de caracterul primit.
citeste_cuvant(_,Cuvant,Caracter1):-  get_code(Caracter), citeste_cuvant(Caracter,Cuvant,Caracter1).


% caracter_cuvant(+ C).
% Predicatul de mai jos verifica daca C este un caracter special.
% Am specificat codurile ASCII pentru , ; : ? ! . ) (  # { }
caracter_cuvant(C):-member(C,[44,59,58,63,33,46,41,40,35,123,125]).


% caractere_in_interiorul_unui_cuvant(+ C)
% Predicatul de mai jos verifica daca C este o litera mare sau mica, un numar sau caracterele - sau _
caractere_in_interiorul_unui_cuvant(C):- C>64,C<91;C>47,C<58; C==45;C==95;C>96,C<123.

% caracter_numar(+ C).
% Predicatul de mai jos verifica daca C este sau nu un numar.
caracter_numar(C):-C<58,C>=48.


% tab(+ N).
% Predicatul de mai jos scire N spatii pe ecran
tab(N):-N>0, N1 is N-1, write(' '), tab(N1).
tab(0).