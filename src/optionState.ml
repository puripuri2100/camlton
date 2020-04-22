type state = {
  mutable config_file : string option;
  mutable is_version : bool;
}

let state = {
  config_file = None;
  is_version = false;
}

let set_config_file path = state.config_file <- Some(path)
let config_file () = state.config_file

let set_is_version b = state.is_version <- b
let get_is_version () = state.is_version
