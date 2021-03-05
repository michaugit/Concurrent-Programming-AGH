with Ada.Text_IO, Ada.Numerics.Float_Random, Ada.Numerics.Discrete_Random;
use Ada.Text_IO;

procedure lab6_2 is


type Colors is (Red, Green, Blue);
package ColorGenerator is new Ada.Numerics.Discrete_Random(Colors);
  

--==================================================================================
-- definicja
task MultiGenerator is
    entry From0To5(X: in out Float);    --losowanie floata od 0 do 5
    entry RandColor(C: in out Colors);  --losowanie randomowego koloru
    entry Close;    -- zamknięcie
end MultiGenerator;

-- ciało
task body MultiGenerator is
    GenF: Ada.Numerics.Float_Random.Generator;  -- generator floatów
    GenC: ColorGenerator.Generator;             -- generator kolorów
begin
    loop --nieskonczona pętla do póki nie będzie polecenia close
        select
        -- 0.0 - 5.0
            accept From0To5(X: in out Float) do --losowanie floata 
                Ada.Numerics.Float_Random.Reset(GenF);
                X := Ada.Numerics.Float_Random.Random(GenF)*5.0; --przypisanie wartości do wejścia X
            end From0To5;
        or
        -- Colors
            accept RandColor(C: in out Colors) do   --losowanie koloru
                ColorGenerator.Reset(GenC);
                C := ColorGenerator.Random(GenC);   --przypisanie koloru do wejścia C
            end RandColor;
        or    
        -- close
            accept Close;   --zamknięcie zadania
            exit;
        end select;
    end loop;
end MultiGenerator;
--==================================================================================




--==================================================================================

Result0_5: Float := 0.0;
RandomColor: Colors := Red;

begin
    MultiGenerator.From0To5(Result0_5);
    Put_Line("The float number from 0 to 5: " & Result0_5'Img);
  
    MultiGenerator.RandColor(RandomColor);
    Put_Line("The color: "& RandomColor'Img);
  
    MultiGenerator.Close;
end lab6_2;
--==================================================================================