with Ada.Text_IO;
use Ada.Text_IO;

procedure Semafor is
--   semafor na obiekcie chronionym
    protected type Semaphore(N: Integer) is
        entry Wait(TaskNumber : Integer);   -- zabranie zasobu
        entry Signal(TaskNumber : Integer); -- zwolnienie zasobu
        private
            Capacity: Integer := N;         -- "pojemność" semafora
            Size: Integer := N;             -- aktualny rozmiar korzystających z zasobu
    end Semaphore;

    protected body Semaphore  is
        entry Wait(TaskNumber: in Integer) when Size > 0 is --patrzymy czy możemy wziąć zasób kiedy Size > 0
        begin
            Size := Size - 1;   --pobieramy zasób więc zmniejszamy size
            Put_Line("# Task: "&TaskNumber'Img&"  do Wait() on the Semaphore: Size->"&Size'Img);
        end Wait;

        entry Signal(TaskNumber: in Integer) when Size < Capacity is -- oddajemu zasób i zabezpieczenie przed "powiększaniem"
        begin
            Size := Size + 1;   -- oddajemy zasób wiec zwiększamy size
            Put_Line("# Task: "&TaskNumber'Img&" do Signal() on the Semaphore: Size->"&Size'Img);
        end Signal;
    end Semaphore;







-- ############ TEST ###############

    s1: Semaphore(5);

    task type task_to_semaphore(N:Integer);
    task body task_to_semaphore is
    begin
        Put_Line("Task: "&N'Img&" has started");
        s1.Wait(N); -- zabieramy zasób robiąc wait na semaforze
        delay 1.0;  -- czekamy sekunde - symulując prace z zasobem
        s1.Signal(N);   -- zwalniamy zasób
        Put_Line("Task: "&N'Img&" has just finished");
    end task_to_semaphore;

    -- zadanie korzystające z tego samego zasobu:
    z1: task_to_semaphore(1);
    z2: task_to_semaphore(2);
    z3: task_to_semaphore(3);
    z4: task_to_semaphore(4);
    z5: task_to_semaphore(5);
    z6: task_to_semaphore(6);
    z7: task_to_semaphore(7);
    z8: task_to_semaphore(8);
    z9: task_to_semaphore(9);
    z10: task_to_semaphore(10);

begin
    null;
end Semafor;