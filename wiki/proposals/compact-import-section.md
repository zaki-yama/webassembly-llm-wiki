---
title: Compact Import Section
type: proposal
phase: 3
repo: https://github.com/WebAssembly/compact-import-section
updated: 2026-07-18
---

# Compact Import Section

**Phase 3** / Champion: Ryan Hunt

## 概要

import section のバイナリ表現を圧縮するproposal。多数のimportを持つモジュール(特にJS組み込みやComponent Model系のツールチェーン出力)でモジュール名文字列の繰り返しを省き、バイナリサイズを削減する。

## 現状

- Phase 3(実装フェーズ)
