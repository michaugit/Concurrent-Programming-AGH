pragma Profile(Ravenscar);
with System;
with PackageGen; pragma Unreferenced(PackageGen);

--
procedure Main is

  pragma Priority (System.Priority'First);
  --pragma  Priority (System.Default_Priority);

begin
  PackageGen.Ekran.Pisz("Procedura glowna ");
  loop
    null;
  end loop;

end Main;
