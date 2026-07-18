---
title: Threads
type: proposal
phase: 4
repo: https://github.com/WebAssembly/threads
updated: 2026-07-18
---

# Threads

**Phase 4** / Champion: Conrad Watt

## 概要

共有線形メモリ(shared memory)とアトミック命令(`atomic.rmw`, `memory.atomic.wait/notify` など)を導入し、Wasmでマルチスレッド処理を可能にするproposal。スレッドの生成自体はホスト(Web Workerなど)に委ねる設計。

## 現状

- 各ブラウザでは以前から出荷済み(実装状況: [features](https://webassembly.org/features/))だが、メモリモデルの形式化などが残っており、仕様としての標準化(Phase 4→5)が進行中
- GCヒープも共有する後継的な提案として [[shared-everything-threads]] (Phase 1) がある

## 関連

- [[relaxed-atomics]] — より弱いメモリモデルのアトミクス(Phase 2)
- [[shared-everything-threads]]
