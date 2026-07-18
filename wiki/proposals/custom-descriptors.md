---
title: Custom Descriptors and JS Interop
type: proposal
phase: 3
repo: https://github.com/WebAssembly/custom-descriptors
updated: 2026-07-18
---

# Custom Descriptors and JS Interop

**Phase 3** / Champion: Thomas Lively

## 概要

Wasm GC([[finished-proposals]] 参照)のstruct型にカスタムディスクリプタを持たせ、JS側のprototypeをGCオブジェクトに関連付けられるようにするproposal。Java/Kotlin/DartなどをWasm GCにコンパイルする際のJS相互運用(メソッド呼び出し、instanceof等)を効率化する。

## 現状

- Phase 3(実装フェーズ)
