with
Ada.Streams,
From_U16_To_Bytes,
GNAT.Sockets,
TFTP_Types
;

procedure Send_TFTP_Error(
   From_Server : in     GNAT.Sockets.Socket_Type;
   To_Client   : in     GNAT.Sockets.Sock_Addr_Type;
   Error_Type  : in     TFTP_Types.TFTP_Error_Type
) is

   use type Ada.Streams.Stream_Element_Array;
   use type TFTP_Types.TFTP_Error_Type;

   Null_Terminator : constant Ada.Streams.Stream_Element_Array := (1 => 0);

   Datagram : constant Ada.Streams.Stream_Element_Array :=
     From_U16_To_Bytes(16#0005#)
     &
     From_U16_To_Bytes((if Error_Type = TFTP_Types.FILE_NOT_FOUND then 16#0001# else 16#0004#))
     &
     Null_Terminator;

   Last_Sent : Ada.Streams.Stream_Element_Offset;

begin

   GNAT.Sockets.Send_Socket(
      Socket => From_Server,
      Item   => Datagram,
      Last   => Last_Sent,
      To     => To_Client
   );

end Send_TFTP_Error;
