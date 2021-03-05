package opcje_wektora is
   
   type Wektor is array (Integer range <>) of Float;
   
   function Sprawdz(Tab   : Wektor) return Boolean;
   
   procedure Zapelnij(Tab : in out Wektor);
   procedure Wypisz(Tab   : Wektor);
   procedure Sortuj(Tab   : in out Wektor);
   -- procedure Zapisz(Tab: in Wektor);

end opcje_wektora;