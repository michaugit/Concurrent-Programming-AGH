-- Wykonał Michał Pieniądz 
with System;
with Ada.Text_IO;
use  Ada.Text_IO;
with Ada.Numerics.Float_Random;
use Ada.Numerics.Float_Random;
with Ada.Exceptions;
use Ada.Exceptions;
with GNAT.Sockets; use GNAT.Sockets;
with Ada.Calendar;
use Ada.Calendar;

procedure a is

    task Atask;

    task body Atask is
        type ArrayFloat is array (Integer range <>) of Float;
        Address : Sock_Addr_Type;
        Socket  : Socket_Type;
        Channel : Stream_Access;   
        N : Integer := 10;
        SortedTab: ArrayFloat(1..N);

        procedure stworz_polaczenie(Address : in out Sock_Addr_Type; Socket  : in out Socket_Type; Channel : in out Stream_Access) is
        begin
            Address.Addr := Addresses (Get_Host_By_Name (Host_Name), 1);
            Address.Port := 5876;
            Put_Line("Host: "&Host_Name);
            Put_Line("Adres:port => ("&Image(Address)&")");
            Create_Socket (Socket);
            Set_Socket_Option (Socket, Socket_Level, (Reuse_Address, True));
            Connect_Socket (Socket, Address);
            Channel := Stream (Socket);

            exception
                when E:others =>
                    Close_Socket (Socket);
                    Put_Line("Error: Zadanie A");
                    Put_Line(Exception_Name (E) & ": " & Exception_Message (E));
        end stworz_polaczenie;


        procedure wygeneruj_i_wyslij(N: Integer; Channel : Stream_Access) is
            Nastepny : Time;
            Okres   : constant Duration := 1.2;
            Gen : Ada.Numerics.Float_Random.Generator;
            X : Float;
        begin
            Reset(Gen);
            Nastepny := Clock;
            for I in 1..N loop
                X := Ada.Numerics.Float_Random.Random (Gen);
                delay until Nastepny;  
                --  Wysłanie wiadomości do B
                Put_Line("A: wysylam dane ...");
                Float'Output (Channel, X);
                --  Odebranie komunikatu od B i wyprintowanie
                Put_Line ("B: " & String'Input (Channel));
                Nastepny := Nastepny + Okres;
                
                -- jesli wszystkie elementy się skonczyly do wyslania wysylam jeszcze 0.0
                if I = N then
                    Float'Output (Channel, 0.0);
                end if;
            end loop;

            exception
                when E:others =>
                    Close_Socket (Socket);
                    Put_Line("Error: Zadanie A");
                    Put_Line(Exception_Name (E) & ": " & Exception_Message (E));
        end wygeneruj_i_wyslij;


        procedure odbierz_posortowana(Tab : in out ArrayFloat; N: Integer; Channel : Stream_Access) is
            X : Float;
        begin
            for J in 1..N loop
                X := Float'Input (Channel);
                SortedTab(J) := X;
                Put_Line("A: otrzymalem: "& X'Img);
                String'Output (Channel, "OK");
            end loop;

            exception
                when E:others =>
                    Close_Socket (Socket);
                    Put_Line("Error: Zadanie A");
                    Put_Line(Exception_Name (E) & ": " & Exception_Message (E));
        end odbierz_posortowana;


        procedure wypisz(Tab : in out ArrayFloat; Size : Integer ) is
        begin
            for I in 1..Size loop
                Put(" "& SortedTab(I)'Img);
            end loop;
        end wypisz;


    begin      
        stworz_polaczenie(Address, Socket, Channel); -- tworzy połączenie 
        wygeneruj_i_wyslij(N, Channel);  -- generuje N wartości i wysyła do B
        odbierz_posortowana(SortedTab, N, Channel); -- odbiera N wartości od B zapisując w sortedtab

        Put_Line("Otrzymalem posortowana tablice:");
        wypisz(SortedTab, N); -- wypisanie tablicy
    end Atask;

    begin
    null;
end a;