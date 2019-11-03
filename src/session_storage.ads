with
Ada.Containers.Doubly_Linked_Lists,
GNAT.Sockets,
Ada.Strings.Unbounded,
Byte_IO,
Interfaces
;

package Session_Storage is

   type Session_Type is record
      Client                : GNAT.Sockets.Sock_Addr_Type;
      Bytes_Sent            : Byte_IO.Count;
      Expected_Block_Number : Interfaces.Unsigned_16;
      Filename              : Ada.Strings.Unbounded.Unbounded_String;
   end record;

   function "="(L,R : Session_Type) return Boolean is (GNAT.Sockets."="(L.Client,R.Client));

   package Session_Storage_Type is new Ada.Containers.Doubly_Linked_Lists(Session_Type,"=");

   Sessions : Session_Storage_Type.List;

end Session_Storage;
