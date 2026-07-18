---
title: JS Promise Integration (JSPI)
type: proposal
phase: 4
repo: https://github.com/WebAssembly/js-promise-integration
updated: 2026-07-18
---

# JS Promise Integration (JSPI)

**Phase 4** / Champion: Francis McCabe

## 概要

同期的に書かれたWasmコード(C/C++などからのコンパイル産物)が、JavaScriptの非同期API(Promise)を「あたかも同期呼び出しのように」待てるようにするJS API拡張。Wasm側のスタックをsuspendし、Promiseの解決時にresumeする。

Emscriptenの Asyncify(コード変換によるエミュレーション)を置き換える、エンジンネイティブの仕組み。

## 現状

- Phase 4。実装状況は [features](https://webassembly.org/features/) を参照
- コア仕様側の汎用的なスタック切り替えは [[stack-switching]] (Phase 3)。JSPIはそのJS API向けサブセットに相当する位置づけ

## 関連

- [[stack-switching]]
