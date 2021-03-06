with Ada.Text_IO, Ada.Numerics.Float_Random;
use Ada.Text_IO, Ada.Numerics.Float_Random;

package body opcje_wektora is
   
   -- losowanie elementow 
   procedure Zapelnij(Tab : in out Wektor) is
      Gen : Generator;
   begin
      Reset(Gen);
      for Element of Tab loop
         Element := Random(Gen);
      end loop;
   end Zapelnij;

   -- wypisanie tablicy
   procedure Wypisz(Tab : Wektor) is
   begin
      for  Iter in Tab'Range loop
         Put_Line("Tab(" & Iter'Img & " ) = " & Tab(Iter)'Img);
      end loop;
   end Wypisz;

   -- sprawdzanie czy posortowane
   function Sprawdz(Tab : Wektor) return Boolean is
   begin
      return (for all Iter in Tab'First..(Tab'Last-1) => Tab(Iter+1)>=Tab(Iter));
   end Sprawdz;
   
   --sortowanie bubblesort
   procedure Sortuj(Tab : in out Wektor) is
      Tmp: Float := 0.0;
   begin
      for I in Tab'First..(Tab'Last-1) loop
         for J in (I+1)..Tab'Last loop
            if Tab(J) < Tab(I) then
               Tmp := Tab(I);
               Tab(I) := Tab(J);
               Tab(J) := Tmp;
            end if;    
         end loop;
      end loop;
   end Sortuj;
   
   
end opcje_wektora;