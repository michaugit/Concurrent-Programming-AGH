generic 
    Size: Natural;
    type Element_Type is (<>);
package Buffor is
    
    type bufforTab is array(Integer range <>) of Element_Type; -- tablica składająca się z Element_Type w tym przypadku Character
    --deklaracja    
    protected type Buffor is
        entry Put(Element: in Element_Type); --włożenie do bufora elementu
        entry Get(Element: out Element_Type); --zabranie z bufora elementu
    private
        BufferTab: bufforTab(1..Size);      -- stworzenia buffor o Size elementach
        Elements_in_buffer : Integer := 0;  --zmienna mówiąca o ilości elementów w buforze
        Index_to_put : Integer := 1;        --zmienna pomocnicza, mówiaca gdzie trzeba wstawić kolejny element
    end Buffor;

end Buffor;
