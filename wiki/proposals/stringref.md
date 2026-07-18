---
title: Reference-Typed Strings (stringref)
type: proposal
phase: 1
repo: https://github.com/WebAssembly/stringref
updated: 2026-07-18
---

# Reference-Typed Strings (stringref)

**Phase 1** / Champion: Andy Wingo

## 概要

文字列を第一級の参照型 `stringref` としてWasmに導入するproposal。ホスト(JS)の文字列とコピーなしで受け渡しでき、文字列を多用する言語(Java, Dart, Schemeなど)のWasm GCバックエンドを効率化する。

## 現状

- Phase 1(提案段階)。JS String Builtins(Wasm 3.0でFIX済み、[[finished-proposals]])がimportベースの代替として先に標準化されており、stringref自体の先行きは議論が続いている

## 関連

- [[js-primitive-builtins]]
