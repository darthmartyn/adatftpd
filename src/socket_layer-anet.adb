with GNAT.Sockets;

package body Socket_Layer is

   use GNAT.Sockets;

   function Setup_Server return Socket_Type is

      Server : Socket_Type := Socket_Type'First;

   begin

      return Server;

   end Setup_Server;

   procedure Shutdown_Server (Server : Socket_Type) is
   begin

      null;

   end Shutdown_Server;

   procedure Receive_Datagram
     (Socket : Socket_Type;
      Item   : out Ada.Streams.Stream_Element_Array;
      Last   : out Ada.Streams.Stream_Element_Offset;
      From   : out Socket_Address_Type)
   is
   begin

      null;

   end Receive_Datagram;

   procedure Send_Datagram
     (Socket : Socket_Type;
      Item   : Ada.Streams.Stream_Element_Array;
      Last   : out Ada.Streams.Stream_Element_Offset; To : Socket_Address_Type)
   is
   begin

      null;

   end Send_Datagram;

end Socket_Layer;
