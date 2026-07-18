---
title: Memory Control
type: proposal
phase: 1
repo: https://github.com/WebAssembly/memory-control
updated: 2026-07-18
---

# Memory Control

**Phase 1** / Champion: Deepti Gandluri & Ben Visness

## 概要

線形メモリの細かい制御(メモリのdiscard/解放、メモリマッピング、保護属性など)を可能にするproposal。長時間動くアプリでのメモリ使用量削減や、mmap的なユースケースに応える。

## 現状

- Phase 1(提案段階)
