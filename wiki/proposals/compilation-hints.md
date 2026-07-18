---
title: Compilation Hints
type: proposal
phase: 2
repo: https://github.com/WebAssembly/compilation-hints
updated: 2026-07-18
---

# Compilation Hints

**Phase 2** / Champion: Emanuel Ziegler

## 概要

custom sectionを通じてエンジンにコンパイルのヒント(どの関数を先にコンパイルすべきか、最適化レベル、インライン化候補など)を伝えるproposal。セマンティクスには影響せず、起動時間や実行性能の改善を狙う。[[branch-hinting|Branch Hinting]](Wasm 3.0でFIX済み)と同系統のアプローチ。

## 現状

- Phase 2(仕様文面あり)
