pragma Profile(Ravenscar);

with Ada.Numerics.Discrete_Random;
with Ada.Exceptions;
use Ada.Exceptions;
with Ada.Synchronous_Task_Control;
use  Ada.Synchronous_Task_Control;
with Ada.Numerics.Elementary_Functions; 

package body PackageGen is

-- obiekt do pisania na ekranie o najwyższym priorytecie
  protected body Ekran is
    procedure Pisz(S : String) is
    begin
      Put_Line(S);
    end Pisz;
  end Ekran;

-- obiekt chroniony mający jeden Entry spełniający warunku Ravenscar 
  protected Zdarzenie is
    entry Czekaj(Xs, Ys: out Integer);   -- pobranie zapisanych wartości z zdarzenia
    procedure Wstaw(Xs, Ys: in Integer); -- procedura do wstawiania współrzędnych wygenerowanego punktu i zapisania go w zdarzeniu
  private
    pragma Priority (System.Default_Priority+4); -- przypisanie mu priorytetu pomiędzy Senderem a Ekranem
    X : Integer := 0;
    Y : Integer := 0;
    Jest_Zdarzenie : Boolean := False;
  end Zdarzenie;

-- ciało
  protected body Zdarzenie is
    entry Czekaj(Xs,Ys: out Integer) when Jest_Zdarzenie is -- sprawdzamy czy zaistniało zdarzenie jeśli tak to wchodzimy do srodka i odczytujemy na dane
    begin
      Jest_Zdarzenie := False; --zmieniamy zdarzenie na false, że zostało "zabrane"
      Xs := X; -- przepisujemy dane do żądania od Receivera
      Ys := Y; -- przepisujemy dane do żądania od Receivera
    end Czekaj;

    procedure Wstaw(Xs,Ys: in Integer) is
    begin
      Jest_Zdarzenie := True; -- zmieniamy na true, że do zdarzenia zostały dostarczone nowe dane
      X := Xs; -- ustawiamy te dane
      Y := Ys; -- ustawiamy te dane
    end Wstaw;
  end Zdarzenie;




package RndNumbers is new Ada.Numerics.Discrete_Random(Integer); --do losowania

task body Sender is
    use RndNumbers;
    X: Integer;
    Y: Integer;
    Gen: Generator;
    Nastepny : Ada.Real_Time.Time;
    Przesuniecie : constant Ada.Real_Time.Time_Span := Ada.Real_Time.Milliseconds(2000);
begin
    Reset(Gen);
    Nastepny := Ada.Real_Time.Clock + Przesuniecie;
    loop
      delay until Nastepny;
      New_Line(2);
      Ekran.Pisz("-----------------------------------------------");
      Ekran.Pisz("Zadanie generujace punkt");
      X:= Random(Gen) rem 100; --generujemy X 
      Y:= Random(Gen) rem 100; --generyjemy Y
      Ekran.Pisz("Point (" & X'Img & "," & Y'Img & ")");
      Ekran.Pisz("-----------------------------------------------");
      Zdarzenie.Wstaw(X,Y); -- wstawienie wylosowanego punktu do zdarzenia
      Nastepny := Nastepny + Przesuniecie;
    end loop;
  exception
    when E:others => Put_Line("Error: Zadanie generujace zdarzenia");
      Put_Line(Exception_Name (E) & ": " & Exception_Message (E));
end Sender;



task body Receiver is
    DistanceFromZeroPoint: Float := 0.0;
    DistanceFromLast: Float := 0.0;
    PrevX: Integer := 0;    -- defaultowo poprzednim punktem jest punkt (0,0)
    PrevY: Integer := 0;
    X: Integer := 0;  -- aktualny punkt
    Y: Integer := 0;

function distance(X1,Y1,X2,Y2: in Integer) return Float is
  Distance: Float;
begin
    Distance := Ada.Numerics.Elementary_Functions.Sqrt( Float( ((X1-X2)**2) + ((Y1-Y2)**2) )); --zwykle obliczanie odległości między punktami
    return Distance;
end distance;

begin
  loop
      Zdarzenie.Czekaj(X,Y); -- pobranie ze zdarzenia współrzędnych wygenerowanego punktu
      DistanceFromLast := distance(X,Y,PrevX,PrevY);  --dystans od poprzedniego
      DistanceFromZeroPoint := distance(X,Y,0,0);     --dystans od punktu (0,0)
      New_Line(2);
      Ekran.Pisz("==============================================");
      Ekran.Pisz("Point (" & X'Img & "," & Y'Img & ")");
      Ekran.Pisz("Distance from (0,0) = " & DistanceFromZeroPoint'Img);
      Ekran.Pisz("Distance from (" & PrevX'Img & "," & PrevY'Img &  ") = " & DistanceFromLast'Img);
      Ekran.Pisz("==============================================");
      PrevX := X; -- przestawiamy poprzedni X na aktualny
      PrevY := Y; -- przestawiamy poprzedni Y na aktualny
  end loop;
  exception
    when E:others => Put_Line("Error: Zadanie odbierajace");
      Put_Line(Exception_Name (E) & ": " & Exception_Message (E));
end Receiver;

begin
  null;
end PackageGen;
