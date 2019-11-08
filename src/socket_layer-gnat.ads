with
Ada.Streams,
GNAT.Sockets
;

package Socket_Layer is

   subtype Socket_Type is GNAT.Sockets.Socket_Type;

   subtype Socket_Address_Type is GNAT.Sockets.Sock_Addr_Type;

   function "="(L, R : Socket_Address_Type) return Boolean renames GNAT.Sockets."=";

   subtype Request_Flag_Type is GNAT.Sockets.Request_Flag_Type;

   Socket_Error : exception;

   function Setup_Server return Socket_Type;

   procedure Shutdown_Server(Server : Socket_Type);

   procedure Receive_Datagram(
      Socket : Socket_Type;
      Item   : out Ada.Streams.Stream_Element_Array;
      Last   : out Ada.Streams.Stream_Element_Offset;
      From   : out Socket_Address_Type
   );

   procedure Send_Datagram(
      Socket : Socket_Type;
      Item   : Ada.Streams.Stream_Element_Array;
      Last   : out Ada.Streams.Stream_Element_Offset;
      To     : Socket_Address_Type
   );

end Socket_Layer;
