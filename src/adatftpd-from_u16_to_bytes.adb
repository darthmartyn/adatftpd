separate (adatftpd)
function From_U16_To_Bytes
  (From : Interfaces.Unsigned_16) return Ada.Streams.Stream_Element_Array
is
   use type Interfaces.Unsigned_16;
begin

   return (1 => Ada.Streams.Stream_Element (Interfaces.Shift_Right (From, 8)),
           2 => Ada.Streams.Stream_Element (From and 16#00FF#));

end From_U16_To_Bytes;
