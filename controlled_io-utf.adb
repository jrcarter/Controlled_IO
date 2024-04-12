-- Universal Text Files (UTF) that are opened/created at declaration and closed when finalized
-- Copyright (C) by PragmAda Software Engineering
-- Released under the terms of the BSD 3-Clause license; see https://opensource.org/licenses

with System;

package body Controlled_IO.UTF is
   Base : constant := 128;

   -- Numbers in UTF are encoded as base-Base digits in little-endian format
   -- All bytes except the one containing the MSD have their MSBs set to one (= digit + Base),
   -- so ASCII characters are encoded as themselves
   -- Since Base ** 3 = 2 ** 21, all Unicode characters can be encoded in 3 bytes

   type Big is mod System.Max_Binary_Modulus;

   function Read (File : in Byte_IO.File_Type) return Big;
   -- Reads an encoded value from File

   procedure Write (File : in Byte_IO.File_Type; Value : in Big);
   -- Writes Value to File encoded as a sequence of base-Base digits

   procedure Put_Line (File : in out File_Handle; Item : in Wide_Wide_String) is
      -- Empty
   begin -- Put_Line
      Write (File => File.Handle, Value => Item'Length);

      All_Characters : for C of Item loop
         Write (File => File.Handle, Value => Wide_Wide_Character'Pos (C) );
      end loop All_Characters;
   end Put_Line;

   function Next_Line (File : in out File_Handle) return Wide_Wide_String is
      -- Empty
   begin -- Next_Line
      Create_Line : declare
         Result : Wide_Wide_String (1 .. Natural (Read (File.Handle) ) );
      begin -- Create_Line
         Read_All : for I in Result'Range loop
            Result (I) := Wide_Wide_Character'Val (Read (File.Handle) );
         end loop Read_All;

         return Result;
      end Create_Line;
   end Next_Line;

   use type Byte;

   function Read (File : in Byte_IO.File_Type) return Big is
      Result : Big := 0;
      Byt    : Byte;
      Mult   : Big := 1;
   begin -- Read
      All_Digits : loop
         Byte_IO.Read (File => File, Item => Byt);
         Result := Result + Mult * Big (if Byt < Base then Byt else Byt - Base);
         Mult := Base * Mult;

         exit All_Digits when Byt < Base;
      end loop All_Digits;

      return Result;
   end Read;

   procedure Write (File : in Byte_IO.File_Type; Value : in Big) is
      Source : Big := Value;
      Byt    : Byte;
   begin -- Write
      All_Digits : loop
         Byt := Byte (Source rem Base) + (if Source < Base then 0 else Base);
         Byte_IO.Write (File => File, Item => Byt);

         exit All_Digits when Source < Base;

         Source := Source / Base;
      end loop All_Digits;
   end Write;
end Controlled_IO.UTF;
