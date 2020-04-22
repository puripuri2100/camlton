open Yojson
open Yojson.Basic
open Yojson.Basic.Util


val to_bool : Yojson.Basic.json -> bool

val to_int : Yojson.Basic.json -> int

val to_float : Yojson.Basic.json -> float

val to_string : Yojson.Basic.json -> string

val to_list : Yojson.Basic.json -> Yojson.Basic.json list

val get : string -> Yojson.Basic.json -> Yojson.Basic.json

val from_file : string -> Yojson.Basic.json


val parse : string -> (string list * (string * string * string list) list * string list * string list)
