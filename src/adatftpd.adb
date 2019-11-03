with
Ada.Streams,
From_Bytes_To_U16,
GNAT.Sockets,
Process_ACK,
Process_ERROR,
Process_RRQ,
Send_TFTP_Error,
Session_Storage,
TFTP_Types,
Unchecked_Conversion,
Interfaces,
Ada.Text_IO
;

use
GNAT.Sockets,
Session_Storage,
TFTP_Types
;

procedure adatftpd is

   Server : Socket_Type;
   Watchdog : Natural := 0;

begin

   Session_Storage.Sessions.Clear;

   Create_Socket(Server,GNAT.Sockets.Family_Inet,GNAT.Sockets.Socket_Datagram);
   Set_Socket_Option(Server,Socket_Level,(Reuse_Address, True));
   Set_Socket_Option(Server,Socket_Level,(Receive_Timeout,Timeout => Forever));

   Bind_Socket (Server, (Family_Inet,Inet_Addr ("127.0.0.1"),69));

   loop
      declare

         use type Ada.Streams.Stream_Element_Offset;

         Data : Ada.Streams.Stream_Element_Array (1..65535);
         Last : Ada.Streams.Stream_Element_Offset;
         From : Sock_Addr_Type;

         OpCode : Interfaces.Unsigned_16;

      begin

         GNAT.Sockets.Receive_Socket(Server, Data, Last, From);

         OpCode := From_Bytes_To_U16(From => Data(1..2));

         Ada.Text_IO.Put_Line(OpCode'Img);

         case OpCode is

            when TFTP_Types.TFTP_RRQ =>

               Process_RRQ(
                 Server      => Server,
                 From_Client => From,
                 Data        => Data(3..Last)
               );

            when TFTP_Types.TFTP_ACK =>

               Process_ACK(
                 Server      => Server,
                 From_Client => From,
                 Data        => Data(3..Last)
               );

            when TFTP_Types.TFTP_ERROR =>

               Process_ERROR;

            when others =>

               Send_TFTP_Error(
                  From_Server => Server,
                  To_Client   => From,
                  Error_Type  => TFTP_Types.ILLEGAL_OPERATION
               );

         end case;

      exception
         when Socket_Error =>
            Watchdog := Watchdog + 1;
            exit when Watchdog = 10;
      end;

   end loop;

   Close_Socket(Socket => Server);

end adatftpd;
