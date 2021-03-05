-- menup.adb

with Ada.Text_IO, Opcje;
use Ada.Text_IO, Opcje;
with Ada.Directories; 
use Ada.Directories;
with Ada.Calendar;
use Ada.Calendar;
with Ada.Calendar.Formatting; 
use Ada.Calendar.Formatting;


procedure MenuP is
  Zn: Character := ' '; 
  
  procedure Pisz_Menu is
  begin
	New_Line;  
	Put_Line("Menu:");  
    Put_Line(" s - opcja s");
	Put_Line(" c - opcja c");
	Put_Line(" p - opcja p");
	Put_Line("ESC -Wyjscie");
	Put_Line("Wybierz (s,c,p, ESC-koniec):");
  end Pisz_Menu;

	procedure Log( Wpis   : String) is
  		Plik : File_Type;
  		Nazwa: String := "dziennik.txt";
		T: Time;
	begin
		T := Clock;
	if not Exists (Nazwa) then
		Create(Plik, Out_File, Nazwa);
		Put_Line(Plik, Image (T) (1..19) & " -> " & Wpis);
	else
		Open (File => Plik, Name => Nazwa, Mode => Append_File);
		Put_Line(Plik, Image (T) (1..19) & " -> " & Wpis);
	end if;
	Close(Plik);
	end Log;

  
begin
	Log("START PROGRAMU");
  loop
    Pisz_Menu;
	Get_Immediate(Zn);
	case Zn is
	  when 's' => Opcja_S;
	  	Log("Opcja_S");
	  when 'c' => Opcja_C;
	  	Log("Opcja_C");
	  when 'p' => Opcja_P;
	  	Log("Opcja_P");
      when ASCII.ESC => Log("ESC");
	  	exit;
	  when others => Put_Line("Blad!!");
	  	Log("Blad!!!");
	end case;
  end loop;
  Put_Line("Koniec");
  Log("KONIEC PROGRAMU");
end MenuP;
  	 
  