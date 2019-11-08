with GNAT.Sockets;

package body Socket_Layer is

   use GNAT.Sockets;

   function Setup_Server return Socket_Type is

      Server : Socket_Type;

   begin

      Create_Socket
        (Server, GNAT.Sockets.Family_Inet, GNAT.Sockets.Socket_Datagram);

      Set_Socket_Option (Server, Socket_Level, (Reuse_Address, True));

      Set_Socket_Option
        (Server, Socket_Level, (Receive_Timeout, Timeout => Forever));

      Bind_Socket (Server, (Family_Inet, Inet_Addr ("127.0.0.1"), 69));

      return Server;

   end Setup_Server;

   procedure Shutdown_Server (Server : Socket_Type) is
   begin

      Close_Socket (Socket => Server);

   end Shutdown_Server;

   procedure Receive_Datagram
     (Socket : Socket_Type;
      Item   : out Ada.Streams.Stream_Element_Array;
      Last   : out Ada.Streams.Stream_Element_Offset;
      From   : out Socket_Address_Type)
   is
   begin

      GNAT.Sockets.Receive_Socket
        (Socket => Socket, Item => Item, Last => Last, From => From);

   end Receive_Datagram;

   procedure Send_Datagram
     (Socket : Socket_Type;
      Item   : Ada.Streams.Stream_Element_Array;
      Last   : out Ada.Streams.Stream_Element_Offset; To : Socket_Address_Type)
   is
   begin

      GNAT.Sockets.Send_Socket
        (Socket => Socket, Item => Item, Last => Last, To => To);

   end Send_Datagram;

end Socket_Layer;
