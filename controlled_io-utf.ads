-- Universal Text Files (UTF) that are opened/created at declaration and closed when finalized
-- Copyright (C) by PragmAda Software Engineering
-- Released under the terms of the BSD 3-Clause license; see https://opensource.org/licenses

package Controlled_IO.UTF is
   procedure Put_Line (File : in out File_Handle; Item : in Wide_Wide_String);
   -- Writes Item to File

   function Next_Line (File : in out File_Handle) return Wide_Wide_String with
      Pre => not File.End_Of_File;
   -- Gets a line from File
end Controlled_IO.UTF;
