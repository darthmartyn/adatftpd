with
Ada.Directories,
Ada.Streams,
Ada.Strings.Unbounded,
Byte_IO,
Find_String_In_Bytes,
GNAT.Sockets,
Interfaces,
Send_TFTP_Data_Block,
Send_TFTP_Error,
Session_Storage,
TFTP_Types,
Unchecked_Conversion
;

procedure Process_RRQ(
   Server      : in GNAT.Sockets.Socket_Type;
   From_Client : in GNAT.Sockets.Sock_Addr_Type;
   Data        : in Ada.Streams.Stream_Element_Array
)
is

   use type Ada.Streams.Stream_Element_Offset;
   use type Ada.Directories.File_Size;
   use type TFTP_Types.TFTP_Error_Type;

   Filename_String : constant String := Find_String_In_Bytes(Data => Data);

   Start_Of_Mode_String : constant Ada.Streams.Stream_Element_Offset :=
      (3 + Filename_String'Length + 1);
   -- mode starts 1 characters after the \0 character that terminated the filename

   Mode_String : constant String := Find_String_In_Bytes(Data => Data(Start_Of_Mode_String..Data'Last));

   File_Exists : constant Boolean := Ada.Directories.Exists(Filename_String);

begin

   if File_Exists
      and then
      Mode_String = "octet"
      -- only support binary file transfers
      and then
      Ada.Directories.Size(Name => Filename_String) > 0
   then

      declare

         Block_Number : Interfaces.Unsigned_16 := 0;
         Bytes_Sent : Byte_IO.Count := 0;

      begin

         Send_TFTP_Data_Block(
            From_Server  => Server,
            To_Client    => From_Client,
            Filename     => Filename_String,
            Block_Number => Block_Number,
            Bytes_Sent   => Bytes_Sent
         );

         declare

            use type Session_Storage.Session_Storage_Type.Cursor;

            New_Session : constant Session_Storage.Session_Type := (
               Client                => From_Client,
               Bytes_Sent            => Bytes_Sent,
               Expected_Block_Number => Block_Number,
               Filename              => Ada.Strings.Unbounded.To_Unbounded_String(Filename_String)
            );

            Previous_Session : constant Session_Storage.Session_Storage_Type.Cursor :=
               Session_Storage.Session_Storage_Type.Find(
                  Container => Session_Storage.Sessions,
                  Item      => New_Session
               );

            Previous_Session_Found : constant Boolean :=
               (Previous_Session /= Session_Storage.Session_Storage_Type.No_Element);

         begin

            if Previous_Session_Found then

               Session_Storage.Session_Storage_Type.Replace_Element(
                  Container => Session_Storage.Sessions,
                  Position  => Previous_Session,
                  New_Item  => New_Session
               );

            else

               Session_Storage.Session_Storage_Type.Append(
                  Container => Session_Storage.Sessions,
                  New_Item  => New_Session
               );

            end if;

         end;

      end;

   else

      Send_TFTP_Error(
        From_Server => Server,
        To_Client   => From_Client,
        Error_Type  => (if not File_Exists then TFTP_Types.ILLEGAL_OPERATION else TFTP_Types.FILE_NOT_FOUND)
      );

   end if;

end Process_RRQ;
