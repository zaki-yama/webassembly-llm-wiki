---
title: Relaxed Dead Code Validation
type: proposal
phase: 2
repo: https://github.com/WebAssembly/relaxed-dead-code-validation
updated: 2026-10-18
---

# Relaxed Dead Code Validation

**Phase 2(仕様文面あり)** / Champion: Conrad Watt and Ross Tate

## 一言でいうと

`unreachable` や `br` の後ろにある**構文的に到達不能なコード**の型検証ルールを緩和し、「型スタックからのpopに依存する検査はすべてスキップする」ことにする提案。

## なぜ必要か(Motivation)

現行仕様では、絶対に実行されないコードにも通常の型検証(の複雑な変種)が要求される。到達不能コードでは型スタックが「任意の型が湧き出る」特殊状態(`t_*`)になり、この状態の型付け規則は仕様・実装の双方で理解しにくく、バリデータ実装のバグ源になってきた。GC提案などで型システムが豊かになるほどこの特殊ケースの複雑さは膨らむ。実行されないコードの検証を頑張っても得られるものは少ない、というのが出発点。

## 仕組み

出典: [Overview.md](https://github.com/WebAssembly/relaxed-dead-code-validation/blob/829ad94dad4c98d94bc2bb6207739d11973ff373/proposals/relaxed-dead-code-validation/Overview.md)

- 到達不能コードでは、**型スタックからのpopに依存する制約を(popごと)スキップ**する。例: 死んだ `ref.is_null` は「スタックトップがnullable参照か」を検査しない
- 引き続き検査するもの:
  - バイナリ形式の構文的制約(即値の最大サイズ等)
  - 型スタックに依存しない検査(`local.get i` の `i` がローカル宣言数の範囲内か等)
- 結果として、バリデータは死んだ領域を「構文だけ確認して読み飛ばす」実装にできる

リポジトリには代替案の検討資料(Push-Pop.md)もある。

## 例

```wat
(func
  (unreachable)
  ;; ここから構文的に到達不能
  (i32.add)       ;; 現行: 特殊な型規則で検証 / 本提案: popに依存する検査なし
  (local.get 5)   ;; ローカルが5個未満なら本提案でも引き続きエラー(スタック非依存の検査)
)
```

## フェーズ遷移

| 時期 | できごと | Phase |
|---|---|---|
| 2020年以前 | 提案(型検証の簡素化議論から) | →1 |
| 2020-11-10 | Phase 2へ([コミット](https://github.com/WebAssembly/proposals/commits/main/README.md)) | 1→2 |

2020年からPhase 2に留まる長期滞留proposal。エンジン実装者の優先度が上がりにくいテーマ(機能追加ではなく検証の簡素化)であることが背景にある。

## 経緯と現状

- Wasm 1.0策定時の「到達不能コードの型付け」論争(type-checking simplicity vs 前方互換性)の後日談にあたる。仕様の形式化を進めるほど現行規則の複雑さが目立つため、簡素化の動機は持続している

- 2026-09-22のCG本会合で30分の議題として約6年ぶりに再浮上した([議事録](https://github.com/WebAssembly/meetings/blob/68fc0aaf0574447b488d2e780ae78b987771e741/main/2026/CG-2026-09-22.md))。動機は当初(型システムの簡素化)から変わり、**実エンジンが仕様から乖離している問題**が出発点: 仕様のvalidationアルゴリズム(付録)は到達不能コード内で`ref.as_non_null`等が「全heap typeのbottom」(`ref bot`)を扱うことを要求するが、Wasmのどのconcrete syntaxにも現れないため、wasm-tools以外のほぼ全実装が実装していない(Thomas Lively調べ。影響するのは標準proposalでは`ref.as_non_null`・`br_on_null`・`br_on_non_null`・`ref.is_null`の関連命令。[spec issue #2235](https://github.com/WebAssembly/spec/issues/2235))
- Conrad Wattが整理した選択肢は3つ: (1) 現行仕様どおりエンジンに`ref bot`を実装させる、(2) 本proposalを採用してWebKit方式(到達不能コードでは型を見ない)を仕様化する、(3) V8の挙動を仕様化するパッチ。WebKit(Keith Miller)は到達不能コードでスタックを一切見ずimmediateのデコードだけ行う実装。Ben Titzer(Wizard)は「まず仕様どおりに実装を試みるべき」、Jakob Kummerow(V8)は「必要なら直すが、dead codeに時間を使いたくない。採用しても反対しない」、Andreas Rossbergは仕様の側で**principal types**と合成性(dead codeのoutlining等)が失われる懸念を述べた
- Ryan Hunt(Mozilla)がHTTP Archiveを走査し、非`end`命令を含むdead codeを持つ実wasmは極めて稀(Dart Wasm GCの1モジュールのみ複雑)でWebcompatリスクは小さいと報告。Conrad Wattは「構文的にdead codeを禁止できないか」とも提起したが、Andreas Rossbergが10年前の議論を蒸し返すべきでないとし、ツール向けの「allow dead code」ホスト hookという案も出たが結論は出ず
- **決定なし**。時間切れで議論はissueに持ち越し。Ben Titzerはdead codeのfuzzing/テストカバレッジ強化を要望、Thomas Livelyは「明確な答えがある」としてissueで続ける意向。フェーズはPhase 2のまま

## 関連

- [[finished-proposals]] — GC/Typed Function References(型システムを複雑化させ、本提案の動機を強めた)

## 一次情報

- [Overview.md](https://github.com/WebAssembly/relaxed-dead-code-validation/blob/829ad94dad4c98d94bc2bb6207739d11973ff373/proposals/relaxed-dead-code-validation/Overview.md)(本ページの主な出典)
- [リポジトリ](https://github.com/WebAssembly/relaxed-dead-code-validation)(Push-Pop.md に代替案)
