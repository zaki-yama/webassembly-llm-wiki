---
title: Web Content Security Policy
type: proposal
phase: 4
repo: https://github.com/WebAssembly/content-security-policy
updated: 2026-07-18
---

# Web Content Security Policy

**Phase 4** / Champion: Francis McCabe

## 概要

Content Security Policy (CSP) とWebAssemblyの関係を定義するproposal。`wasm-unsafe-eval` ソースディレクティブにより、JSの `unsafe-eval` を許可せずにWasmのコンパイル・実行だけを許可できるようにする。

## 現状

- Phase 4。`wasm-unsafe-eval` は主要ブラウザで利用可能。CSP仕様側・web-api仕様側の文面整備が主な残作業
