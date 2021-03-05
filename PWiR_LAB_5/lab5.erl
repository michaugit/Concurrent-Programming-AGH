-module(lab5).
-compile([export_all]).




% wstawianie elementu do drzewa
empty() -> {node, 'nill'}. %inicjalizacja pustego drzewa

insert(Key, Value, {node, 'nill'}) -> % wstawieanie do "pustego drzewa"
    {node, {Key, Value, {node, 'nill'}, {node, 'nill'}}};
    
insert(NewKey, NewValue, {node, {Key, Value, Left, Right}}) -> if   %wstawianie do drzewa które zawiera juz node'y
                NewKey == Key -> {node, {NewKey, NewValue, Left, Right}};
                NewKey < Key -> {node, {Key, Value, insert(NewKey, NewValue, Left), Right}};
                NewKey > Key -> {node, {Key, Value, Left, insert(NewKey, NewValue, Right)}}
            end.
  

% generacja drzewa z listy
treeFromList([], Tree) -> Tree; %jeśli lista jest pusta zwracaym gotowe tree
treeFromList([{Key, Value}|T], Tree) -> %jeśli lista zawiera elementy odcinamy po jednym i wstawiamy do drzewa
    treeFromList(T, insert(Key, Value, Tree)).



% generacja losowego drzewa (liczby)
generateRandomTree(Low,Max,N) ->        
    case N > 0 of
        true -> Tree = generateRandomTree(Low,Max,N-1), %generujemy  drzewo aby utworzyć drzewo o N wartościach
                insert((rand:uniform((Max-Low)+ 1)+ (Low - 1)),(rand:uniform((Max-Low)+ 1)+ (Low - 1)),Tree); %losujemy dwie liczby Key i Valu z tego samego zakresu i wstawiamy do drzewa
        false -> empty()
    end.
        


     % zwinięcie drzewa do listy 
treeToListLVR({node,'nill'}) -> []; %jak drzewo puste to zwracamy pustą liste
treeToListLVR({node,{Key, Value,Left,Right}}) -> treeToListLVR(Left)++[{Key, Value}]++treeToListLVR(Right). %najpierw tworzymy liste z lewego poddrzewa  + środek + lista z prawego poddrzewa


%szukanie w drzewie względem Klucza
treeSearchKey(Key, Tree) -> %funkcja startowa
    try treeSearchKey2(Key, Tree) of
        false -> false
    catch
        true -> true
    end.
 
treeSearchKey2(_, {node, 'nill'}) -> false;
treeSearchKey2(Key, {node, {Key,_, _, _}}) -> throw(true);  %jeśli aktualny node posiada ten klucz który szuakmy to zwracamy True
treeSearchKey2(Key, {node, {Tkey, _, Left, Right}}) -> case Key > Tkey of   %jeśli szukamy po kluczu możemy zdecydować czy isć w prawo czy w lewo
    true -> treeSearchKey2(Key, Right);
    false -> treeSearchKey2(Key, Left)
end.

%szukanie w drzewie względem wartości
treeSearchValue(Value, Tree) -> %funkcja startowa
    try treeSearchValue2(Value, Tree) of
        false -> false
    catch
        true -> true
    end.
 
treeSearchValue2(_, {node, 'nill'}) -> false;
treeSearchValue2(Value, {node, {_, Value, _, _}}) -> throw(true);   %jeśli aktualny node posiada tą wartość którą szuakmy to zwracamy True
treeSearchValue2(Value, {node, {_, _, Left, Right}}) -> %jeśli szukamy wartości to nie wiemy gdzie ona jest wiec szukamy i w lewym poddrzewie w prawym
    treeSearchValue2(Value, Right),
    treeSearchValue2(Value, Left).



