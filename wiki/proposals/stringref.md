---
title: Reference-Typed Strings (stringref)
type: proposal
phase: 1
repo: https://github.com/WebAssembly/stringref
families: [js-interop, gc-lang-support]
updated: 2026-07-19
---

# Reference-Typed Strings (stringref)

**Phase 1(提案段階)** / Champion: Andy Wingo

## 一言でいうと

文字列を第一級の参照型 **`stringref`** としてWasmコア仕様に導入する提案。JSエンジンの文字列実装をそのまま再利用し、JS⇔Wasm間の**ゼロコピー**の文字列受け渡しを可能にする。

## なぜ必要か(Motivation)

Java/Kotlin/Dart/Schemeのような文字列を多用する言語をWasm GCで動かすとき、文字列だけは自前実装(WTF-16のarray等)にするとJSとの境界で毎回コピー・変換が発生する。goalは2つ: (1) JS文字列を効率的に生成・消費できること、(2) GC言語一般が使える「良い文字列実装」を提供すること — この2つはときに衝突するため、"minimal viable" が設計の合言葉。

要求仕様: ゼロコピー受け渡し / Web上に新しい文字列実装を作らない(JSエンジンのを再利用)/ エンジン内部表現はWTF-8でもWTF-16でも可 / Java系のためのWTF-16コードユニットアクセス / 定数式での文字列リテラル。

## 仕組み

出典: [Overview.md](https://github.com/WebAssembly/stringref/blob/a64917cd5346f8704e614c4825ebf05737ac5e64/proposals/stringref/Overview.md)

- 新しい参照型 `stringref`(および各エンコーディングの「view」型: `stringview_wtf8` / `stringview_wtf16` / `stringview_iter`)
- 文字列の中身は**サロゲートを許すWTF-8/WTF-16**で定義(JS文字列との無損失変換のため。「文字列=unicode scalar valueの列」という理想は互換性のため採れない、という議論がDesign節にある)
- 生成(メモリ/GC配列から)、連結、比較、エンコード(メモリへ書き出し)、コードユニット単位のアクセス、イテレーション等の命令群
- 文字列リテラルをconstant expressionで書ける

## フェーズ遷移

| 時期 | できごと | Phase |
|---|---|---|
| 2022頃 | 提案(Wasm GC策定と並走) | →1 |
| (以後) | Phase 1に留まる。V8が実験実装(`--experimental-wasm-stringref`)を出し、実データで議論 | 1 |

## 経緯と現状

- **JS String Builtins(Wasm 3.0でFIX)が「importベースの組み込み」という対抗アプローチで先に標準化**され、当面の実用ニーズ(JS文字列の高速操作)はそちらで満たされる構図になった。stringrefは「コア型としての文字列」というより大きな一歩であり、複雑さ(view型、エンコーディング中立性)への慎重論が強く、先行きは不透明
- 型としての文字列が持つ利点(型シグネチャに現れる、非JS環境でも意味を持つ)は残っており、休眠しつつも議論は継続

## 関連

- [[finished-proposals]] — JS String Builtins(採用された対抗アプローチ)
- [[js-primitive-builtins]] — builtinsアプローチの拡張(文字列以外へ)
- [[custom-descriptors]] — GC言語サポートの隣接領域

## 一次情報

- [Overview.md](https://github.com/WebAssembly/stringref/blob/a64917cd5346f8704e614c4825ebf05737ac5e64/proposals/stringref/Overview.md)(本ページの主な出典)
- [リポジトリ](https://github.com/WebAssembly/stringref)
