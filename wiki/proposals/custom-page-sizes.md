---
title: Custom Page Sizes
type: proposal
phase: 3
repo: https://github.com/WebAssembly/custom-page-sizes
updated: 2026-07-19
---

# Custom Page Sizes

**Phase 3(実装フェーズ)** / Champion: Nick Fitzgerald

## 一言でいうと

線形メモリのページサイズを、従来の64KiB固定から**メモリ型の一部として選択可能**にする提案(当面は64KiBと1バイトの2択)。

## なぜ必要か(Motivation)

1. **組み込み環境**: 利用可能メモリが64KiB未満のマイコン等では、そもそも1ページすら確保できず、Wasmが動かせない
2. **細粒度のリソース管理**: 小さな作業メモリしか要らないモジュール(例: 状態機械をWasmにコンパイルしたもの)でも、現状は最低64KiBを確保させられる

## 仕組み

出典: [Overview.md](https://github.com/WebAssembly/custom-page-sizes/blob/583fe1eba96b6e1caf19d9451a5b97dcae33b098/proposals/custom-page-sizes/Overview.md)

メモリ型を `memtype ::= limits mempagesize` に拡張する:

- 有効なページサイズは当面 **1バイト または 64KiB** の2つ(エンコーディングは将来1〜65536の2冪へ緩和できる形)
- バイナリでは省略可能で、省略時は64KiB(後方互換)
- limitsは引き続き「ページ数」で表し、バイトサイズ = limits × ページサイズ
- `memory.grow` / `memory.size` もページ数単位のまま(意味は変わらない)
- メモリ型のマッチングは**ページサイズ完全一致**を要求(サブタイピングなし)

設計上の要点:

1. **最小侵襲**: 新命令ゼロ。ページサイズは常に静的に既知(メモリ命令は静的な `memidx` を持つ)なので、エンジン・プロデューサ双方で定数畳み込みできる
2. **メモリ単位の設定**: 1モジュール内で異なるページサイズのメモリを併用できる([[finished-proposals]] のMultiple memoriesと組み合わせ)

## 例

```wat
;; 1バイトページ、最小4096ページ(=4096バイト)、最大8192ページ
(memory (pagesize 1) 4096 8192)
```

64KiBの倍数ではない、バイト単位のメモリサイズが表現できる。

## フェーズ遷移

| 時期 | できごと | Phase |
|---|---|---|
| 2024-03-27 | proposals一覧に追加([#184](https://github.com/WebAssembly/proposals/pull/184)) | →1 |
| 2024-07-30 | Phase 2へ([#194](https://github.com/WebAssembly/proposals/pull/194)) | 1→2 |
| 2025-10 | 対面CG会合で議論([議事録](https://github.com/WebAssembly/meetings/blob/main/main/2025/CG-10.md)) | - |
| 2026-01-26 | Phase 3へ([#229](https://github.com/WebAssembly/proposals/pull/229)) | 2→3 |

## 経緯と現状

- Bytecode Alliance圏(Wasmtime)の組み込みユースケースが主導。Wasmtimeに実装がある(OverviewのImplementation Status参照)
- 「ページという概念を捨ててバイト単位のlimitsにする」代替案は、既存仕様との整合とエンジンのGuard Page戦略維持のため採らなかった

## 関連

- [[memory-control]] — メモリ管理のもう一つの軸(マッピング・保護)
- [[finished-proposals]] — Memory64 / Multiple memories(メモリ型を拡張してきた系譜)

## 一次情報

- [Overview.md](https://github.com/WebAssembly/custom-page-sizes/blob/583fe1eba96b6e1caf19d9451a5b97dcae33b098/proposals/custom-page-sizes/Overview.md)(本ページの主な出典)
- [リポジトリ](https://github.com/WebAssembly/custom-page-sizes)
