separate (adatftpd)
function Read_TFTP_File_Block
  (From_File : Byte_IO.File_Type; At_Index : Byte_IO.Positive_Count)
   return Ada.Streams.Stream_Element_Array
is

   use type Ada.Streams.Stream_Element_Offset;
   use type Byte_IO.Count;

   Bytes_Remaining_In_File : constant Ada.Streams.Stream_Element_Offset :=
     Ada.Streams.Stream_Element_Offset (Byte_IO.Size (From_File)) -
     Ada.Streams.Stream_Element_Offset (At_Index - 1);

   Block_Data : Ada.Streams.Stream_Element_Array
     (1 .. (if Bytes_Remaining_In_File > 512 then 512
            else Bytes_Remaining_In_File));

begin

   Byte_IO.Set_Index (File => From_File, To => At_Index);

   for I in Block_Data'Range loop
      Byte_IO.Read (File => From_File, Item => Block_Data (I));
   end loop;

   return Block_Data;

end Read_TFTP_File_Block;
