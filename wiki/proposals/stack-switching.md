---
title: Stack Switching
type: proposal
phase: 3
repo: https://github.com/WebAssembly/stack-switching
updated: 2026-07-18
---

# Stack Switching

**Phase 3** / Champion: Francis McCabe & Sam Lindley

## 概要

コルーチン・軽量スレッド・ジェネレータ・async/await といった非局所的な制御フローをWasmコア仕様で表現できるようにするproposal。型付き継続(`cont` 型)と `suspend` / `resume` 命令に基づく設計。

言語処理系(Go, Kotlin, OCaml, Haskellなど)が自前のスケジューラやエフェクトハンドラをWasm上で効率的に実装できるようになる。

## 現状

- Phase 3(実装フェーズ)
- JS APIレベルの限定版である [[js-promise-integration]] が先行してPhase 4にある

## 関連

- [[js-promise-integration]]
- Stack Subgroup の議事録: [meetings/stack](https://github.com/WebAssembly/meetings/tree/main/stack)
