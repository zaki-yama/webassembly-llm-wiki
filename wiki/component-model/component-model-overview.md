---
title: Component Model
type: component-model
phase: 1
repo: https://github.com/WebAssembly/component-model
updated: 2026-09-13
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

## 仕様文書の細かな変更(2026-08〜09時点)

- テキスト形式のインデックス解析規則(index spaces節)がExplainer内で整理・明確化された(意味論変更なし。[#655](https://github.com/WebAssembly/component-model/commit/1d20b88))
- `realloc`呼び出しは新規スレッド上で実行されると定義された([#680](https://github.com/WebAssembly/component-model/pull/680))
- `implements`(名前付きimport)・`external-id`が実験的にspec/Wasmtimeへ実装され、2026-08-06のWASI Subgroup投票でWASI側の採用が可決([[2026-08-06-wasi]]、→ [[wasi-roadmap]])
- 非推奨だった `canon backpressure.set` 組み込みがCanonical ABI/Explainer/Binaryから削除された。`backpressure.inc`/`backpressure.dec`への一本化が完了([#683](https://github.com/WebAssembly/component-model/commit/d6b48f2))
- README/ExplainerがWASI 0.3.1リリースを踏まえて更新され、asyncのテストスイートも非決定的なyield挙動に依存しないよう調整された([commit](https://github.com/WebAssembly/component-model/commit/349e544e238dfa103a330df7d21ae129f6837014))
- コンポーネント値型に**最大静的サイズの上限**が明文化された。i32/i64いずれのポインタ型でも `elem_size <= 2^28 - 1` をオーバーフロー安全な形で検証するよう要求し、固定長listのサイズ計算が破綻する不具合の芽を塞いだ([#688](https://github.com/WebAssembly/component-model/commit/ce4fb2b9435e1a45ff4403a769f7ef650e92e9cc)、[#682](https://github.com/WebAssembly/component-model/issues/682))
- Canonical ABIの**キャンセレーション配送順序**に関する仕様バグを2件修正。`deliver_pending_cancellation` の呼び出し位置を `stop_waiting_internal` より前に移動し、保留中のキャンセルは可能な限り早く配送されるよう修正された([commit](https://github.com/WebAssembly/component-model/commit/6c67aa1)、[#707](https://github.com/WebAssembly/component-model/commit/1af0b35e1bfc03bd4ad9603be2f676316ff9f420))
- WITの`strongly-unique`(resource名の一意性)規則が**推移的**になるよう明確化([#703](https://github.com/WebAssembly/component-model/commit/a0d6134013bd83563c7477be1b67fcdfa138880d))。あわせて、resourceのメソッドにfeature gateを付けられるよう文法上許可されていなかった不整合を修正([#700](https://github.com/WebAssembly/component-model/commit/1b265a6))
- **リエントランスモデルの再設計**(2026-08、[#705](https://github.com/WebAssembly/component-model/commit/2f13265)): Canonical ABIから`ComponentInstance.may_enter`フラグと、それを親子関係(`parent`フィールド)を辿って判定する`may_enter_from`/`enter_from`/`leave_to`トラップ機構を全廃。旧Component Invariant #2(donut wrappingでの再入時のみ特別扱いしトラップで防ぐ)と#3(オプトインしない限りコア間実行を暗黙にシリアライズする)を**単一の#2「run-to-completion」則**に統合し、`Store.nesting_depth`ベースの単純なアサーションで代替した。結果として、donut wrapping(親コンポーネントが子を経由して自分に再入する)はホストからの再入と対等に扱われ、**トラップで防がれる特別な再入ケースがなくなった**(再入自体は禁止されず、backpressureによる直列化のみが安全網)。[[wasi-roadmap]]の実装(Wasmtime等)経由でボトムアップに波及しうる変更のため、次回以降のエンジン実装状況で追跡
- CABI: `future.drop-readable`を保留中の書き込みがある状態で呼べるようにするバグ修正(`SharedFutureImpl.drop`が誤って`WritableBuffer`を assert していた。[#708](https://github.com/WebAssembly/component-model/commit/4acb0de))
- WITの`strongly-unique`判定が**ハイフン非依存**になるよう変更(`foo-bar`と`foobar`は同一名とみなされ共存不可。[#704](https://github.com/WebAssembly/component-model/commit/0036fe1))
- WIT `use-names-list`で末尾カンマを許可([#714](https://github.com/WebAssembly/component-model/commit/50a1ab9))
- **キャンセレーション配送モデルの簡素化**(2026-09、[#716](https://github.com/WebAssembly/component-model/commit/8892da0) "Remove 'cancellable' immediate from built-ins"): `waitable-set.wait`/`waitable-set.poll`および`thread.suspend`/`thread.yield`/`thread.suspend-then-resume`等の`thread.*`系組み込みから`cancellable`免除引数を全廃。`task-cancelled`イベントは今後**stackless `callback` ABIを使う`async`関数にのみ**配送され、stackful ABI向けの配送機構は将来課題(TODO)に据え置かれた。あわせて`subtask.cancel`は、呼び出し先タスクにノンブロッキングの協調的`thread.yield`を発行してキャンセル要求の配送を試みる形に変更され、既に解決通知済み・キャンセル要求済み・待機集合に登録済みの場合はトラップするよう厳格化された
- 値型に**`map`と固定長list(`fixed-length list`)のエンコーディング**を新規定義(2026-09、[#712](https://github.com/WebAssembly/component-model/commit/a70dae6) "define map and fixed-length list value encoding"、🗺️/🔧絵文字タグ)。WAT値リテラル構文として `(map (entry "a" 1) (entry "b" 2))` 等の例が追加された
- Canonical interface nameのバージョン正規化規則を調整(2026-09、[#711](https://github.com/WebAssembly/component-model/commit/cfc0266) "Adjust rules for canonical interface names"): build metadata(`+foo`)は常にsemversuffixとして分離、pre-release版(`0.0.1-alpha`等)はバージョン自体を分割しない扱いに変更(従来はpatch直後で分割していた)
- `thread.suspend-then-resume`/`thread.suspend-then-promote`等の`-then-*`系組み込みで、対象スレッド`t`が呼び出し元スレッド自身の場合の挙動を明確化しトラップとして定義(2026-09、[#687](https://github.com/WebAssembly/component-model/commit/7c67611))
- WITに**getter/setter構文糖衣**(新gated feature 📡)を追加(2026-09-08、[#701](https://github.com/WebAssembly/component-model/pull/701) "Add getters and setters (#235)")。`func`キーワードの代わりに`get`/`set`を使うと`[get]`/`[set]`アノテーション付きの通常関数に脱糖される(例: `bar: get() -> u64;` / `bar: set(v: u64);` → `[get]bar: func() -> u64;` / `[set]bar: func(v: u64);`)。resource内でも`static`と組み合わせ可能。getterは無引数で戻り値必須、setterは引数1つで戻り値なし(または`result<_, error?>`)、setterには同名のgetterが必須。strongly-unique判定では`[set]`アノテーションは(`[constructor]`と同様に)区別を残す例外として扱われる

## 関連

- [[wasi-roadmap]]
- [[2026-08-06-wasi]]
- ユーザー向けドキュメント: [component-model.bytecodealliance.org](https://component-model.bytecodealliance.org/)
