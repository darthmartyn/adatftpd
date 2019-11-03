with
Ada.Streams,
Unchecked_Conversion
;

function Convert_Bytes_To_String(Bytes : Ada.Streams.Stream_Element_Array) return String
is

   subtype Byte_Slice is Ada.Streams.Stream_Element_Array(Bytes'Range);
   subtype Char_Slice is String(1..Bytes'Length);

   function UCV is new
     Unchecked_Conversion(Source => Byte_Slice, Target => Char_Slice);

begin
   return UCV(bytes);
end Convert_Bytes_To_String;
