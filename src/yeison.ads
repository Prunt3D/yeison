private with Ada.Containers.Indefinite_Ordered_Maps;
private with Ada.Containers.Indefinite_Vectors;
private with Ada.Finalization;
private with Ada.Strings.Unbounded;
private with Ada.Numerics.Big_Numbers.Big_Integers;

package Yeison with Preelaborate is

   type Abstract_Value is tagged private with
     Integer_Literal => To_Int,
     String_Literal  => To_Str;

   function Image (V : Abstract_Value) return String;

   subtype Any is Abstract_Value'Class;

   function To_Int (Img : String) return Abstract_Value;
   function To_Str (Img : Wide_Wide_String) return Abstract_Value;

   type Int is new Abstract_Value with private with
     Integer_Literal => To_Int;

   overriding function Image (V : Int) return String;

   overriding function To_Int (S : String) return Int;
   overriding function To_Str (S : Wide_Wide_String) return Int is (raise Constraint_Error);

   type Str is new Abstract_Value with private
     with String_Literal => To_Str;

   overriding function Image (V : Str) return String;

   overriding function To_Int (S : String) return Str is (raise Constraint_Error);
   overriding function To_Str (Img : Wide_Wide_String) return Str;

   type Map is new Abstract_Value with private with
     Aggregate => (Empty     => Empty,
                   Add_Named => Insert);

   function Empty return Map;

   overriding function Image (V : Map) return String;

   procedure Insert (This  : in out Map;
                     Key   : String;
                     Value : Abstract_Value'Class);

   overriding function To_Int (S : String) return Map;
   overriding function To_Str (S : Wide_Wide_String) return Map;

   type Vec is new Abstract_Value with private with
     Aggregate => (Empty          => Empty,
                   Add_Unnamed    => Append);

   function Empty return Vec;

   overriding function Image (V : Vec) return String;

   procedure Append (This : in out Vec; Value : Abstract_Value'Class);

   overriding function To_Int (S : String) return Vec;
   overriding function To_Str (S : Wide_Wide_String) return Vec;

private

   type Ptr is access all Abstract_Value'Class;

   type Abstract_Value is new Ada.Finalization.Controlled with record
      Concrete : Ptr;
   end record;

   overriding procedure Adjust (V : in out Abstract_Value);
   overriding procedure Finalize (V : in out Abstract_Value);

   type Int is new Abstract_Value with record
      Value : Ada.Numerics.Big_Numbers.Big_Integers.Big_Integer;
   end record;

   type Str is new Abstract_Value with record
      Value : Ada.Strings.Unbounded.Unbounded_String;
   end record;

   package Maps is new Ada.Containers.Indefinite_Ordered_Maps (String, Abstract_Value'Class);

   type Map is new Abstract_Value with record
      Value : Maps.map;
   end record;

   package Vectors is new Ada.Containers.Indefinite_Vectors (Positive, Abstract_Value'Class);

   type Vec is new Abstract_Value with record
      Value : Vectors.Vector;
   end record;

end Yeison;