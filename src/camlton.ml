let debug s lst =
  let paren s =
    "[" ^ s ^ "]"
  in
  let rec sub lst =
    match lst with
    | [] -> ""
    | x::[] -> x
    | x :: xs -> x ^ "; " ^ sub xs
  in
    Printf.printf "%s : %s\n" s (lst |> sub |> paren)


(*
受理状態になっているかを確かめる関数
*)
let is_F q_list f_list =
  f_list
  |> List.map (fun f -> List.exists (fun q -> String.equal f q) q_list)
  |> List.exists (fun b -> b)



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


(*偏移関数のデータを基に実際に偏移した後の状態のリストを作成する*)
(*
偏移関数のデータの中身は
  - 移動前の状態名
  - 文字列
  - 移動後の状態名
*)

(*ε遷移だけをする関数を作成*)
let rec f_epsilon (delta_lst: (string * string * string list) list) (q:string) =
  let epsilon = "" in
  let epsilon_f q (b,k,_) =(*εであるかを判定する関数*)
    String.equal b q (*移動前の状態名のチェック*)
    &&
    String.equal k epsilon (*εであるかのチェック*)
  in
  let rec sub lst =(*ε遷移できる遷移先が消滅するまでε遷移を続ける*)
    let q_lst = (*ε遷移した先を作成する*)
      lst
      |> List.map (fun q -> List.filter (epsilon_f q) delta_lst) (*状態のリストに対して、ε遷移できるかの検索*)
      |> List.concat
      |> List.map (fun (_,_,a) -> a) (*状態のリストだけを取り出す*)
      |> List.concat
      |> overlapping_delete String.equal
    in
    let len_old_lst = List.length lst in (*遷移確定のリスト*)
    let new_lst =(*新規に遷移することがわかったリストを結合して重複を省く*)
      List.append lst q_lst
      |> overlapping_delete String.equal
    in
    let len_new_lst = List.length new_lst in
    if len_new_lst > len_old_lst then(*作成したεで遷移できる先のリストをチェックする*)
      (*遷移先がまだある*)
      List.append lst (sub q_lst) (*既存の遷移先と新たな遷移先を結合*)
    else
      (*新規遷移先無し*)
      lst
  in
  sub [q]


(*通常の遷移*)
let rec f1 (delta_lst: (string * string * string list) list) (key:string) (q:string) =
  let key_after_lst =
    let f q (b,k,_) =
      String.equal b q (*移動前の状態名のチェック*)
      &&
      String.equal k key (*文字列のチェック*)
    in
    delta_lst
    |> List.filter (f q)
    |> List.map (fun (_,_,a) -> a)
    |> List.concat
  in
  key_after_lst


(*
  1. 初期状態
  2. 偏移関数のリスト
  3. 処理文字列
  4. 受理状態のリスト
を受け取って最終的に真偽値を返す
*)
let main (q0_lst,delta_list,target,f_lst) =
  let q_lst =(*最終的な状態の集合*)
    let rec sub (target:string list) (lst:string list) =(*文字のリストと状態のリストを受け取る*)
      let () = debug "現状態" lst in
      match target with
      | [] -> lst (*処理する文字列が無くなったら終了*)
      | key :: xs ->
        let () = Printf.printf "key : %s\n" key in
        lst
        |> List.map (f1 delta_list key) (*新しい状態のリストのリストを作る*)
        |> List.concat
        |> overlapping_delete String.equal (*重複削除*)
        |> List.map (f_epsilon delta_list) (*ε遷移をする*)
        |> List.concat
        |> overlapping_delete String.equal (*重複削除*)
        |> sub xs
    in
    q0_lst
    |> List.map (f_epsilon delta_list) (*ε遷移をする*)
    |> List.concat
    |> overlapping_delete String.equal (*重複削除*)
    |> sub target (*初期状態を与えて実行*)
  in
  is_F q_lst f_lst