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

-- do napisania !! 
procedure Insert_Sort(List : in out Elem_Ptr; D : in Integer) is 
  E: Elem_Ptr := new Element;
  L : access Element := List;
begin
  E.Data := D;
  if (List = null or else List.Data >= D) then
    E.Next := List;
    List := E;
  else
    while (L.Next /= null) loop
      if ( L.Next.Data < D) then
        L:= L.Next;
      else
        exit;
      end if;
    end loop;
    E.Next := L.Next;
    L.Next := E;
  end if;
end Insert_Sort;

procedure Insert_Random(List: in out Elem_Ptr; N,M :in Integer) is
    package rnd is new Ada.Numerics.Discrete_Random(Integer);
    use rnd;
    Gen: Generator;
    Random_number: Integer;
    i: Integer:=0;
begin
    Reset(Gen);
    while i<N loop
      Random_number:= Random(Gen) mod M;
      Insert_Sort(List,Random_number);
      i:=i+1;
    end loop;
end Insert_Random;

function Search(List: in out Elem_Ptr; N: Integer) return Boolean is
    Ptr: Elem_Ptr := List;
begin
    while Ptr /= Null loop
      if Ptr.Data = N then
        return True;
      end if;
      Ptr := Ptr.Next;
    end loop;
    
    return False;
end Search;

procedure Delete(List: in out Elem_Ptr; DelNumb:Integer) is
current: Elem_Ptr := List;
previous: Elem_Ptr := List;
begin
    if current.Data = DelNumb then
      List := current.Next;
    else
      current := current.Next;
      while current /= Null loop
        if current.Data = DelNumb then
          previous.Next := current.Next;
          current:= Null;
          exit;
        else
          previous := current;
          current := current.Next;      
          end if;
      end loop;
    end if;

end Delete;

Lista : Elem_Ptr := Null;
Lista2 : Elem_Ptr := Null;

begin
  Print(Lista);
  Lista := Insert(Lista, 21);
  Print(Lista);
  Insert(Lista, 20); 
  Print(Lista);
  for I in reverse 1..12 loop
  Insert(Lista, I);
  end loop;
  Print(Lista);




  New_Line(3);
  Insert_Random(Lista2,5,20);
  Print(Lista2);
  Put_Line(Search(Lista2,8)'Image);
  Delete(Lista2,8);
  Put_Line(Search(Lista2,8)'Image);
  Print(Lista2);
end Lab4Lista;