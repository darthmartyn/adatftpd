with
Ada.Streams,
Interfaces
;

package TFTP_Types is

   TFTP_RRQ   : constant Interfaces.Unsigned_16 := 16#0001#;
   TFTP_WRQ   : constant Interfaces.Unsigned_16 := 16#0002#;
   TFTP_DATA  : constant Interfaces.Unsigned_16 := 16#0003#;
   TFTP_ACK   : constant Interfaces.Unsigned_16 := 16#0004#;
   TFTP_ERROR : constant Interfaces.Unsigned_16 := 16#0005#;

   type TFTP_Error_Type is (FILE_NOT_FOUND, ILLEGAL_OPERATION);

   subtype Two_Byte_Array is Ada.Streams.Stream_Element_Array(1..2);

end TFTP_Types;
