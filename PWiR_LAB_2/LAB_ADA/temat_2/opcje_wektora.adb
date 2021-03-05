with Ada.Text_IO, Ada.Numerics.Float_Random, Ada.Sequential_IO, Ada.Direct_IO;
use Ada.Text_IO, Ada.Numerics.Float_Random;

package body opcje_wektora is
   
   procedure Zapelnij(Tab : in out Wektor) is
      Gen : Generator;
   begin
      Reset(Gen);
      -- losowanie elementow 
      for Element of Tab loop
         Element := Random(Gen);
      end loop;
   end Zapelnij;

   procedure Wypisz(Tab : Wektor) is
   begin
      -- wypisanie tablicy
      for  Iter in Tab'Range loop
         Put_Line("Tab(" & Iter'Img & " ) = " & Tab(Iter)'Img);
      end loop;
   end Wypisz;

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
   
--    procedure Zapisz(Tab: in Wektor) is
--       FTLog : FILE_TYPE;
--    begin
--       Create (FTLog, Out_File, "zapisane.txt");
--       for I in Tab'Range loop
--          Put_Line(FTLog, Tab(I)'Img);
--       end loop;
--       Close (FTLog);
--    end Zapisz;
   
end opcje_wektora;