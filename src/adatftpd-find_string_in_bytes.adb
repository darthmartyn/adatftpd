separate (adatftpd)
function Find_String_In_Bytes(
   Data : in Ada.Streams.Stream_Element_Array
) return String
is

   use type Ada.Streams.Stream_Element_Offset;
   use type Ada.Streams.Stream_Element;

   Last_Char : Ada.Streams.Stream_Element_Offset := Data'First;
   String_End_Found : Boolean := Data(Last_Char) = 0;

begin

   while not String_End_Found and then Last_Char /= Data'Last
   loop

      Last_Char := Ada.Streams.Stream_Element_Offset'Succ(Last_Char);

      String_End_Found := Data(Last_Char) = 0;

   end loop;

   return (
      if String_End_Found then
        Convert_Bytes_To_String(Bytes => Data(Data'First..Last_Char-1))
      else
        ""

   );

end Find_String_In_Bytes;
