with
Interfaces,
TFTP_Types
;

function From_Bytes_To_U16(From : in TFTP_Types.Two_Byte_Array) return Interfaces.Unsigned_16
is
   use type Interfaces.Unsigned_16;
begin

   return (
      Interfaces.Shift_Left(Interfaces.Unsigned_16(From(From'First)),8)
      +
      Interfaces.Unsigned_16(From(From'Last)) and 16#00FF#
   );

end From_Bytes_To_U16;
