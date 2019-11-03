with
Ada.Streams,
Ada.Text_IO,
Byte_Printer
;

procedure Print_Datagram(Datagram : Ada.Streams.Stream_Element_Array)
is
begin

   for I in Datagram'Range loop
      Byte_Printer.Put(Datagram(I));  Ada.Text_IO.Put(" ");
   end loop;

   Ada.Text_IO.New_Line;

end Print_Datagram;
