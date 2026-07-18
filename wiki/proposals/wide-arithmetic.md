---
title: Wide Arithmetic
type: proposal
phase: 3
repo: https://github.com/WebAssembly/wide-arithmetic
updated: 2026-07-18
---

# Wide Arithmetic

**Phase 3** / Champion: Alex Crichton and Jamey Sharp

## 概要

64bitを超える整数演算を効率化する命令を追加するproposal。`i64.add128` のようなキャリー付き加算や 64×64→128bit 乗算などを1命令で表現でき、多倍長整数演算(暗号、bignum)の性能を改善する。

## 現状

- Phase 3(実装フェーズ)。実装状況は [features](https://webassembly.org/features/) を参照
