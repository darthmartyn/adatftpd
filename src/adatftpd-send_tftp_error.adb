separate (adatftpd)
procedure Send_TFTP_Error(
   From_Server : in Socket_Layer.Socket_Type;
   To_Client   : in Socket_Layer.Socket_Address_Type;
   Error_Data  : in Ada.Streams.Stream_Element_Array
) is

   use type Ada.Streams.Stream_Element_Array;

   Null_Terminator : constant Ada.Streams.Stream_Element_Array := (1 => 0);

   Datagram : constant Ada.Streams.Stream_Element_Array :=
     (From_U16_To_Bytes(16#0005#) & Error_Data & Null_Terminator);

   Last_Sent : Ada.Streams.Stream_Element_Offset;

begin

   Socket_Layer.Send_Datagram(
      Socket => From_Server,
      Item   => Datagram,
      Last   => Last_Sent,
      To     => To_Client
   );

end Send_TFTP_Error;
