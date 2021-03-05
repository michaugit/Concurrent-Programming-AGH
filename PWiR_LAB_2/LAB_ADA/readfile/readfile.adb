with Ada.Text_IO;
use Ada.Text_IO;
with Ada.Strings.Unbounded;
use Ada.Strings.Unbounded;

procedure readfile is
  Pl : File_Type;
  Nazwa: String(1..100) := (others => ' ');	
  Dlugosc : Integer := 0;
begin
  loop
	Put_Line("Podaj nazwe pliku do otwarcia: ");
	Get_Line(Nazwa, Dlugosc);
    begin
      Put_Line("Otwieram plik: " & Nazwa(1..Dlugosc));  	
	  Open(Pl, In_File, Nazwa(1..Dlugosc));
    loop
      exit when end_of_file(Pl);
      declare
        sline : String := Get_Line(Pl);
      begin
        Put_Line(sline);
      end;
    end loop;
	  exit;
	exception
	  when Name_Error => Put_Line("Bledna nazwa pliku <" & Nazwa(1..Dlugosc) & "> !");
	end;  
  end loop;
  
  
  Put_Line("Zamykam plik");
  Close(Pl);
end readfile;