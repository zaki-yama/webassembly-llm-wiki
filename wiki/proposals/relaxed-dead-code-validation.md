---
title: Relaxed Dead Code Validation
type: proposal
phase: 2
repo: https://github.com/WebAssembly/relaxed-dead-code-validation
updated: 2026-07-18
---

# Relaxed Dead Code Validation

**Phase 2** / Champion: Conrad Watt and Ross Tate

## 概要

`unreachable` 以降などの到達不能コードに対する型検証ルールを緩和するproposal。現行仕様では到達不能コードにも複雑な型検証が要求され、コンパイラ実装の負担になっているため、これを単純化する。

## 現状

- Phase 2(仕様文面あり)
