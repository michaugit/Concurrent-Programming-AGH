-- Wykonał Michał Pieniądz 
with System;
with Ada.Text_IO;
use  Ada.Text_IO;
with Ada.Exceptions;
use Ada.Exceptions;
with GNAT.Sockets; use GNAT.Sockets;
with Ada.Calendar;
use Ada.Calendar;

procedure b is
    type ArrayFloat is array (Integer range <>) of Float;
    Address  : Sock_Addr_Type;
    Server   : Socket_Type;
    Socket   : Socket_Type;
    Channel  : Stream_Access;
    N : Integer := 20;
    Size: Integer := 0;
    Tab: ArrayFloat(1..N);

    procedure Sortuj(Tab : in out ArrayFloat) is
        Tmp: Float := 0.0;
    begin
        for I in 1..(Size-1) loop
            for J in (I+1)..Size loop
                if Tab(J) < Tab(I) then
                Tmp := Tab(I);
                Tab(I) := Tab(J);
                Tab(J) := Tmp;
                end if;    
            end loop;
        end loop;
    end Sortuj;

    procedure stworz_polaczenie(Address : in out Sock_Addr_Type; Socket  : in out Socket_Type; Channel : in out Stream_Access) is
        begin
            Address.Addr := Addresses (Get_Host_By_Name (Host_Name), 1);
            Address.Port := 5876;
            Put_Line("Host: "&Host_Name);
            Put_Line("Adres:port = ("&Image(Address)&")");

            Create_Socket (Server);
            Set_Socket_Option (Server, Socket_Level, (Reuse_Address, True));
            Bind_Socket (Server, Address);
            Listen_Socket (Server);
            Put_Line ( "B: czekam na A ....");
            Accept_Socket (Server, Socket, Address);
            Channel := Stream (Socket); 

            exception
                when E:others => Put_Line("Error: Zadanie B");
                Put_Line(Exception_Name (E) & ": " & Exception_Message (E));
        end stworz_polaczenie;

    procedure odbierz(Tab : in out ArrayFloat; Channel : Stream_Access; Size : in out Integer) is
            X : Float;
        begin
            loop
                X := Float'Input (Channel);
                Put_Line ("B: otrzymalem =" & X'Img);
                -- jesli odebrano 0.0 oznacza ze trzeba skonczyć pętle i przejść do daleszej części
                if X = 0.0 then
                    exit;
                end if;

                Size := Size + 1;
                Tab(Size) := X;
                --  Wysłanie komunikatu do A
                String'Output (Channel, "OK");
            end loop;

            exception
                when E:others => Put_Line("Error: Zadanie B");
                Put_Line(Exception_Name (E) & ": " & Exception_Message (E));
        end odbierz;

    procedure wyslij_spowrotem(Tab : ArrayFloat; Size : Integer; Channel : Stream_Access) is
    begin
        for I in 1..Size loop
            delay 1.2;
            Put_Line("B: wysylam dane ...");
            Float'Output (Channel, Tab(I));
            Put_Line ("A: " & String'Input (Channel));
        end loop;

        exception
            when E:others => Put_Line("Error: Zadanie B");
            Put_Line(Exception_Name (E) & ": " & Exception_Message (E));

    end wyslij_spowrotem;

    begin

        stworz_polaczenie(Address, Socket, Channel);    --tworzenie połączenia
        odbierz(Tab, Channel, Size); -- odbiór danych do sortowania od A
        
        Put_Line("Sortuje...");
        Sortuj(Tab); -- sortowanie

        Put_Line("Wysylam z powrotem...");
        wyslij_spowrotem(Tab, Size, Channel); --wysłanie posortowanych danych z powrotem do A
        
end b;