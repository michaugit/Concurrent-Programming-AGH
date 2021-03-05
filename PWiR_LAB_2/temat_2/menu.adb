with Ada.Text_IO, opcje_wektora;
use Ada.Text_IO, opcje_wektora;

procedure Menu is
   Tab : Wektor(0..19) := (others => 0.0);

begin

   -- zapełnienie wektora
   Zapelnij(Tab);
   New_Line(2);
   
   -- wypisanie wektora
   Put_Line("Wygenerowany wektor: ");
   New_Line(1);
   Wypisz(Tab);
   New_Line(2);
   
   -- sprawdzenie czy jest posortowany
   Put_Line("Czy wektor jest posortowany? -> " & Sprawdz(Tab)'Image);
   New_Line(2);

   -- sortowanie i wypisanie wektora
   Put_Line("Sortowanie...");
   Sortuj(Tab);
   Put_Line("Wektor po sortowaniu:");
   New_Line(1);
   Wypisz(Tab);
   New_Line(2);
   
   -- sprawdzenie czy jest posortowany jeszcze raz po sortowaniu
   Put_Line("Czy tablica jest posortowana? -> " & Sprawdz(Tab)'Image);
   New_Line(2);

end Menu;