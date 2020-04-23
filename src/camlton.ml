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


(*偏移関数のデータを基に実際に偏移した後の状態のリストを作成する*)
(*
偏移関数のデータの中身は
  - 移動前の状態名
  - 文字列
  - 移動後の状態名
*)
(*ε遷移だけをする関数をまず作成*)
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
    in
    match q_lst with (*作成したεで遷移できる先のリストをチェックする*)
    | [] -> lst (*遷移先が無い*)
    | x -> (*遷移先がまだある*)
      List.append lst (sub q_lst) (*既存の遷移先と新たな遷移先を結合*)
  in
  sub [q]


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
    |> List.map (fun l ->
        let m = f_epsilon delta_lst l in
        let() = debug "  遷移先" m in
        m
      ) (*ε遷移できる先を作成*)
    |> List.concat
  in
  let epsilon_after_lst =
    let epsilon = "" in
    let f q (b,k,_) =(*εであるかを判定する関数*)
      String.equal b q (*移動前の状態名のチェック*)
      &&
      String.equal k epsilon (*εであるかのチェック*)
    in
    delta_lst
    |> List.filter (f q)
    |> List.map (fun (_,_,a) -> a)
    |> List.concat
    |> List.map (fun l ->
        let m = f_epsilon delta_lst l in
        let() = debug "  遷移先" m in
        m
      ) (*ε遷移できる先を作成*)
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


(*特定の状態だけ削除する*)
let delete (f: 'a -> 'a -> bool) (data_lst: 'a list) (main_lst: 'a list) =
  let rec sub data_lst lst =
    match data_lst with
    | [] -> lst
    | x :: xs ->
      lst
      |> List.filter (fun y -> not (f x y))
      |> sub xs
  in
  sub data_lst main_lst



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
      let () = debug "現状態" lst in
      match target with
      | [] -> lst (*処理する文字列が無くなったら終了*)
      | key :: xs ->
        let () = Printf.printf "key : %s\n" key in
        lst
        |> List.map (f1 delta_list key) (*新しい状態のリストのリストを作る*)
        |> List.concat
        |> overlapping_delete String.equal (*重複削除*)
        |> sub xs
    in
    let f lst =(*初期状態からε遷移した場合には元の初期状態を削除する関数*)
      let n = List.length q0 in (*初期状態の数*)
      let m = List.length lst in (*ε遷移した後の数*)
      if n < m then
        delete String.equal q0 lst (*初期状態削除*)
      else
        q0 (*ε遷移してないのでそのまま*)
    in
    q0
    |> List.map (f_epsilon delta_list) (*初期状態に対してもε遷移できるかの処理をする*)
    |> List.concat
    |> f (*ε遷移してたら、最初の初期状態を保つ必要が無いので削除*)
    |> sub target (*初期状態を与える*)
  in
  is_F q_lst f_lst