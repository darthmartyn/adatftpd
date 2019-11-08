with Ada.Containers.Doubly_Linked_Lists, Ada.Direct_IO, Ada.Directories, Ada
  .Streams, Ada.Strings.Unbounded, Ada
  .Text_IO, Interfaces, Socket_Layer, Unchecked_Conversion;

package body adatftpd is

   --  Package Body Private Constants

   TFTP_RRQ   : constant Interfaces.Unsigned_16 := 16#0001#;
   TFTP_DATA  : constant Interfaces.Unsigned_16 := 16#0003#;
   TFTP_ACK   : constant Interfaces.Unsigned_16 := 16#0004#;
   TFTP_ERROR : constant Interfaces.Unsigned_16 := 16#0005#;
   --  The above constant values comes from the TFTP protocol (revision 2)
   --  https://www.ietf.org/rfc/rfc1350.txt

   --  Package Body Private Instantiations

   package Byte_IO is new Ada.Direct_IO
     (Element_Type => Ada.Streams.Stream_Element);
   --  This package is used to read the bytes from a binary file

   --  Package Body Private Types

   type Session_Type is record
      Client                : Socket_Layer.Socket_Address_Type;
      Bytes_Sent            : Byte_IO.Count;
      Expected_Block_Number : Interfaces.Unsigned_16;
      Filename              : Ada.Strings.Unbounded.Unbounded_String;
   end record;

   function "=" (L, R : Session_Type) return Boolean is
     (Socket_Layer."=" (L.Client, R.Client));

   package Session_Storage_Type is new Ada.Containers.Doubly_Linked_Lists
     (Session_Type, "=");

   --  Package Body Private Global Variables

   Sessions : Session_Storage_Type.List;

   --  Package Body Private Subprogram Specifications

   function Find_String_In_Bytes
     (Data : Ada.Streams.Stream_Element_Array) return String;

   function Convert_Bytes_To_String
     (Bytes : Ada.Streams.Stream_Element_Array) return String with
      Post => Convert_Bytes_To_String'Result'Length = Bytes'Length;

   function From_Bytes_To_U16
     (From : Ada.Streams.Stream_Element_Array) return
      Interfaces.Unsigned_16 with
      Pre => From'Length = 2;

   function From_U16_To_Bytes
     (From : Interfaces.Unsigned_16) return
      Ada.Streams.Stream_Element_Array with
      Post => From_U16_To_Bytes'Result'Length = 2;

   procedure Send_TFTP_Error
     (From_Server : Socket_Layer.Socket_Type;
      To_Client   : Socket_Layer.Socket_Address_Type;
      Error_Data  : Ada.Streams.Stream_Element_Array);

   procedure Print_Datagram (Datagram : Ada.Streams.Stream_Element_Array);
   pragma Unreferenced (Print_Datagram);

   procedure Process_ACK
     (Server      : Socket_Layer.Socket_Type;
      From_Client : Socket_Layer.Socket_Address_Type;
      Data        : Ada.Streams.Stream_Element_Array);

   procedure Process_Client_Error;

   procedure Process_RRQ
     (Server      : Socket_Layer.Socket_Type;
      From_Client : Socket_Layer.Socket_Address_Type;
      Data        : Ada.Streams.Stream_Element_Array);

   function Read_TFTP_File_Block
     (From_File : Byte_IO.File_Type; At_Index : Byte_IO.Positive_Count)
      return Ada.Streams.Stream_Element_Array;

   procedure Send_TFTP_Data_Block
     (From_Server : Socket_Layer.Socket_Type;
      To_Client   : Socket_Layer.Socket_Address_Type; Filename : String;

      Block_Number : in out Interfaces.Unsigned_16;
      --  Either incremented by 1, or if 65535 then set to 1

      Bytes_Sent : in out Byte_IO.Count
      --  Incremenets by either 512 or the amount of the last
      --  block that is less than 512 bytes in size
      );

   --  Package Body Private Subprogram Implementations

   function Find_String_In_Bytes
     (Data : Ada.Streams.Stream_Element_Array) return String is separate;

   function Read_TFTP_File_Block
     (From_File : Byte_IO.File_Type; At_Index : Byte_IO.Positive_Count)
      return Ada.Streams.Stream_Element_Array is separate;

   procedure Print_Datagram
     (Datagram : Ada.Streams.Stream_Element_Array) is separate;

   function Convert_Bytes_To_String
     (Bytes : Ada.Streams.Stream_Element_Array) return String is separate;

   function From_Bytes_To_U16
     (From : Ada.Streams.Stream_Element_Array) return Interfaces
     .Unsigned_16 is separate;

   function From_U16_To_Bytes
     (From : Interfaces.Unsigned_16) return Ada.Streams.Stream_Element_Array
      is separate;

   procedure Send_TFTP_Error
     (From_Server : Socket_Layer.Socket_Type;
      To_Client   : Socket_Layer.Socket_Address_Type;
      Error_Data  : Ada.Streams.Stream_Element_Array) is separate;

   procedure Process_Client_Error is separate;

   procedure Process_ACK
     (Server      : Socket_Layer.Socket_Type;
      From_Client : Socket_Layer.Socket_Address_Type;
      Data        : Ada.Streams.Stream_Element_Array) is separate;

   procedure Process_RRQ
     (Server      : Socket_Layer.Socket_Type;
      From_Client : Socket_Layer.Socket_Address_Type;
      Data        : Ada.Streams.Stream_Element_Array) is separate;

   procedure Send_TFTP_Data_Block
     (From_Server  :        Socket_Layer.Socket_Type;
      To_Client    :    Socket_Layer.Socket_Address_Type; Filename : String;
      Block_Number : in out Interfaces.Unsigned_16;
      Bytes_Sent   : in out Byte_IO.Count) is separate;

   procedure Run is separate;

end adatftpd;
