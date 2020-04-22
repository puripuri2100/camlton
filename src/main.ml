open Arg
open String
open Printf
open Filename

open ReadJson
open Error
open OptionState
open Camlton


let arg_version () =
  let () = OptionState.set_is_version true in
  print_string "camlton version 0.0.1\n"


let arg_config curdir s =
  let path =
    if Filename.is_relative s then
      Filename.concat curdir s
    else
      s
  in
  OptionState.set_config_file path


let arg_spec curdir =
  [
    ("-v",        Arg.Unit(arg_version)  , "Prints version");
    ("--version", Arg.Unit(arg_version)  , "Prints version");
    ("-c",      Arg.String (arg_config curdir), "Specify config file");
    ("--config",Arg.String (arg_config curdir), "Specify config file");
  ]


let main =
  Error.error_msg (fun () ->
    let curdir = Sys.getcwd () in
    let () = Arg.parse (arg_spec curdir) (arg_config curdir) "" in
    let config_file_name_opt = OptionState.config_file () in
    if OptionState.get_is_version () then
      ()
    else
      let config_file_name =
        match config_file_name_opt with
        | Some(s) -> s
        | None -> raise (Error.Option_error "設定ファイルを渡してください")
      in
      let main_bool =
        config_file_name
        |> ReadJson.parse
        |> Camlton.main
      in
      if main_bool then
        Printf.printf "%s\n" "true"
      else
        Printf.printf "%s\n" "false"
  )
