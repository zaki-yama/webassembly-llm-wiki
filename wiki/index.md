---
title: Index
type: concept
updated: 2026-08-23
---

# Index

## 全体像

- [[overview]] — Wasm標準化プロセスの全体像。フェーズ制度、組織、現在のproposal一覧スナップショット
- [[finished-proposals]] — FIX済みproposal一覧(Wasm 1.0/2.0/3.0)

## Proposals — Phase 5(標準化完了・マージ待ち)

`✔` は一次情報(Explainer等)をingest済みの深掘りページ。無印は一覧情報のみのスタブ。

- [[js-promise-integration]] ✔ — WasmからJS Promiseを同期的に待つ(JSPI)
- [[content-security-policy]] ✔ — CSPとWasm(`wasm-unsafe-eval`)

## Proposals — Phase 4(標準化中)

- [[threads]] ✔ — 共有メモリとアトミック命令
- [[compact-import-section]] ✔ — import sectionのバイナリ圧縮
- [[wide-arithmetic]] ✔ — 128bit級の整数演算命令

## Proposals — Phase 3(実装中)

- [[esm-integration]] ✔ — WasmをESモジュールとしてimport
- [[stack-switching]] ✔ — 型付き継続によるコルーチン/非同期
- [[custom-page-sizes]] ✔ — 64KiB以外のメモリページサイズ
- [[custom-descriptors]] ✔ — Wasm GCオブジェクトへのJS prototype関連付け

## Proposals — Phase 2(仕様文面あり)

- [[relaxed-dead-code-validation]] ✔ — 到達不能コードの型検証緩和
- [[wat-numeric-values]] ✔ — WATのdata segmentに数値リテラル
- [[extended-name-section]] ✔ — name sectionの拡張(デバッグ)
- [[rounding-variants]] ✔ — 浮動小数点の丸めモード指定
- [[compilation-hints]] ✔ — エンジンへのコンパイルヒント
- [[js-primitive-builtins]] ✔ — JSプリミティブの組み込み関数
- [[acquire-release-atomics]] ✔ — 弱いメモリオーダリングのアトミクス
- [[multibyte-array-access]] ✔ — GC配列へのマルチバイト単位アクセス
- [[fp16]] ✔ — 半精度浮動小数点SIMDレーン型

## Proposals — Phase 1(提案段階・注目のみ)

- [[shared-everything-threads]] ✔ — GCヒープまで共有するスレッド
- [[stringref]] ✔ — 第一級の文字列参照型
- [[type-imports]] ✔ — 型のimport/export
- [[memory-control]] ✔ — メモリの細粒度制御

## Families(横断ページ)

- [[concurrency]] — 並行性の2軸(共有メモリ並列/制御フロー中断)を俯瞰
- [[js-interop]] — JS境界の3層(モジュール/実行モデル/値)を俯瞰
- [[gc-lang-support]] — Wasm GC言語を実用にする「GC第2章」を俯瞰

## WASI / Component Model

- [[wasi-roadmap]] — WASI 0.1→0.2→0.3の流れと0.3.xリリーストレイン
- [[component-model-overview]] — Component Modelの概要と標準化状況

## ニュースレター

- [[2026-W34]] — 静かな週。定例会合が軒並みキャンセル。Component Modelの細かな仕様修正、watrがFP16・Acquire-Release Atomicsをサポート
- [[2026-W33]] — Compact Import Section・Wide ArithmeticがPhase 4へ、WASIがCM map型/implementsアノテーションを採用しv0.3.1リリース
- [[2026-W32]] — FP16がPhase 2へ(改名・champion交代)、Relaxed Atomics→Acquire-Release Atomicsに改名、WASIのCM機能採否投票プロセス新設
- [[2026-W31]] — 静かな週。8/4〜5 CG対面会合を目前に控え結果待ち
- [[2026-W30]] — JSPI・CSPがPhase 5へ、Multibyte Array AccessがPhase 2へ
- [[2026-W29]] — 初回。WASI 0.3.xリリース計画、Multibyte Array Access Phase 2投票へ

## ミーティング要約

- [[2026-06-24-wg]] — JSPI・CSPのPhase 5投票(全会一致)
- [[2026-06-25-wasi]] — WASI 0.3.0振り返り、0.3.xリリース計画、OCI artifact基準の提案
- [[2026-08-04-cg]] — CG対面会合(Siemens)。FP16のPhase 2投票、Compact Import Section・Wide ArithmeticのPhase 4投票
- [[2026-08-06-wasi]] — WASI Subgroup。Component Model map型・implementsアノテーションの採否投票(いずれも可決)
