val is_F : string list -> string list -> bool

val f1 : (string * string * string list) list -> string -> string -> string list

val overlapping_delete : ('a -> 'a -> bool) -> 'a list -> 'a list

val main : (string list * (string * string * string list) list * string list * string list) -> bool