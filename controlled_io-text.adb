-- Text files that are opened/created at declaration and closed when finalized
-- Copyright (C) by PragmAda Software Engineering
-- Released under the terms of the BSD 3-Clause license; see https://opensource.org/licenses

with Ada.Characters.Latin_1;
with Ada.IO_Exceptions;

package body Controlled_IO.Text is
   procedure New_Line (File : in out File_Handle; Spacing : in Positive := 1) is
      -- Empty
   begin -- New_Line
      All_Lines : for I in 1 .. Spacing loop
         Byte_IO.Write (File => File.Handle, Item => Character'Pos (Ada.Characters.Latin_1.LF) );
      end loop All_Lines;
   end New_Line;

   function Next_Raw (File : in out File_Handle) return Character;
   -- Gets the next Character from File, including EOL Characters

   procedure Undo_Read (File : in out File_Handle);
   -- Makes the last Character read by Next_Raw be the Character that Next_Raw will return next by decrementing File's position

   procedure Skip_Line (File : in out File_Handle; Spacing : in Positive := 1) is
      Char : Character;
      EOF  : Boolean; -- Indicates if End_Error should be reraised
   begin -- Skip_Line
      All_Lines : for I in 1 .. Spacing loop
         EOF := I < Spacing;

         Find_EOL : loop
            Char := Next_Raw (File);

            exit Find_EOL when Char = Ada.Characters.Latin_1.LF;

            if Char = Ada.Characters.Latin_1.CR then
               Char := Next_Raw (File);

               if Char /= Ada.Characters.Latin_1.LF then
                  Undo_Read (File => File);
               end if;

               exit Find_EOL;
            end if;
         end loop Find_EOL;
      end loop All_Lines;
   exception -- Skip_Line
   when Ada.IO_Exceptions.End_Error =>
      if EOF then
         raise;
      end if;
      -- Otherwise we have a final line without a line terminator, or with a Mac line terminator, and we've skipped that line
   end Skip_Line;

   function End_Of_Line (File : in out File_Handle) return Boolean is
      Char : constant Character := Next_Raw (File);
   begin -- End_Of_Line
      Undo_Read (File => File);

      return Char in Ada.Characters.Latin_1.CR | Ada.Characters.Latin_1.LF;
   end End_Of_Line;

   function Next (File : in out File_Handle) return Character is
      Char : Character;
   begin -- Next
      Find_Item : loop
         Char := Next_Raw (File);

         if Char not in Ada.Characters.Latin_1.CR | Ada.Characters.Latin_1.LF then
            return Char;
         end if;

         if Char = Ada.Characters.Latin_1.CR then -- Mac or DOS/Windows EOL
            Char := Next_Raw (File); -- Check for DOS/Windows EOL

            if Char /= Ada.Characters.Latin_1.LF then
               Undo_Read (File => File);
            end if;
         end if;
      end loop Find_Item;
   end Next;

   procedure Write (File : in out File_Handle; Item : in Character) is
      -- Empty
   begin -- Write
      File.Write (Value => Character'Pos (Item) );
   end Write;

   procedure Read (File : in out File_Handle; Item : out String) is
      -- Empty
   begin -- Read
      Get_All : for C of Item loop
         C := Next (File);
      end loop Get_All;
   end Read;

   procedure Write (File : in out File_Handle; Item : in String) is
      -- Empty
   begin -- Write
      All_Characters : for C of Item loop
         Write (File => File, Item => C);
      end loop All_Characters;
   end Write;

   function Next_Line (File : in out File_Handle) return String is
      Line : String (1 .. 1000);
      Last : Natural;
   begin -- Next_Line
      Read_Line (File => File, Item => Line, Last => Last);

      if Last < Line'Last then
         return Line (Line'First .. Last);
      end if;

      return Line & Next_Line (File);
   end Next_Line;

   procedure Read_Line (File : in out File_Handle; Item : out String; Last : out Natural) is
      -- Empty
   begin -- Read_Line
      Last := 0;

      Get_Characters : for I in Item'Range loop
         if End_Of_Line (File) then
            Skip_Line (File => File);

            return;
         end if;

         Item (I) := Next_Raw (File);
         Last := I;
      end loop Get_Characters;
   exception -- Read_Line
   when Ada.IO_Exceptions.End_Error =>
      if Last < Item'First then
         raise;
      end if; -- Otherwise we have a final line without a line terminator, and that line is in Item (Item'First .. Last)
   end Read_Line;

   procedure Write_Line (File : in out File_Handle; Item : in String) is
      -- Empty
   begin -- Write_Line
      Write (File => File, Item => Item);
      New_Line (File => File);
   end Write_Line;

   function Next_Raw (File : in out File_Handle) return Character is
      Result : Byte;
   begin -- Next_Raw
      Byte_IO.Read (File => File.Handle, Item => Result);

      return Character'Val (Result);
   end Next_Raw;

   procedure Undo_Read (File : in out File_Handle) is
      -- Empty
   begin -- Undo_Read
      File.Set_Position (Position => File.Position - 1);
   end Undo_Read;
end Controlled_IO.Text;
