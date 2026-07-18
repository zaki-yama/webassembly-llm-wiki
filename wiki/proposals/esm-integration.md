---
title: ESM Integration
type: proposal
phase: 3
repo: https://github.com/WebAssembly/esm-integration
updated: 2026-07-18
---

# ESM Integration

**Phase 3** / Champion: Asumu Takikawa, Ms2ger & Guy Bedford

## 概要

WasmモジュールをJavaScriptのESモジュールとして `import` できるようにするproposal。`import { fn } from "./module.wasm"` のように書け、モジュールグラフの一部としてWasmが解決・インスタンス化される。TC39の Source Phase Imports(`import source`)とも連携する。

## 現状

- Phase 3(実装フェーズ)。実装状況は [features](https://webassembly.org/features/) を参照
