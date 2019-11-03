with
Ada.Text_IO,
Ada.Streams
;

package Byte_Printer is new Ada.Text_IO.Modular_IO(Num => Ada.Streams.Stream_Element);
