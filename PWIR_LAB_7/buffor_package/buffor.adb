with Ada.Text_IO;
use Ada.Text_IO;

package body Buffor is
--ciało
    protected body Buffor is
        entry Put(Element: in Element_Type) when Elements_in_buffer < Size is --upewniamy się czy możemy włozyć do bufora, czy nie jest przepełniony
        begin
            BufferTab(Index_to_put) := Element; --wkładamy element do tablicy
            Elements_in_buffer := Elements_in_buffer + 1;   --zwiększamy ilość elementów w tablicy
            Index_to_put:= Index_to_put + 1;    --zwiększamy index_to_put dla kolejnego elementu
            
            Put_Line("# Put Element: " & Element'Img & " [Elements in Buffer: "& Elements_in_buffer'Img &"/"&Size'Img&"]");
            Put_Line("Index_to_put("&Index_to_put'Img&" ) ");
            New_Line(2);
        end Put;
        
        entry Get(Element: out Element_Type) when Elements_in_buffer > 0 is -- upewniamy sie czy jest co pobrać z bufora
        begin
            Index_to_put := Index_to_put - 1;   -- zmniejszamy index_to_put aby pobrać ostatni element i przesunąć iterator
            Element := BufferTab(Index_to_put); -- pobieramy ostatni element zgodnie z zasadą LIFO
            Elements_in_buffer := Elements_in_buffer - 1; -- zmniejszamy ilość elementów w buforze
            
            Put_Line("# Get Element: " & Element'Img & " [Elements in Buffer: "& Elements_in_buffer'Img &"/"&Size'Img&"]");
            Put_Line("Index_to_put("&Index_to_put'Img&" )");
            New_Line(2);
        end Get;
    end Buffor;

end Buffor;


