with Ada.Text_IO, Buffor;
use Ada.Text_IO;
-- procedura w celu przetestowania pakietu Buffor
procedure Buffor_test is
    package BufforCh is new Buffor(10, Character); --tworzymy bufor o 10 elementach typu Character
    use BufforCh;
    Buffor1 : BufforCh.Buffor; -- tworzymy instancje tego bufora


-- producent
    task Producer is
        entry Start;
        end Producer;

    task body Producer is
        X: Character := 'X';    -- wstawiamy zawsze X
    begin
        accept Start;
            for I in 1..20 loop -- w pętli wkładamy 20 elemtów do buffora
                Put_Line("==> "&I'Img&" Producer put: " & X'Img & " <==");
                New_Line(2);
                Buffor1.Put(X); -- samo włożenie
            end loop;
    end Producer;


-- konsument
    task Consumer is
        entry Start;
        end Consumer;

    task body Consumer is
        X: Character := ' '; --zmienna do przechowania pobranego elementu
    begin
        accept Start;
            for I in 1..10 loop -- pobieramy w pętli 10 elementów
                delay 1.0;  -- opóźnienie 1s w celu lepszego zilustorwania momentu gdy bufor jest przepełniony i nie można nic dołożyć
                Put_Line("==> "&I'Img&" Consumer get Element from buffer <==" );
                New_Line(2);
                Buffor1.Get(X); -- pobranie elementu
            end loop;
    end Consumer;


begin
    Producer.Start;
    Consumer.Start;
end Buffor_test;