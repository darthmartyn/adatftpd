separate (adatftpd)
procedure Process_Client_Error (From_Client : Socket_Layer.Socket_Address_Type)
is

   Existing_Session : Session_Type :=
     (Client   => From_Client, Bytes_Sent => 0, Expected_Block_Number => 0,
      Filename => Ada.Strings.Unbounded.To_Unbounded_String (""));

   Existing_Session_Cursor : Session_Storage_Type.Cursor :=
     Session_Storage_Type.Find
       (Container => Sessions, Item => Existing_Session);

   Existing_Session_Found : constant Boolean :=
     (Existing_Session_Cursor /= Session_Storage_Type.No_Element);

begin

   if Existing_Session_Found then
   --  The client reporting the error was mid-transfer.
   --  Remove the client from the Sessions store.
   --  No response is made to the client.

      Session_Storage_Type.Delete
        (Container => Sessions, Position => Existing_Session_Cursor);

   end if;

end Process_Client_Error;
