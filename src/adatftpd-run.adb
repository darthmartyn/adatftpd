separate (adatftpd)
procedure Run is

   Server   : Socket_Layer.Socket_Type;
   Watchdog : Natural := 0;

begin

   Sessions.Clear;

   Server := Socket_Layer.Setup_Server;

   loop

      declare

         Data : Ada.Streams.Stream_Element_Array (1 .. 65535);
         Last : Ada.Streams.Stream_Element_Offset;
         From : Socket_Layer.Socket_Address_Type;

         OpCode : Interfaces.Unsigned_16;

      begin

         Socket_Layer.Receive_Datagram (Server, Data, Last, From);

         OpCode := From_Bytes_To_U16 (From => Data (1 .. 2));

         case OpCode is

            when TFTP_RRQ =>

               Process_RRQ
                 (Server => Server, From_Client => From,
                  Data   => Data (3 .. Last));

            when TFTP_ACK =>

               Process_ACK
                 (Server => Server, From_Client => From,
                  Data   => Data (3 .. Last));

            when TFTP_ERROR =>

               Process_Client_Error;

            when others =>

               Send_TFTP_Error
                 (From_Server => Server, To_Client => From,
                  Error_Data  => From_U16_To_Bytes (16#0004#));

         end case;

      exception
         when Socket_Layer.Socket_Error =>
            Watchdog := Watchdog + 1;
            exit when Watchdog = 10;
      end;

   end loop;

   Socket_Layer.Shutdown_Server (Server => Server);

end Run;
