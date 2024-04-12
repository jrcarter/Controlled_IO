-- Test of Controlled_IO.Text and Controlled_IO.UTF: convert an OS-format text file to UTF
-- Copyright (C) by PragmAda Software Engineering
-- Released under the terms of the BSD 3-Clause license; see https://opensource.org/licenses

with Ada.Characters.Conversions;
with Ada.Command_Line;
with Controlled_IO.Text;
with Controlled_IO.UTF;

procedure Controlled_UTF is
   Input  : Controlled_IO.File_Handle := Controlled_IO.Opened  (Ada.Command_Line.Argument (1) );
   Output : Controlled_IO.File_Handle := Controlled_IO.Created (Ada.Command_Line.Argument (2) );
begin -- Controlled_UTF
   Copy : loop
      exit Copy when Input.End_Of_File;

      Controlled_IO.UTF.Put_Line
         (File => Output, Item => Ada.Characters.Conversions.To_Wide_Wide_String (Controlled_IO.Text.Next_Line (Input) ) );
   end loop Copy;
end Controlled_UTF;
