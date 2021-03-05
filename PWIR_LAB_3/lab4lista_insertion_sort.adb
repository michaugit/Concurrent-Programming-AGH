with Ada.Text_IO, Ada.Integer_Text_IO, Ada.Numerics.Discrete_Random;
use Ada.Text_IO, Ada.Integer_Text_IO;

procedure Lab4Lista is

type Element is
  record 
    Data : Integer := 0;
    Next : access Element := Null;
  end record; 

type Elem_Ptr is access all Element;

procedure Print(List : access Element) is
  L : access Element := List;
begin
  if List = Null then
    Put_Line("List EMPTY!");
  else
    Put_Line("List:"); 
  end if; 
  while L /= Null loop
    Put(L.Data, 4); -- z pakietu Ada.Integer_Text_IO
    New_Line;
    L := L.Next;
  end loop; 
end Print;

procedure Insert(List : in out Elem_Ptr; D : in Integer) is
  E : Elem_Ptr := new Element; 
begin
  E.Data := D;
  E.Next := List;
  -- lub E.all := (D, List);
  List := E;
end Insert;

-- wstawianie jako funkcja - wersja krótka
function Insert(List : access Element; D : in Integer) return access Element is 
  ( new Element'(D,List) ); 



  procedure Insert_Random(List: in out Elem_Ptr; N :in Integer) is
      package rnd is new Ada.Numerics.Discrete_Random(Integer);
      use rnd; --użycie pakietu
      Gen: Generator; --zadeklarowanie generatora
      Random_number: Integer; --zmienna przechowująca wylosowaną liczby
      i: Integer:=0; -- zmienna pomocnicza do iteracji
  begin
      Reset(Gen); -- reset generatora liczb losowych
      while i<N loop
          Random_number:= (Random(Gen) mod 100) + 1; --losowanie liczby, %100 daje liczby od 0-99 dodając 1 otrzymujemy zakres od 1-100
          Insert(List,Random_number);   -- wstawienie liczby do Listy
          i:=i+1; -- inkrementacja pętli
      end loop;
  end Insert_Random;

  procedure Insertion_Sort(List : in out Elem_Ptr) is
      loop_element: Elem_Ptr := List; -- pomocniczy wskaźnik do listy wykrzystywanej w pętlach
      current: Elem_Ptr := List.Next;  -- wskaźnik na obecnie przetwarzany element
      previous: Elem_Ptr := List;  -- wskaźnik na poprzednio przetwarzany element
  begin
      -- warunek zabezpieczający przed przetwarzaniem listy która ma 0 lub 1 element
      if loop_element = null or  else loop_element.Next = null then
          return;
      end if;
      
      while current /= null loop  -- iteracja po elementach   
          -- jeśli element względem poprzednika jest okey to przejście do następnego
          if previous.Data <= current.Data then
              previous := previous.Next;
          else
              -- sprawdzenie warunku "bazowego" tak aby potem móc wejść do pętli i przeglądać następne elementy (patrzeć w przód)
              if List.Data > current.Data then
                previous.Next := current.Next;
                current.Next := List;
                List := current;
            -- szukanie w pętli miejsca gdzie trzeba wstawić element
              else
                  loop_element := List;
                  while loop_element.Next /= null and then loop_element.Next.Data < current.Data loop
                     loop_element := loop_element.Next;
                  end loop;
               -- zamiana odpowiednich wskaźników
                  previous.Next := current.Next;
                  current.Next := loop_element.Next;
                  loop_element.Next := current;
              end if;
          end if;

            -- kolejne iteracje...
          current := previous.Next;  
      end loop;
      
   end Insertion_Sort;



Lista : Elem_Ptr := Null;
Lista2 : Elem_Ptr := Null;

begin

  Insert_Random(Lista, 10 );
  Print(Lista);
  Insertion_Sort(Lista);
  Print(Lista);

end Lab4Lista;