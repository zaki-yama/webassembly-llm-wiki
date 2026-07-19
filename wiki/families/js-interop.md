---
title: JS連携(JS Interop)
type: family
members: [esm-integration, js-promise-integration, custom-descriptors, js-primitive-builtins, stringref]
updated: 2026-07-19
---

# JS連携(JS Interop)

## 概要

WasmとJavaScriptの境界摩擦を減らすproposal群。境界は3層ある:

1. **モジュールシステム**: WasmをJSのモジュールグラフに入れる([[esm-integration]])
2. **実行モデル**: JSの非同期(Promise)とWasmの同期的コードをつなぐ([[js-promise-integration]])
3. **値・オブジェクト**: JSの値をWasmから速く・型安全に扱う([[custom-descriptors]] / [[js-primitive-builtins]] / [[stringref]])

## メンバー

| 提案 | Phase | 一言 |
|---|---|---|
| [[esm-integration]] | 3 | `import ... from "./m.wasm"`(モジュール統合) |
| [[js-promise-integration]] | 4 | Promiseを同期的に待つ(実行モデル統合) |
| [[custom-descriptors]] | 3 | GCオブジェクトにJS prototypeを関連付け(オブジェクト統合) |
| [[js-primitive-builtins]] | 2 | number/boolean等の組み込みimport(プリミティブ統合) |
| [[stringref]] | 1 | 文字列を第一級型に(builtinsアプローチに先行された) |

FIX済みの関連: JS String Builtins、JS BigInt integration、Type Reflection(→ [[finished-proposals]])

## 横断テーマ

- **「組み込みimport」パターンの定着**: `wasm:` 名前空間のimportをエンジンが特別扱いする方式(JS String Builtinsが確立)が、コア型を増やす方式(stringref)に対して勝ち筋になっている。js-primitive-builtinsはその延長
- **JS API vs コア仕様**: JSPI・ESM統合・CSPのようにコア仕様を触らずJS API/Web仕様側で解く提案は、ブラウザ外との整合を気にせず進められるため速い
- **Wasm GC言語がドライバ**: この領域の近年の提案(custom-descriptors、js-primitive-builtins)はほぼすべてJava/Kotlin/Dart/Scala.jsのGCバックエンドの実測ニーズから来ている

## 関連family

- [[gc-lang-support]] — メンバーが大きく重なる(JS連携はGC言語サポートの一部でもある)
- [[concurrency]] — JSPIが両方に属する
