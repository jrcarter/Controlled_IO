-- Test of Controlled_IO.Text: text file copy
-- Copyright (C) by PragmAda Software Engineering
-- SPDX-License-Identifier: BSD-3-Clause
-- See https://spdx.org/licenses/
-- If you find this software useful, please let me know, either through
-- github.com/jrcarter or directly to pragmada@pragmada.x10hosting.com

with Ada.Command_Line;
with Controlled_IO.Text;

procedure Controlled_Text is
   Input  : Controlled_IO.File_Handle := Controlled_IO.Opened  (Ada.Command_Line.Argument (1) );
   Output : Controlled_IO.File_Handle := Controlled_IO.Created (Ada.Command_Line.Argument (2) );
begin -- Controlled_Text
   Copy : loop
      exit Copy when Input.End_Of_File;

      Controlled_IO.Text.Write_Line (File => Output, Item => Controlled_IO.Text.Next_Line (Input) );
   end loop Copy;
end Controlled_Text;
