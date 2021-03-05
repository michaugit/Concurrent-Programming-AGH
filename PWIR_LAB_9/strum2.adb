-- strum2.adb
--
-- materiały dydaktyczne
-- 2016
-- (c) Jacek Piwowarczyk
--
-- zapis i odczyt do/z pliku tekstowego jako strumienia

with Ada;
use Ada;
with Ada.Text_IO;
use Ada.Text_IO;
with Ada.Streams;
use Ada.Streams;
with Ada.Text_IO.Text_Streams;
use Ada.Text_IO.Text_Streams;
with Ada.Numerics.Float_Random, Ada.Numerics.Discrete_Random;

procedure Strum2 is
Msize: Integer;
Nsize: Integer;
  
    -- procedura służąca do wygenerowania tablicy i zapisania jej do pliku
    procedure WriteTable(M: Integer; N: Integer) is
        Plik         : File_Type;
        Nazwa        : String := "text.txt";
        Strumien     : Stream_Access;
        Tab: array(1..M,1..N) of Float; --macierz do której zapisywane są liczby a potem z niej następuje zapis do pliku
        GenF: Ada.Numerics.Float_Random.Generator; 
    begin
        Put_Line("PARAMENTRY MACIERZY " & M'Img & "  " & N'Img);
        Put_Line("Wyswietlenie wygenerowanej tablicy:");  
        -- dwie pętle for do generacji macierzy 
        for I in 1..M loop
              for J in 1..N loop
                  Ada.Numerics.Float_Random.Reset(GenF);
                  Tab(I,J):= Ada.Numerics.Float_Random.Random(GenF)*5.0; --generowanie liczby float od 0 do 5 i zapis w macierzy
                  Put(" "&Tab(I,J)'Img); 
              end loop;
              Put_Line("");
        end loop;
        New_Line(3);

        -- stworzenie pliku i strumienia
        Create(Plik, Out_File, Nazwa); 
        Strumien := Stream(Plik);
        -- dwie pętle for do generacji macierzy
        for I in 1..M loop
              for J in 1..N loop
                  Put_Line("Zapisuje dane =" & Tab(I,J)'Img);
                  Float'Output (Strumien, Tab(I,J));  -- zapis do strumienia
              end loop;
          end loop;
        Close(Plik); -- zamkniecie pliku
    end WriteTable;


    procedure ReadTable(M: Integer; N: Integer) is
        Plik         : File_Type;
        Nazwa        : String := "text.txt";
        Strumien     : Stream_Access;
        Tab: array(1..M,1..N) of Float; --macierz do której odczytywane  są liczby z pliku
        Dane: Float;
    begin
        -- otworzenie pliku, i stworzenie strumienia
        Open(Plik, In_File, Nazwa);
        Strumien := Stream(Plik);
        New_Line(3);

        -- dwie pęle for do odczytu z pliku i zapisania danych do macierzy
        for I in 1..M loop
            for J in 1..N loop
                Dane := Float'Input (Strumien); --odczyt ze strumienia
                Put_Line ("Odczytuje dane =" & Dane'Img);
                Tab(I,J):=Dane;
            end loop;
        end loop;
        Close(Plik); -- zamkniecie pliku

        New_Line(3);
        Put_Line("Wyswietlenie wczytanej tablicy:");
        -- dwie pętle for do wyświetlenia wczytanej macierzy
        for I in 1..M loop
            for J in 1..N loop
                Put(" "&Tab(I,J)'Img);
            end loop;
            Put_Line("");
        end loop;
    end ReadTable;


begin
    -- rozmairy macierzy
    Msize:= 4;
    Nsize:= 4;

    WriteTable(Msize, Nsize);
    ReadTable(Msize, Nsize);

end Strum2;  
