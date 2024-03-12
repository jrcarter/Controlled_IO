-- Binary files that are opened/created at declaration and closed when finalized
-- See the child package Text for text I/O
-- Copyright (C) by PragmAda Software Engineering
-- Released under the terms of the BSD 3-Clause license; see https://opensource.org/licenses

with Ada.Directories;
with Interfaces;

private with Ada.Finalization;
private with Ada.Direct_IO;

package Controlled_IO is
   type File_Handle (<>) is tagged limited private;
   -- Opened/created on creation, closed on finalization
   -- Can be both read and written

   use type Ada.Directories.File_Kind;

   function Opened (Name : in String; Form : in String := "") return File_Handle with
      Pre  => Ada.Directories.Exists (Name) and then Ada.Directories.Kind (Name) = Ada.Directories.Ordinary_File,
      Post => Opened'Result.Position = 1;
   -- Opens an existing file

   function Created (Name : in String; Form : in String := "") return File_Handle with
      Post => Created'Result.Position = 1;
   -- Creates a new file named Name (deleting any existing file named Name)

   function Opened_Or_Created (Name : in String; Form : in String := "") return File_Handle is
      (if Ada.Directories.Exists (Name) then Opened (Name, Form) else Created (Name, Form) );

   function End_Of_File (File : in File_Handle) return Boolean;
   -- Returns File.Position > File.Size

   subtype Byte is Interfaces.Unsigned_8;
   type Byte_List is array (Positive range <>) of Byte;

   type Count_Value is mod 2 ** 64;
   subtype Position_Value is Count_Value range 1 .. Count_Value'Last;

   function Size (File : in File_Handle) return Count_Value;
   -- Returns the current number of bytes in File

   procedure Set_Position (File : in out File_Handle; Position : in Position_Value) with
      Pre => Position in 1 .. File.Size + 1;
   -- Sets the current position of File to Position

   function Position (File : in File_Handle) return Position_Value;
   -- Returns the current position in File

   function Next (File : in out File_Handle) return Byte with
      Pre => not File.End_Of_File;
   -- Returns the byte in File at the current position and increments the current position

   procedure Read (File : in out File_Handle; List : out Byte_List) with
      Pre => not File.End_Of_File;
   -- Calls File.Next for every Byte in List
   -- Raises Ada.IO_Exceptions.End_Error if there are fewer than List'Length bytes left in File

   procedure Write (File : in out File_Handle; Value : in Byte);
   -- Writes Value to File at the current position and increments the current position

   procedure Write (File : in out File_Handle; Value : in Byte_List);
   -- Calls File.Write for every Byte in Value
private -- Controlled_IO
   package Byte_IO is new Ada.Direct_IO (Element_Type => Byte);

   type File_Handle is new Ada.Finalization.Limited_Controlled with record
      Handle : Byte_IO.File_Type;
   end record;

   overriding procedure Finalize (Object : in out File_Handle);

   function End_Of_File (File : in File_Handle) return Boolean is
      (Byte_IO.End_Of_File (File.Handle) );

   function Size (File : in File_Handle) return Count_Value is
      (Count_Value (Byte_IO.Size (File.Handle) ) );

   function Position (File : in File_Handle) return Position_Value is
      (Position_Value (Byte_IO.Index (File.Handle) ) );
end Controlled_IO;
