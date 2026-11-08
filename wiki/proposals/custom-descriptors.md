---
title: Custom Descriptors and JS Interop
type: proposal
phase: 3
repo: https://github.com/WebAssembly/custom-descriptors
families: [js-interop, gc-lang-support]
updated: 2026-11-08
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
- 2026-09、descriptor型と被descriptor型は**finality(final/open)が一致していなければならない**という制約が追加された([#112](https://github.com/WebAssembly/custom-descriptors/commit/e9f7a93d30a21c1e333d40761aac9756c0f72e62)、issue #61)。片方がfinalで他方がopenだと、open側にsubtypeを作ろうにも対応するdescriptor/被descriptor側にsubtypeが作れず、そもそも成立しない組み合わせになるための整合性要件

- 2026-10-06、READMEに仕様文面(WIP)へのリンクとupstream specとのレンダリング差分へのリンクを追加([#114](https://github.com/WebAssembly/custom-descriptors/commit/4aa477a4c1ca064fe3592b3a0307509e9059d0f9)): https://webassembly.github.io/custom-descriptors

- 2026-09-22のCG本会合で、**meta-descriptors(descriptorのdescriptor)を許すか**の議論が行われた([議事録](https://github.com/WebAssembly/meetings/blob/68fc0aaf0574447b488d2e780ae78b987771e741/main/2026/CG-2026-09-22.md), [issue #43](https://github.com/WebAssembly/custom-descriptors/issues/43))。WebKit(Keith Miller)は「セキュリティ担当と相談し、利用が大きくない限り追加すべきでない」と反対姿勢をさらに強めた。Mozillaも複雑さを懸念。JS interop上、descriptorの第1フィールド(externref)が被descriptorオブジェクトのprototypeになる仕様で、descriptorを内部で単なる構造体として実装するpolyfillではmap/shapeにprototype slotがなく、2段目以降の実装が難しい。V8は既にmeta-descriptorsを実装済み(Thomas Lively: 追加の複雑さなし)。Ben Titzer(Wizard、「WasmGCの上にWasmGCを実装する」tower用途)は許可を支持。折衷案として「コア仕様は任意段数、JS APIは第1段のみ対象」も出たが、Ben Titzerは「JS APIが非対称で未完になる」と懸念。**結論は出ず**、議論はissueへ
- 2026-10-18時点で、リポジトリの直近18コミットはspec本体の取り込みとSpecTec整備が中心で、`struct.new_desc`/`struct.new_default_desc`の構文・validationを追加した[#101](https://github.com/WebAssembly/custom-descriptors/commit/ca1e91fe2a0aa1290e485c43e8973f9c115fa89d)が提案固有の変更(Explainer本体の変更はなし)
- 2026-10-20〜24、spec本体(SpecTec / 参照インタプリタ)側の実装が進んだ([比較](https://github.com/WebAssembly/custom-descriptors/compare/ca1e91fe2a0aa1290e485c43e8973f9c115fa89d...21e9c647f5930991ebd04b42f971a30ad74fb2a5)、6コミット、Explainer/Overview本体の変更はなし): func externtype/func型に**exactness**を導入し`ref.func`をexact importに対してexactと型付け([#102](https://github.com/WebAssembly/custom-descriptors/pull/102))、allocation命令をexact化([#103](https://github.com/WebAssembly/custom-descriptors/pull/103))、`ref.get_desc`の構文・validation([#104](https://github.com/WebAssembly/custom-descriptors/pull/104))、descriptor castの構文・validation([#105](https://github.com/WebAssembly/custom-descriptors/pull/105))、`describestype`/`descriptortype`を`describes`/`descriptor`へ改名([#120](https://github.com/WebAssembly/custom-descriptors/commit/21e9c647f5930991ebd04b42f971a30ad74fb2a5))、rec group跨ぎのdescriptor supertypeテスト追加([#116](https://github.com/WebAssembly/custom-descriptors/pull/116))
- 2026-10-26〜11-01、SpecTec側で**バイナリ形式**(型・命令、[#108](https://github.com/WebAssembly/custom-descriptors/commit/a791af285f3876fb0bc6df89c218ff912347cf46))と**テキスト形式**([#121](https://github.com/WebAssembly/custom-descriptors/pull/121))の記述が追加された(2コミット、Explainer変更なし)。これで型・命令の構文(binary/text)・validationのSpecTec記述が揃いつつある
- 2026-11-02〜06、spec本体側の記述が続いた([比較](https://github.com/WebAssembly/custom-descriptors/compare/a791af285f3876fb0bc6df89c218ff912347cf46...6efbe68778e8dd684e1defb5250c0f776218af5a)、8コミット、Explainer/Overview本体の変更はなし): 実行(execution)のSpecTec/rst記述([#122](https://github.com/WebAssembly/custom-descriptors/commit/4b04325))、soundness propertiesの更新([#123](https://github.com/WebAssembly/custom-descriptors/commit/211ff1c))、descriptor型のvalidation規則([#124](https://github.com/WebAssembly/custom-descriptors/commit/a8fce47))、principal typesのexactness変数([#129](https://github.com/WebAssembly/custom-descriptors/commit/848647d))、validation algorithm(appendix)の更新([#130](https://github.com/WebAssembly/custom-descriptors/commit/6efbe68))、SpecTecメタインタプリタの対応([#128](https://github.com/WebAssembly/custom-descriptors/commit/029c005))。syntax・validation・executionの仕様記述がほぼ一巡した。2026-11-17のCG会議で「Custom descriptors update and open questions」(Thomas Lively、30分)が予定されている([アジェンダ](https://github.com/WebAssembly/meetings/blob/966c085ca47fd3255df0778cb687de337629b6c4/main/2026/CG-2026-11-17.md))

## 関連

- [[js-primitive-builtins]] — GC言語のJS連携のもう一つの面(プリミティブ操作)
- [[stringref]] — 文字列の受け渡し(関連する摩擦領域)
- [[finished-proposals]] — Wasm GC(前提となる基盤)

## 一次情報

- [Overview.md](https://github.com/WebAssembly/custom-descriptors/blob/a6a87dcadf9ec5e6465dd40c9aec97c3839807e3/proposals/custom-descriptors/Overview.md)(本ページの主な出典)
- [リポジトリ](https://github.com/WebAssembly/custom-descriptors)
