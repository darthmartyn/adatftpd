with
Ada.Streams,
Ada.Strings.Unbounded,
From_Bytes_To_U16,
GNAT.Sockets,
Interfaces,
Send_TFTP_Data_Block,
Session_Storage
;

procedure Process_ACK(
   Server      : in GNAT.Sockets.Socket_Type;
   From_Client : in GNAT.Sockets.Sock_Addr_Type;
   Data        : in Ada.Streams.Stream_Element_Array
)
is

   use type Session_Storage.Session_Storage_Type.Cursor;
   use type Interfaces.Unsigned_16;
   use type Ada.Streams.Stream_Element_Offset;

   Existing_Session : Session_Storage.Session_Type :=
      (Client                => From_Client,  -- primary key !
       Bytes_Sent            => 0,
       Expected_Block_Number => 0,
       Filename              => Ada.Strings.Unbounded.To_Unbounded_String("")
      );

   Existing_Session_Cursor : constant Session_Storage.Session_Storage_Type.Cursor :=
      Session_Storage.Session_Storage_Type.Find(
         Container => Session_Storage.Sessions,
         Item      => Existing_Session
      );

   Existing_Session_Found : constant Boolean :=
      (Existing_Session_Cursor /= Session_Storage.Session_Storage_Type.No_Element);

   ACK_Block_Number : constant Interfaces.Unsigned_16 := From_Bytes_To_U16(From => Data(Data'First..Data'First+1));

begin

   if Existing_Session_Found then

      Existing_Session := Session_Storage.Session_Storage_Type.Element(Position => Existing_Session_Cursor);

      if ACK_Block_Number = Existing_Session.Expected_Block_Number then

         Send_TFTP_Data_Block(
            From_Server    => Server,
            To_Client      => From_Client,
            Filename       => Ada.Strings.Unbounded.To_String(Existing_Session.Filename),
            Block_Number   => Existing_Session.Expected_Block_Number,
            Bytes_Sent     => Existing_Session.Bytes_Sent
         );

         Session_Storage.Session_Storage_Type.Replace_Element(
            Container => Session_Storage.Sessions,
            Position  => Existing_Session_Cursor,
            New_Item  => Existing_Session
         );

      else

        -- Session is out of sync.

        null;

      end if;

   end if;

end Process_ACK;
