---
title: Custom Descriptors and JS Interop
type: proposal
phase: 3
repo: https://github.com/WebAssembly/custom-descriptors
families: [js-interop, gc-lang-support]
updated: 2026-08-30
---

# Custom Descriptors and JS Interop

**Phase 3(実装フェーズ)** / Champion: Thomas Lively

## 一言でいうと

Wasm GCのstructに**カスタムディスクリプタ**(エンジン管理のRTT=ランタイム型情報に相乗りするユーザー定義オブジェクト)を持たせる提案。(1) vtable等の型付随データ分のメモリを節約し、(2) JSのprototypeをGCオブジェクトに関連付けて**JSからWasmオブジェクトのメソッドを呼べる**ようにする。

## なぜ必要か(Motivation)

Java/Kotlin/Dart等をWasm GCにコンパイルすると、各オブジェクトは(a)エンジン管理のRTTヘッダと、(b)言語処理系が置くvtable/itable参照フィールドの**両方**を持ち、1オブジェクトあたり1参照分のメモリが無駄になる。またGCオブジェクトはJSから見ると素の(prototypeなしの)オブジェクトで、JS側からメソッド呼び出しや `instanceof` ができず、DOMと絡むアプリで大きな摩擦になっていた。この提案はRTTへの「拡張ポイント」を設けて両問題を一度に解く。

## 仕組み

出典: [Overview.md](https://github.com/WebAssembly/custom-descriptors/blob/a6a87dcadf9ec5e6465dd40c9aec97c3839807e3/proposals/custom-descriptors/Overview.md)

| 要素 | 説明 |
|---|---|
| `(descriptor $d)` 節 | struct型に「このstructのディスクリプタは型 `$d`」と宣言する |
| `(describes $t)` 節 | ディスクリプタ型側の宣言。相互参照するため両者は同じrec(再帰)グループに入る |
| ディスクリプタ付きアロケーション | `struct.new` 系がディスクリプタ値を取り、生成されるstructのRTT参照がそのディスクリプタを指す。vtableアクセスは「RTT経由の読み出し」になり、専用フィールドが不要に |
| exact types | `(ref (exact $t))` — サブタイプを含まない「ちょうど型$t」の参照型。ディスクリプタ経由のアロケーションの型付けに必要で、この提案の一部として導入 |
| JS prototype連携 | ディスクリプタの第1フィールド(immutable `externref`)にJSオブジェクトを入れると、GCオブジェクトの `[[GetPrototypeOf]]` がそれを返す → JSからメソッド呼び出しが可能に |
| 宣言的prototype初期化 | 多数のprototypeにexport関数を詰める起動処理を宣言的に行う仕組み(起動時間対策、副次的機能) |
| 型セクションのフィールド重複排除 | ディスクリプタ導入で増える型定義の重複をエンコーディングで削減(副次的機能) |

## 例

```wat
(rec
  (type $foo (descriptor $foo.desc) (struct (field i32)))
  (type $foo.desc (describes $foo) (struct (field (ref extern))))  ;; JS prototype等を保持
)
```

`$foo` のインスタンスはアロケーション時に `$foo.desc` の値と結び付き、以後エンジン管理ヘッダ経由でそのディスクリプタ(=vtableやJS prototype)にアクセスできる。

## フェーズ遷移

| 時期 | できごと | Phase |
|---|---|---|
| 2024頃 | 「Custom RTTs」として提案 | →1 |
| 2025-03-14 | 「Custom Descriptors」に改名([#205](https://github.com/WebAssembly/proposals/pull/205)) | - |
| 2025-05-20 | Phase 2へ([#213](https://github.com/WebAssembly/proposals/pull/213)) | 1→2 |
| 2026-01-27 | Phase 3へ([#230](https://github.com/WebAssembly/proposals/pull/230)) | 2→3 |

## 経緯と現状

- Wasm GC(Wasm 3.0でFIX)採用言語の実運用フィードバックから生まれた「GC第2章」の中心的proposal。J2CL(Java)、Kotlin/Wasm、Dartのチームが強い関心を持つ
- exact types は他proposal(例: [[shared-everything-threads]])からも参照される基盤機能
- 副次機能(宣言的初期化・フィールド重複排除)は「実際に問題になるか検証してから確定する」と明記されており、Phase 3中に取捨される可能性がある
- 2026-08-27、`descriptor`/`describes`のサブタイピング規則が引き締められた: 従来は「`(descriptor $x)`節を持つ型の宣言的супertypeは、`descriptor`節を持たなくてもよい」だったが、**supertype側も`(descriptor $y)`節を持つこと(`$y`は`$x`のsupertype)を必須**に変更。あわせて、descriptor型どうし・非descriptor型どうしでしかsubtypeになれないという制約を図式化した「complete square」則(subtype/supertypeの縦軸とdescribes/describedの横軸が揃うこと)として整理し、`ref.cast_desc_eq`系命令の健全性根拠として明記した([commit](https://github.com/WebAssembly/custom-descriptors/commit/7b64bc8d0939728a72fd871384b0322af0bca417))

## 関連

- [[js-primitive-builtins]] — GC言語のJS連携のもう一つの面(プリミティブ操作)
- [[stringref]] — 文字列の受け渡し(関連する摩擦領域)
- [[finished-proposals]] — Wasm GC(前提となる基盤)

## 一次情報

- [Overview.md](https://github.com/WebAssembly/custom-descriptors/blob/a6a87dcadf9ec5e6465dd40c9aec97c3839807e3/proposals/custom-descriptors/Overview.md)(本ページの主な出典)
- [リポジトリ](https://github.com/WebAssembly/custom-descriptors)
