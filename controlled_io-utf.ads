-- Universal Text Files (UTF) that are opened/created at declaration and closed when finalized
-- Copyright (C) by PragmAda Software Engineering
-- SPDX-License-Identifier: BSD-3-Clause
-- See https://spdx.org/licenses/
-- If you find this software useful, please let me know, either through
-- github.com/jrcarter or directly to pragmada@pragmada.x10hosting.com

package Controlled_IO.UTF is
   procedure Put_Line (File : in out File_Handle; Item : in Wide_Wide_String);
   -- Writes Item to File

   function Next_Line (File : in out File_Handle) return Wide_Wide_String with
      Pre => not File.End_Of_File;
   -- Gets a line from File
end Controlled_IO.UTF;
