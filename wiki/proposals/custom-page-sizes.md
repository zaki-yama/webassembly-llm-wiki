---
title: Custom Page Sizes
type: proposal
phase: 3
repo: https://github.com/WebAssembly/custom-page-sizes
updated: 2026-07-18
---

# Custom Page Sizes

**Phase 3** / Champion: Nick Fitzgerald

## 概要

線形メモリのページサイズを従来の64KiB固定から選択可能にするproposal(64KiBに加えて1バイト単位を許可)。組み込み・エッジ環境など、64KiBの粒度ではメモリが粗すぎる環境でWasmを使いやすくする。

## 現状

- Phase 3(実装フェーズ)
