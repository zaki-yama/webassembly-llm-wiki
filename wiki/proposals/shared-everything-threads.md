---
title: Shared-Everything Threads
type: proposal
phase: 1
repo: https://github.com/WebAssembly/shared-everything-threads
updated: 2026-07-18
---

# Shared-Everything Threads

**Phase 1** / Champion: Andrew Brown, Conrad Watt, and Thomas Lively

## 概要

[[threads]](共有できるのは線形メモリのみ)を拡張し、GCオブジェクト・関数・テーブル・グローバルなど「すべて」をスレッド間で共有できるようにする野心的なproposal。`shared` 型修飾、thread-local globals、スレッド管理の組み込み関数などを含む。

Java/Kotlinなど本物のマルチスレッドを持つ言語をWasm GC上で自然に動かすための鍵となる。

## 現状

- Phase 1(提案段階)。設計論点が多く、議論が活発
- Threads Subgroup の議事録: [meetings/threads](https://github.com/WebAssembly/meetings/tree/main/threads)

## 関連

- [[threads]]、[[relaxed-atomics]]
