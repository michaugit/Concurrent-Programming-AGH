with Ada.Text_IO, Ada.Numerics.Discrete_Random;
use Ada.Text_IO;

with Ada.Numerics.Elementary_Functions; 

procedure lab6_1 is


--==================================================================================
-- jedno - generujące i przesyłające N razy punkt (x,y) o wartościach pseudolosowych 

-- deklarcja zadania wysyłającego
task Sender is
    entry Generate(N: Integer);  	
end Sender;

------------------------------------------------------------------------------------
-- drugie - odbierające dane i wyliczające
    -- odległość punktu od początku układu współżędnych
    -- odległość pomiędzy dwoma kolejnymi punktami


-- deklaracja zadania odbierajacego
task Receiver is 
    entry Start;
    entry Point(X, Y: Integer);
    entry Close;
end Receiver;
--==================================================================================




--==================================================================================
package RndNumbers is new Ada.Numerics.Discrete_Random(Integer); --do losowania
    use RndNumbers; --do losowania

-- ciało zadania wysłającego
task body Sender is
    X: Integer;
    Y: Integer;
    Gen: Generator;
begin
    Reset(Gen);
    accept Generate(N: Integer) do	 -- generyjemy N punktów
        for K in 1..N loop
            X:= Random(Gen) rem 100; --generujemy X 
            Y:= Random(Gen) rem 100; --generyjemy Y
  	    Receiver.Point(X,Y);         -- wysłanie do receivera punktu
        end loop;
    end Generate;
end Sender;
--==================================================================================




--==================================================================================
-- funkcja do pomiaru odległości
function distance(X1,Y1,X2,Y2: in Integer) return Float is
Distance: Float;
begin
    Distance := Ada.Numerics.Elementary_Functions.Sqrt( Float( ((X1-X2)**2) + ((Y1-Y2)**2) )); --zwykle obliczanie odległości między punktami
    return Distance;
end distance;

-- ciało zadania odbierającego
task body Receiver is
    DistanceFromZeroPoint: Float := 0.0;
    DistanceFromLast: Float := 0.0;
    PrevX: Integer := 0;    -- defaultowo poprzednim punktem jest punkt (0,0)
    PrevY: Integer := 0;
begin
    accept Start;
  
    loop    --nieskonczona pętla do póki nie będzie polecenia close
        select -- wybór zdarzenia
            accept Point(X,Y: in Integer) do    -- akceptacja obliczania Punkta
                DistanceFromLast := distance(X,Y,PrevX,PrevY);  --dystans od poprzedniego
                DistanceFromZeroPoint := distance(X,Y,0,0);     --dystans od punktu (0,0)
                New_Line(2);
                Put_Line("==============================================");
                Put_Line("Point (" & X'Img & "," & Y'Img & ")");
                Put_Line("Distance from (0,0) = " & DistanceFromZeroPoint'Img);
                Put_Line("Distance from (" & PrevX'Img & "," & PrevY'Img &  ") = " & DistanceFromLast'Img);
                Put_Line("==============================================");
                PrevX := X; -- przestawiamy poprzedni X na aktualny
                PrevY := Y; -- przestawiamy poprzedni Y na aktualny
            end Point;
        or 
	        accept Close;   -- akceptacja "zamknięcia"
 	        exit;
        end select;
    end loop;
  
     Put_Line("Close Receiver ");
end Receiver;
--==================================================================================







--==================================================================================
begin
    Receiver.Start;
    Sender.Generate(15);
    Receiver.Close;
  
    Put_Line("End of the Program");
end lab6_1;
--==================================================================================	  	
