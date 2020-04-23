(*
受理状態になっているかを確かめる関数
*)
let is_F q_list f_list =
  f_list
  |> List.map (fun f -> List.exists (fun q -> String.equal f q) q_list)
  |> List.exists (fun b -> b)


(*偏移関数のデータを基に実際に偏移した後の状態のリストを作成する*)
(*
偏移関数のデータの中身は
  - 移動前の状態名
  - 文字列
  - 移動後の状態名
*)
let rec f1 (delta_lst: (string * string * string list) list) (key:string) (q:string) =
  let key_after_lst =
    let f (b,k,_) =
      String.equal b q (*移動前の状態名のチェック*)
      &&
      String.equal k key (*文字列のチェック*)
    in
    delta_lst
    |> List.filter f
    |> List.map (fun (_,_,a) -> a)
    |> List.concat
  in
  let epsilon_after_lst =
    let epsilon = "" in
    let f (b,k,_) =
      String.equal b q (*移動前の状態名のチェック*)
      &&
      String.equal k epsilon (*εであるかのチェック*)
    in
    delta_lst
    |> List.filter f
    |> List.map (fun (_,_,a) -> a)
    |> List.concat
  in
  List.append key_after_lst epsilon_after_lst


(*等しいかを判定するデータをリストを貰って重複していないリストを作成*)
let overlapping_delete (f: 'a -> 'a -> bool) (lst: 'a list) =
  let rec sub (main_lst: 'a list) (data_lst: 'a list) =
    match data_lst with
    | [] -> main_lst
    | x :: xs ->
      if List.exists (f x) main_lst then
        sub main_lst xs (*既存データ*)
      else
        sub (x::main_lst) xs (*新規データ*)
  in
  sub [] lst


(*
  1. 初期状態
  2. 偏移関数のリスト
  3. 処理文字列
  4. 受理状態のリスト
を受け取って最終的に真偽値を返す
*)
let main (q0,delta_list,target,f_lst) =
  let q_lst =(*最終的な状態の集合*)
    let rec sub (target:string list) (lst:string list) =(*文字のリストと状態のリストを受け取る*)
      match target with
      | [] -> lst (*処理する文字列が無くなったら終了*)
      | key :: xs ->
        lst
        |> List.map (f1 delta_list key) (*新しい状態のリストのリストを作る*)
        |> List.concat
        |> overlapping_delete String.equal (*重複削除*)
        |> sub xs
    in
    sub target q0(*初期状態を与える*)
  in
  is_F q_lst f_lst