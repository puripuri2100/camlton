exception Config_error of string

exception Option_error of string

type t =
  | Config
  | Option


let print_error (t:t) str =
  let err_title =
    match t with
    | Config -> "Config"
    | Option -> "Option"
  in
  Printf.printf "![%sError]\n%s\n" err_title str

let error_msg t =
  try
    t ()
  with
    | Config_error(msg) -> print_error Config msg
    | Option_error(msg) -> print_error Option msg