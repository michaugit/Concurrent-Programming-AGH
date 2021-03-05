with System;

with Ada.Text_IO;
use Ada.Text_IO;
with Ada.Real_Time;
use Ada.Real_Time;

with Conf;

package PackageGen is

-- wypisywanie na ekranie
  protected Ekran is
    procedure Pisz(S : String);
    pragma Priority (System.Default_Priority+5); --ustawienie jej najwyższego priorytetu
  end Ekran;

-- zadanie generujące punkty
  task Sender is
    pragma Priority (System.Default_Priority+3); -- priorytet wyższy od Receivera ale niższy od Ekranu i Zdarzenia
  end Sender;

--zadanie odbierające punkty z Zdarzenia i obliczające odległości
  task Receiver is
    pragma Priority (System.Default_Priority+1); -- najniższy priorytet
  end Receiver;

end PackageGen;
