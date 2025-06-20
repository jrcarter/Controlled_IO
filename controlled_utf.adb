-- Test of Controlled_IO.Text and Controlled_IO.UTF: convert an OS-format text file to UTF
-- Copyright (C) by PragmAda Software Engineering
-- SPDX-License-Identifier: BSD-3-Clause
-- See https://spdx.org/licenses/
-- If you find this software useful, please let me know, either through
-- github.com/jrcarter or directly to pragmada@pragmada.x10hosting.com

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
