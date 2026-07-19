---
title: Wide Arithmetic
type: proposal
phase: 3
repo: https://github.com/WebAssembly/wide-arithmetic
updated: 2026-07-19
---

# Wide Arithmetic

**Phase 3(実装フェーズ)** / Champion: Alex Crichton and Jamey Sharp

## 一言でいうと

64bitを超える整数演算(128bit加減算、64×64→128bit乗算)を1命令で表現できるようにする提案。多倍長整数演算のホットループを高速化する。

## なぜ必要か(Motivation)

暗号(RSA、楕円曲線)、bignumライブラリ、ハッシュなどは「キャリー付き加算」「上位ビットも取る乗算」を多用する。ネイティブでは `adc`(add-with-carry)や128bit乗算命令で1〜2命令だが、Wasmにはキャリーを直接扱う手段がなく、64bit演算の組み合わせ(比較でキャリーを再構成する等)に展開され、大きなオーバーヘッドになる。LLVMの `i128` をWasmに落とすときの効率も悪い。この提案は最小限の「幅広(wide)演算」命令を足してこのギャップを埋める。

## 仕組み

出典: [Overview.md](https://github.com/WebAssembly/wide-arithmetic/blob/429bda3b343e86c13e374bd8ff89c71e1cfbab31/proposals/wide-arithmetic/Overview.md)

追加されるのは4命令のみ。128bit値は `i64` のlow/highペアで表す(新しい値型は導入しない):

| 命令 | 型 | 意味 |
|---|---|---|
| `i64.add128` | `[i64 i64 i64 i64] → [i64 i64]` | 128bit加算(lo/hi × 2 → lo/hi) |
| `i64.sub128` | `[i64 i64 i64 i64] → [i64 i64]` | 128bit減算 |
| `i64.mul_wide_s` | `[i64 i64] → [i64 i64]` | 符号付き 64×64→128bit乗算 |
| `i64.mul_wide_u` | `[i64 i64] → [i64 i64]` | 符号なし 64×64→128bit乗算 |

`i128` という新しい値型を足す案や、キャリーフラグを直接表現する案(`add_with_carry` 等)はAlternativesで検討の上、「既存の型システムを変えない最小の追加」としてこの形に落ち着いた。

## 例

Rustの `u64::overflowing_add` 相当(Overviewより):

```wat
(func $overflowing_add (param i64 i64) (result i64 i64)
  (i64.add128
    (local.get 0) (i64.const 0)  ;; lhs の lo/hi(ゼロ拡張)
    (local.get 1) (i64.const 0)) ;; rhs の lo/hi
) ;; 結果のhiがオーバーフローフラグ(0 or 1)になる
```

## フェーズ遷移

| 時期 | できごと | Phase |
|---|---|---|
| 2024-08-13 | 「128-bit arithmetic」としてPhase 1で追加([#195](https://github.com/WebAssembly/proposals/pull/195)) | →1 |
| 2024-10-08 | Phase 2へ([#198](https://github.com/WebAssembly/proposals/pull/198)) | 1→2 |
| 2025-02-14 | Phase 3へ([#202](https://github.com/WebAssembly/proposals/pull/202)) | 2→3 |

提案から約半年でPhase 3に達した、近年では進行の速いproposal。

## 経緯と現状

- Wasmtimeで実装が進み、ベンチマーク(bignum系)で大きな改善が報告されている(OverviewのImplementation Status参照)
- 当初名「128-bit arithmetic」から、将来の拡張(より広い幅、他の演算)を見据えて「Wide Arithmetic」に改名された
- 実装状況: [features](https://webassembly.org/features/)

## 関連

- [[custom-page-sizes]] — 同じくWasmtime系(Bytecode Alliance)発の実務ニーズ由来proposal

## 一次情報

- [Overview.md](https://github.com/WebAssembly/wide-arithmetic/blob/429bda3b343e86c13e374bd8ff89c71e1cfbab31/proposals/wide-arithmetic/Overview.md)(本ページの主な出典)
- [リポジトリ](https://github.com/WebAssembly/wide-arithmetic)
