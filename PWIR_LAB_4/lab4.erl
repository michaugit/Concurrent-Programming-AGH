-module(lab4).
-import(math,[sqrt/1,pi/0]).
-import(lists,[nth/2]).
-compile(export_all). 

% Michał Pieniądz 306486

% ======= FIGURY =======
%obiczanie pola kwadratu chyba nie potrzeba komentarza
pole({kwadrat,X,Y}) ->  X*Y;
%obiczanie pola koła chyba też nie potrzeba komentarza
pole({kolo,R}) -> 3.14*R*R;
%obiczanie pola stożka chyba też nie potrzeba komentarza
pole({stozek,R,H}) -> pi()*R*R + (pi()*R*sqrt(R*R+H*H)).


% ======== LISTY ========

%zwraca największy element listy
amax([H]) -> H;
amax([H|T]) -> case H > amax(T) of  %sprawdzamy czy głowa jest większa od maxa z ogona jeśli tak to zwracamy ową głowę jeśli nie zwracamy amax od ogona który rekurenycjnie zwróci największą wartość z ogona
                true -> H;
                false -> amax(T)
            end.




amin([H]) -> H;
amin([H|T]) -> case H < amin(T) of %podobnie jak w amax sprawdzamy czy głowa jest mniejsza od min z ogona jeśli tak to zwracamy ową głowę jeśli nie, zwracamy amin od ogona który rekurenycjnie zwróci najmniejszą wartość z ogona
                true -> H;
                false -> amin(T)
            end.



tmin_max(L) -> {amin(L),amax(L)}. %po prostu zwracamy krotke korzystajac z amin i amax




generuj_liste(0) -> [];                         %gdy N=0 zwracamy pustą liste
generuj_liste(N) -> [N] ++ generuj_liste(N-1).  % dodajemy do listy wartość z konkretnej iteracji 




odwroc(List) ->         %tworzymy pustą liste do której będziemy wkaładać elementy tzw akumulator
    odwroc(List, []). 
odwroc([H|T], Rev) ->   %rekruencyjnie pierwszy element dokładamy do akumulatora dzieki czemu pierwszy element staje się ostatnim
    odwroc(T, [H|Rev]); 
odwroc([], Rev) ->      %kiedy odwracana lista staje się pusta zwracamy akumulator
    Rev.




podziel(X) -> podziel(X,[[],[]]).   %funkcja startowa "przygotowujaca" algorytm dodając listę dwóch pustych list do dalszej obróbki
podziel([],List) -> List;           % gdy dzielona lista jest już pusta zwracamy gotową listę list
podziel([A,B|T],[[],[]]) ->         % przypadek kiedy akumulator jest pusty  bierzemy dwa elementy i odpowiednio wkładamy do listy list
    List3 = [A],
    List4 = [B],
    podziel(T,[List3,List4]);
podziel([X],[List1,List2]) ->       % przypadek gdy lista od której zabieramy elementy ma jeden element, wtedy dodajemy tylko do pierwszej listy list
    List3 = List1 ++ [X],
    podziel([],[List3,List2]);
podziel([A,B|T],[List1,List2]) ->   %główny przypadek tzn zabieramy z listy dwa elementy dokładamy je odpowiednio do list1 i list2 i wykonujemy rekruencję na ogonie listy T.
    List3 = List1 ++ [A],
    List4 = List2 ++ [B],
    podziel(T,[List3,List4]).



scal([],A) -> A;           %scalenie listy gdy jedna z scalanych list jest pusta zwracamy drugą.
scal(A,[]) -> A;           % analogiczny przypadek w drugą stronę
scal([Ha|Ta],[Hb|Tb]) ->   % rozbieramy listy, bierzemy po pierwszym elemencie z list a i b
	if
		Ha<Hb -> [Ha]++scal(Ta,[Hb|Tb]);    % sprawdzamy czy Ha < Hb jeśli tak to ona wygrywa i scalamy to z resztą listy A i CAŁOŚCIĄ listy B (bo wybraliśmy tylko element A)
		true -> [Hb]++scal([Ha|Ta],Tb)      % analogicznie jak wyżej tylko że dla Hb
	end.



dodaj_do_listy([],Element) -> [Element];    %przypadek gdy dodajemy do listy pustej - wtedy zwracamy listę tylko z tego elementu
dodaj_do_listy([H|T],Element) ->            %porównujemy H jest > Element jeśli tak to wsadzamy przed ten H element 
    if H > Element -> 
        [Element]++[H|T];
    true->
       [H]++dodaj_do_listy(T,Element)       %jeśli nie to idziemy dalej szukajac elementu większego od wkładanego elementu
    end.




dodaj_listy([]) -> [];                      %jeśli lista pusta zwracamy pustą
dodaj_listy([List]) -> List;                %jeśli lista składa sie z jednej listy zwracamy jedna liste
dodaj_listy([List|T]) ->                    % bierzemy pojedyncza liste i konkatenujemy z listą stworzonej rekurencyjnie z pozostałych list.
    List ++ dodaj_listy(T).


