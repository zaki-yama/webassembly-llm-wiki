---
title: JS Primitive Builtins
type: proposal
phase: 2
repo: https://github.com/WebAssembly/js-primitive-builtins
families: [js-interop, gc-lang-support]
updated: 2026-07-19
---

# JS Primitive Builtins

**Phase 2(仕様文面あり)** / Champion: Sébastien Doeraene

## 一言でいうと

JS String Builtins(Wasm 3.0でFIX)の枠組みを、文字列以外のJSプリミティブ(`number` / `boolean` / `symbol` / `bigint` / `undefined`)に広げる提案。JSグルーコード呼び出しになっていた操作を、エンジンがインライン展開できる組み込みimportにする。

## なぜ必要か(Motivation)

Scala.jsやKotlinのようにJSと深く相互運用する言語をWasm GCへコンパイルすると、値の「universal representation」(JSから見てJSプリミティブに見える統一表現)が必要になる。たとえば `i32` を `anyref` にboxしてJSに渡すとJSの `number` に見えなければならない。現状これらの変換・型テストはJSグルー関数へのimport呼び出しになり、本来数命令で済む操作にWasm→JS呼び出しのコストがかかる。Scala.js-to-Wasmコンパイラのプロファイリングで「グルーコードだという理由だけでホットスポットに現れる」操作群が特定され、それが提案の直接の出発点。

## 仕組み

出典: [Overview.md](https://github.com/WebAssembly/js-primitive-builtins/blob/5e5973510b4ef20d980102a1ecd358e9e8064372/proposals/js-primitive-builtins/Overview.md)

JS String Builtinsと同じ機構(`wasm:` 名前空間のimportをエンジンが特別扱い)で、以下の組み込みを追加する(Stage 1議論で当初案から大幅に絞り込み済み):

| 名前空間 | 組み込み |
|---|---|
| `wasm:js-string`(拡張) | 数値→文字列変換: `fromI32` `fromU32` `fromI64` `fromU64` `fromF64` |
| `wasm:js-number` | 型テスト `test` `testI32` `testU32` / 生成 `fromF64` `fromI32` `fromU32` / 取り出し `toF64` `toI32` `toU32` |
| `wasm:js-boolean` | `test` / `cast`(生成は `true`/`false` のglobal importで足りる) |
| `wasm:js-undefined` | `test`(生成は `void 0` のglobal import) |
| `wasm:js-symbol` | `test` / `equals`(同一性判定) |
| `wasm:js-bigint` | `test`(他の操作は動機不足で削除) |

すべて「JSで既に表現できる操作」に限定する(新しい能力は足さない)というJS String Builtins以来のゴールを維持。

## 例

```wat
;; JSのnumberとして見えるboxを作り、i32を取り出す
(import "wasm:js-number" "fromI32" (func $boxI32 (param i32) (result externref)))
(import "wasm:js-number" "toI32"   (func $unboxI32 (param externref) (result i32)))
```

エンジンはこれらを認識し、JS関数呼び出しではなくインライン命令列にコンパイルできる。

## フェーズ遷移

| 時期 | できごと | Phase |
|---|---|---|
| 2025-07-14 | Phase 1でproposals一覧に追加([#214](https://github.com/WebAssembly/proposals/pull/214)) | →1 |
| 2025-11-17 | Phase 2へ([#225](https://github.com/WebAssembly/proposals/pull/225)) | 1→2 |

## 経緯と現状

- Scala.jsのWasmバックエンドのベンチマーク・プロファイルが実証データを提供している。他ツールチェーン(Kotlin/Wasm、Dart等)への一般化を意識して符号なし整数系も含めた
- import数が増える問題は [[compact-import-section]] が補完する関係

## 関連

- [[finished-proposals]] — JS String Builtins(直接の前身・同じ機構)
- [[custom-descriptors]] — GC言語のJS連携のもう一つの面(オブジェクト・prototype)
- [[stringref]] — 文字列を第一級型にする対抗アプローチ
- [[compact-import-section]] — import爆発への対処

## 一次情報

- [Overview.md](https://github.com/WebAssembly/js-primitive-builtins/blob/5e5973510b4ef20d980102a1ecd358e9e8064372/proposals/js-primitive-builtins/Overview.md)(本ページの主な出典)
- [リポジトリ](https://github.com/WebAssembly/js-primitive-builtins)
