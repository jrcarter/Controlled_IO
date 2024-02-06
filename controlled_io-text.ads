-- Text files that are opened/created at declaration and closed when finalized
-- Copyright (C) by PragmAda Software Engineering
-- Released under the terms of the BSD 3-Clause license; see https://opensource.org/licenses

package Controlled_IO.Text is
   -- On input, an EOL is any of a CR, LF, or CR-LF pair
   -- On output, an EOL is an LF (TBD: allow other EOLs)

   procedure New_Line (File : in out File_Handle; Spacing : in Positive := 1);
   -- Adds Spacing EOLs to File

   procedure Skip_Line (File : in out File_Handle; Spacing : in Positive := 1);
   -- Skips Spacing EOLs in File

   function End_Of_Line (File : in out File_Handle) return Boolean;
   -- Returns True if the next thing in File is an EOL; False otherwise

   function Next (File : in out File_Handle) return Character;
   -- Skips any EOLs in File and then reads a single Character from File into Item

   procedure Write (File : in out File_Handle; Item : in Character);
   -- Writes Item to File

   procedure Read (File : in out File_Handle; Item : out String);
   -- Calls File.Next for every Character in Item

   procedure Write (File : in out File_Handle; Item : in String);
   -- Calls File.Write for every Character in Item

   function Next_Line (File : in out File_Handle) return String;
   -- Reads Characters from File until an EOL is encountered
   -- Skips the EOL

   procedure Read_Line (File : in out File_Handle; Item : out String; Last : out Natural);
   -- Reads Characters from File until Item is filled or an EOL is encountered
   -- The index of the last position filled in Item is put in Last
   -- If an EOL is encountered, skips the EOL
   -- If End_Of_Line (File), Last will be 0

   procedure Write_Line (File : in out File_Handle; Item : in String);
   -- Writes Item to File followed by an EOL
end Controlled_IO.Text;
