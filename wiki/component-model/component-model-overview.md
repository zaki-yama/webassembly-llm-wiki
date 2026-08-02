---
title: Component Model
type: component-model
phase: 1
repo: https://github.com/WebAssembly/component-model
updated: 2026-08-02
---

# Component Model

**コア仕様上はPhase 1のproposal** だが、実質的にはWASI 0.2以降の基盤としてブラウザ外エコシステムで広く実運用されている。Champion: Luke Wagner。

## 概要

Wasmモジュールを「コンポーネント」として合成し、言語をまたいで型安全にリンクするための枠組み。

- **Wit IDL**: インターフェース定義言語。`resource`(ハンドル付き型)、高水準の値型を持つ
- **Canonical ABI**: コンポーネント間の値の受け渡し規約
- shared-nothing リンク(コンポーネント間でメモリを共有しない)

## バージョン(WASI Developer Preview と連動)

- **0.2.0**: 最初のComponent Modelベースのリリース。リンク、resource型、Wit
- **0.3.0**: `async` 関数・`stream`・`future` によるネイティブ非同期対応(リポジトリ内で 🔀 絵文字でマーク)
- 今後: cooperative threads(🧵)などのgated featureが順次追加予定

## 標準化の道筋

W3C CGでの標準化(いわゆる1.0)に向けた作業が進む。経緯は [The Road to Component Model 1.0](https://bytecodealliance.org/articles/the-road-to-component-model-1-0) を参照。

2026-08-04〜05の対面CG会合ではComponent Model単独で2時間の議題枠(Ryan Hunt/Luke Wagner)が予定されている(Web上でのComponents / Web外でのComponents / Next Steps、[議題](https://github.com/WebAssembly/meetings/blob/main/main/2026/CG-2026-08.md))。

## 仕様文書の細かな変更(2026-07時点)

- テキスト形式のインデックス解析規則(index spaces節)がExplainer内で整理・明確化された(意味論変更なし。[#655](https://github.com/WebAssembly/component-model/commit/1d20b88))
- `realloc`呼び出しは新規スレッド上で実行されると定義された([#680](https://github.com/WebAssembly/component-model/pull/680))
- `implements`(名前付きimport)・`external-id`が実験的にspec/Wasmtimeへ実装(→ [[wasi-roadmap]])
- 非推奨だった `canon backpressure.set` 組み込みがCanonical ABI/Explainer/Binaryから削除された。`backpressure.inc`/`backpressure.dec`への一本化が完了([#683](https://github.com/WebAssembly/component-model/commit/d6b48f2))

## 関連

- [[wasi-roadmap]]
- ユーザー向けドキュメント: [component-model.bytecodealliance.org](https://component-model.bytecodealliance.org/)
