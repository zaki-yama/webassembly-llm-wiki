---
title: JS Primitive Builtins
type: proposal
phase: 2
repo: https://github.com/WebAssembly/js-primitive-builtins
updated: 2026-07-18
---

# JS Primitive Builtins

**Phase 2** / Champion: Sébastien Doeraene

## 概要

JS String Builtins(Wasm 3.0でFIX済み、[[finished-proposals]] 参照)の考え方をJSの他のプリミティブ(Number、BigIntなど)との変換・操作に広げるproposal。Scala.jsのような言語のWasm GCバックエンドで、JSプリミティブ操作をimport経由の高速な組み込み関数として使えるようにする。

## 現状

- Phase 2(仕様文面あり)
