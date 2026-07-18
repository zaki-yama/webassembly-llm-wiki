---
title: Relaxed Atomics
type: proposal
phase: 2
repo: https://github.com/WebAssembly/relaxed-atomics
updated: 2026-07-18
---

# Relaxed Atomics

**Phase 2** / Champion: Conrad Watt & Rezvan Mahdavi Hezaveh

## 概要

[[threads]] のアトミック命令は逐次一貫性(seqcst)のみだが、より弱いメモリオーダリング(acquire/release、relaxed)のアトミック命令を追加するproposal。C/C++/Rustの `memory_order` を忠実かつ高速にコンパイルできるようになる。

## 現状

- Phase 2(仕様文面あり)

## 関連

- [[threads]]
- [[shared-everything-threads]]
