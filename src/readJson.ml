open Yojson
open Yojson.Basic
open Yojson.Basic.Util

open Error

let to_bool = Yojson.Basic.Util.to_bool

let to_int = Yojson.Basic.Util.to_int

let to_float = Yojson.Basic.Util.to_float

let to_string = Yojson.Basic.Util.to_string

let to_list = Yojson.Basic.Util.to_list

let get tag json = Yojson.Basic.Util.member tag json

let from_file path =
  Yojson.Basic.from_file path



let str_to_strlst str =
  let len = String.length str in
  let rec sub n lst =
    if n < 0 then
      lst
    else
      sub (n - 1) (str.[n] :: lst)
  in
  sub (len - 1) []
  |> List.map (fun c -> String.make 1 c)

(*
ファイル名を受け取って
  - 遷移関数のリスト
  - 処理文字列リスト
を作る
*)
(*
遷移関数の表現は
(移動前の状態,文字列,移動後の状態)
JSONでは
{
  delta : [
    {
      before : "0"
      key : "a"
      after : "1"
    },
    {
      before : "1"
      key : "b"
      after : "2"
    }
  ]
}
みたいな感じ
*)
(*
移動文字は
{
  target : "ababaaab"
}
みたいな感じ
*)


let get_delta_data json =
  let before_str =
    json
    |> get "before"
    |> to_string
  in
  let key_str =
    json
    |> get "key"
    |> to_string
  in
  let after_str =
    json
    |> get "after"
    |> to_list
    |> List.map to_string
  in
    (before_str, key_str, after_str)

let parse file_name =
  let json = from_file file_name in
  let q0 =(*初期状態*)
    json
    |> get "q0"
    |> to_list
    |> List.map to_string
  in
  let target =(*処理する文字列*)
    json
    |> get "target"
    |> to_string
    |> str_to_strlst
  in
  let delta_list =(*遷移関数のリスト*)
    json
    |> get "delta"
    |> to_list
    |> List.map get_delta_data
  in
  let f_lst =(*受理状態の集合*)
    json
    |> get "F"
    |> to_list
    |> List.map to_string
  in
    (q0,delta_list,target,f_lst)
