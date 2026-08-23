---
title: Component Model
type: component-model
phase: 1
repo: https://github.com/WebAssembly/component-model
updated: 2026-08-23
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

2026-08-04〜05の対面CG会合ではComponent Model単独で2時間の議題枠(Ryan Hunt/Luke Wagner)があった(Web上でのComponents / Web外でのComponents / Next Steps、[議題](https://github.com/WebAssembly/meetings/blob/main/main/2026/CG-2026-08.md))。議事録の「Meeting notes」節は2026-08-16時点でも未記入で、議論内容は確認できていない。

## 仕様文書の細かな変更(2026-08時点)

- テキスト形式のインデックス解析規則(index spaces節)がExplainer内で整理・明確化された(意味論変更なし。[#655](https://github.com/WebAssembly/component-model/commit/1d20b88))
- `realloc`呼び出しは新規スレッド上で実行されると定義された([#680](https://github.com/WebAssembly/component-model/pull/680))
- `implements`(名前付きimport)・`external-id`が実験的にspec/Wasmtimeへ実装され、2026-08-06のWASI Subgroup投票でWASI側の採用が可決([[2026-08-06-wasi]]、→ [[wasi-roadmap]])
- 非推奨だった `canon backpressure.set` 組み込みがCanonical ABI/Explainer/Binaryから削除された。`backpressure.inc`/`backpressure.dec`への一本化が完了([#683](https://github.com/WebAssembly/component-model/commit/d6b48f2))
- README/ExplainerがWASI 0.3.1リリースを踏まえて更新され、asyncのテストスイートも非決定的なyield挙動に依存しないよう調整された([commit](https://github.com/WebAssembly/component-model/commit/349e544e238dfa103a330df7d21ae129f6837014))
- コンポーネント値型に**最大静的サイズの上限**が明文化された。i32/i64いずれのポインタ型でも `elem_size <= 2^28 - 1` をオーバーフロー安全な形で検証するよう要求し、固定長listのサイズ計算が破綻する不具合の芽を塞いだ([#688](https://github.com/WebAssembly/component-model/commit/ce4fb2b9435e1a45ff4403a769f7ef650e92e9cc)、[#682](https://github.com/WebAssembly/component-model/issues/682))
- Canonical ABIの**キャンセレーション配送順序**に関する仕様バグを2件修正。`deliver_pending_cancellation` の呼び出し位置を `stop_waiting_internal` より前に移動し、保留中のキャンセルは可能な限り早く配送されるよう修正された([commit](https://github.com/WebAssembly/component-model/commit/6c67aa1)、[#707](https://github.com/WebAssembly/component-model/commit/1af0b35e1bfc03bd4ad9603be2f676316ff9f420))
- WITの`strongly-unique`(resource名の一意性)規則が**推移的**になるよう明確化([#703](https://github.com/WebAssembly/component-model/commit/a0d6134013bd83563c7477be1b67fcdfa138880d))。あわせて、resourceのメソッドにfeature gateを付けられるよう文法上許可されていなかった不整合を修正([#700](https://github.com/WebAssembly/component-model/commit/1b265a6))

## 関連

- [[wasi-roadmap]]
- [[2026-08-06-wasi]]
- ユーザー向けドキュメント: [component-model.bytecodealliance.org](https://component-model.bytecodealliance.org/)
