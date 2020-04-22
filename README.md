![](https://github.com/puripuri2100/camlton/workflows/CI/badge.svg)


# camlton

OCamlによる非決定性有限オートマトンの実装です


# OPAMを使ったインストール

以下のソフトウェアが必要です

* git
* make
* [opam](https://opam.ocaml.org/) 2.0
* ocaml (>= 4.06.0) (installed by OPAM)


## インストール例

### Install opam (Ubuntu)

```sh
sh <(curl -sL https://raw.githubusercontent.com/ocaml/opam/master/shell/install.sh)

eval $(opam env)
```

### Install ocaml (Ubuntu)

```sh
opam init --comp 4.10.0
```

### Install ocaml (Ubuntu on WSL)

```sh
opam init --comp 4.10.0 --disable-sandboxing
```

### ビルド

```sh
git clone https://github.com/puripuri2100/camlton.git
cd camlton

opam pin add camlton .
opam install camlton
```


# camltonの使い方

ターミナルで以下のようにして実行します

```sh
camlton -c <config file>
```

## 試しに使ってみる

```sh
make example
```

もし、trueが表示されたならインストール成功です。

---

This software released under [the MIT license](https://github.com/puripuri2100/camlton/blob/master/LICENSE).

Copyright (c) 2020 Naoki Kaneko (a.k.a. "puripuri2100")