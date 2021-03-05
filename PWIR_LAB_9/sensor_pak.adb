-- sensor_pak.adb
-- materiały dydaktyczne
-- 2016
-- (c) Jacek Piwowarczyk

with Ada.Text_IO;
use  Ada.Text_IO;
with Ada.Numerics.Float_Random;
use Ada.Numerics.Float_Random;
with Ada.Exceptions;
use Ada.Exceptions;
with GNAT.Sockets; use GNAT.Sockets;
with Ada.Calendar;
use Ada.Calendar;

package body Sensor_Pak is

    task body Sens is
        Nastepny : Time;
        Okres   : constant Duration := 1.2;
        G       : Generator;
        Address : Sock_Addr_Type;
        Socket  : Socket_Type;
        Channel : Stream_Access;
	  Tab: array(1..4,1..4) of Float;

    begin
        Tab := ((1.0,2.0,3.0,4.0),(5.0,6.0,7.0,8.0),(9.0,10.0,11.0,12.0),(13.0,14.0,15.0,16.0));
        Reset(G);
        Nastepny := Clock;
        Address.Addr := Addresses (Get_Host_By_Name (Host_Name), 1);
        --Address.Addr := Addresses (Get_Host_By_Address(Inet_Addr("10.0.0.1")),1);
        --Address.Addr := Inet_Addr("10.0.0.1");
        --Address.Addr := Addresses (Get_Host_By_Name ("imac.local"), 1);
        --Address.Addr := Addresses (Get_Host_By_Name ("localhost"), 1);
        Address.Port := 5876;
        Put_Line("Host: "&Host_Name);
        Put_Line("Adres:port => ("&Image(Address)&")");
        Create_Socket (Socket);
        Set_Socket_Option (Socket, Socket_Level, (Reuse_Address, True));
        Connect_Socket (Socket, Address);

        for I in 1..4 loop
            for J in 1..4 loop
                Put_Line("Sensor: czekam...");
                delay until Nastepny;
                Channel := Stream (Socket);
                --  Wysłanie wiadomości do kontrolera
                Put_Line("Sensor: -> wysylam dane ...");
                Float'Output (Channel, Tab(I,J) );
                --  Odebranie komunikatu od kontrolera i wyprintowanie
                Put_Line ("Sensor: <-" & String'Input (Channel));
                Nastepny := Nastepny + Okres;
            end loop;
        end loop;

        exception
            when E:others =>
                Close_Socket (Socket);
                Put_Line("Error: Zadanie Sensor");
                Put_Line(Exception_Name (E) & ": " & Exception_Message (E));
        end Sens;

end Sensor_Pak;
