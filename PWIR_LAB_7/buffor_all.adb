with Ada.Text_IO;
use Ada.Text_IO;

procedure Buffor_all is
    -- zmienne w celu późniejszej zmiany na package "żeby było łatwiej"
    type Element_Type is  new Character;
    Size: Natural := 10 ;
    
    
    type bufforTab is array(Integer range <>) of Element_Type; -- tablica składająca się z Element_Type w tym przypadku Character
    
    --deklaracja
    protected type Buffor(Size: Integer) is
        entry Put(Element: in Element_Type);    --włożenie do bufora elementu
        entry Get(Element: out Element_Type);   --zabranie z bufora elementu
    private
        BufferTab: bufforTab(1..Size);  -- stworzenia buffor o Size elementach
        Elements_in_buffer : Integer := 0;  --zmienna mówiąca o ilości elementów w buforze
        Index_to_put : Integer := 1;        --zmienna pomocnicza, mówiaca gdzie trzeba wstawić kolejny element
    end Buffor;
    
    protected body Buffor is
        entry Put(Element: in Element_Type) when Elements_in_buffer < Size is --upewniamy się czy możemy włozyć do bufora, czy nie jest przepełniony
        begin
            BufferTab(Index_to_put) := Element; --wkładamy element do tablicy
            Elements_in_buffer := Elements_in_buffer + 1; --zwiększamy ilość elementów w tablicy
            Index_to_put:= Index_to_put + 1; -- zwiększamy index_to_put dla kolejnego elementu
            
            Put_Line("# Put Element: " & Element'Img & " [Elements in Buffer: "& Elements_in_buffer'Img &"/"&Size'Img&"]");
            Put_Line("Index_to_put("&Index_to_put'Img&" ) ");
            New_Line(2);
        end Put;
        
        entry Get(Element: out Element_Type) when Elements_in_buffer > 0 is -- upewniamy sie czy jest co pobrać z bufora
        begin
            Index_to_put := Index_to_put - 1;   -- zmniejszamy index_to_put aby pobrać ostatni element i przesunąć iterator
            Element := BufferTab(Index_to_put); -- pobieramy ostatni element zgodnie z zasadą LIFO
            Elements_in_buffer := Elements_in_buffer - 1;   -- zmniejszamy ilość elementów w buforze

            
            Put_Line("# Get Element: " & Element'Img & " [Elements in Buffer: "& Elements_in_buffer'Img &"/"&Size'Img&"]");
            Put_Line("Index_to_put("&Index_to_put'Img&" )");
            New_Line(2);
        end Get;
    end Buffor;

    Buffor1 : Buffor(10); --deklaracja buffora o 10 elementach



-- producent
    task Producer is
        entry Start;
        end Producer;

    task body Producer is
        X: Element_Type := 'X'; -- wstawiamy zawsze X
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
        X: Element_Type := ' '; --zmienna do przechowania pobranego elementu
    begin
        accept Start;
            for I in 1..10 loop -- pobieramy w pętli 10 elementów
                delay 1.0;      -- opóźnienie 1s w celu lepszego zilustorwania momentu gdy bufor jest przepełniony i nie można nic dołożyć
                Put_Line("==> "&I'Img&" Consumer get Element from buffer <==" );
                New_Line(2);
                Buffor1.Get(X); -- pobranie elementu
            end loop;
    end Consumer;




begin
  Producer.Start;
  Consumer.Start;
end Buffor_all;