separate (adatftpd)
procedure Print_Datagram (Datagram : Ada.Streams.Stream_Element_Array) is

   package Byte_Printer is new Ada.Text_IO.Modular_IO
     (Num => Ada.Streams.Stream_Element);

begin

   for I in Datagram'Range loop
      Byte_Printer.Put (Datagram (I));
      Ada.Text_IO.Put (" ");
   end loop;

   Ada.Text_IO.New_Line;

end Print_Datagram;
