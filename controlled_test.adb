-- Test of Controlled_IO: binary file copy
-- Copyright (C) by PragmAda Software Engineering
-- Released under the terms of the BSD 3-Clause license; see https://opensource.org/licenses

with Ada.Command_Line;
with Controlled_IO;

procedure Controlled_Test is
   Input  : Controlled_IO.File_Handle := Controlled_IO.Opened  (Ada.Command_Line.Argument (1) );
   Output : Controlled_IO.File_Handle := Controlled_IO.Created (Ada.Command_Line.Argument (2) );
begin -- Controlled_Test
   Copy : loop
      exit Copy when Input.End_Of_File;

      Output.Write (Value => Input.Next);
   end loop Copy;
end Controlled_Test;
