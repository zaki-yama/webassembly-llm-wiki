---
title: Index
type: concept
updated: 2026-07-18
---

# Index

## 全体像

- [[overview]] — Wasm標準化プロセスの全体像。フェーズ制度、組織、現在のproposal一覧スナップショット
- [[finished-proposals]] — FIX済みproposal一覧(Wasm 1.0/2.0/3.0)

## Proposals — Phase 4(標準化中)

`✔` は一次情報(Explainer等)をingest済みの深掘りページ。無印は一覧情報のみのスタブ。

- [[threads]] ✔ — 共有メモリとアトミック命令
- [[js-promise-integration]] ✔ — WasmからJS Promiseを同期的に待つ(JSPI)
- [[content-security-policy]] ✔ — CSPとWasm(`wasm-unsafe-eval`)

## Proposals — Phase 3(実装中)

- [[esm-integration]] ✔ — WasmをESモジュールとしてimport
- [[wide-arithmetic]] ✔ — 128bit級の整数演算命令
- [[stack-switching]] ✔ — 型付き継続によるコルーチン/非同期
- [[compact-import-section]] ✔ — import sectionのバイナリ圧縮
- [[custom-page-sizes]] ✔ — 64KiB以外のメモリページサイズ
- [[custom-descriptors]] ✔ — Wasm GCオブジェクトへのJS prototype関連付け

## Proposals — Phase 2(仕様文面あり)

- [[relaxed-dead-code-validation]] — 到達不能コードの型検証緩和
- [[wat-numeric-values]] — WATのdata segmentに数値リテラル
- [[extended-name-section]] — name sectionの拡張(デバッグ)
- [[rounding-variants]] — 浮動小数点の丸めモード指定
- [[compilation-hints]] — エンジンへのコンパイルヒント
- [[js-primitive-builtins]] — JSプリミティブの組み込み関数
- [[relaxed-atomics]] — 弱いメモリオーダリングのアトミクス

## Proposals — Phase 1(提案段階・注目のみ)

- [[shared-everything-threads]] — GCヒープまで共有するスレッド
- [[stringref]] — 第一級の文字列参照型
- [[type-imports]] — 型のimport/export
- [[memory-control]] — メモリの細粒度制御

## WASI / Component Model

- [[wasi-roadmap]] — WASI 0.1→0.2→0.3の流れと0.3.xリリーストレイン
- [[component-model-overview]] — Component Modelの概要と標準化状況

## ニュースレター

- [[2026-W29]] — 初回。WASI 0.3.xリリース計画、Multibyte Array Access Phase 2投票へ

## ミーティング要約

- [[2026-06-25-wasi]] — WASI 0.3.0振り返り、0.3.xリリース計画、OCI artifact基準の提案
