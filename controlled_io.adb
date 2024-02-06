-- Binary files that are opened/created at declaration and closed when finalized
-- See the child package Text for text I/O
-- Copyright (C) by PragmAda Software Engineering
-- Released under the terms of the BSD 3-Clause license; see https://opensource.org/licenses

package body Controlled_IO is
   overriding procedure Finalize (Object : in out File_Handle) is
      -- Empty
   begin -- Finalize
      if Byte_IO.Is_Open (Object.Handle) then
         Byte_IO.Close (File => Object.Handle);
      end if;
   exception -- Finalize
   when others =>
      null;
   end Finalize;

   function Opened (Name : in String; Form : in String := "") return File_Handle is
      -- Empty
   begin -- Opened
      return File : File_Handle do
         Byte_IO.Open (File => File.Handle, Mode => Byte_IO.Inout_File, Name => Name, Form => Form);
      end return;
   end Opened;

   function Created (Name : in String; Form : in String := "") return File_Handle is
      -- Empty
   begin -- Created
      return File : File_Handle do
         Byte_IO.Create (File => File.Handle, Mode => Byte_IO.Inout_File, Name => Name, Form => Form);
      end return;
   end Created;

   procedure Set_Position (File : in out File_Handle; Position : in Position_Value) is
      -- Empty
   begin -- Set_Position
      Byte_IO.Set_Index (File => File.Handle, To => Byte_IO.Count (Position) );
   end Set_Position;

   function Next (File : in out File_Handle) return Byte is
      Result : Byte;
   begin -- Next
      Byte_IO.Read (File => File.Handle, Item => Result);

      return Result;
   end Next;

   procedure Read (File : in out File_Handle; List : out Byte_List) is
      -- Empty
   begin -- Read
      All_Bytes : for B of List loop
         B := Next (File);
      end loop All_Bytes;
   end Read;

   procedure Write (File : in out File_Handle; Value : in Byte) is
      -- Empty
   begin -- Write
      Byte_IO.Write (File => File.Handle, Item => Value);
   end Write;

   procedure Write (File : in out File_Handle; Value : in Byte_List) is
      -- Empty
   begin -- Write
      All_Bytes : for B of Value loop
         File.Write (Value => B);
      end loop All_Bytes;
   end Write;
end Controlled_IO;
