---
title: Relaxed Dead Code Validation
type: proposal
phase: 2
repo: https://github.com/WebAssembly/relaxed-dead-code-validation
updated: 2026-07-19
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

## 関連

- [[finished-proposals]] — GC/Typed Function References(型システムを複雑化させ、本提案の動機を強めた)

## 一次情報

- [Overview.md](https://github.com/WebAssembly/relaxed-dead-code-validation/blob/829ad94dad4c98d94bc2bb6207739d11973ff373/proposals/relaxed-dead-code-validation/Overview.md)(本ページの主な出典)
- [リポジトリ](https://github.com/WebAssembly/relaxed-dead-code-validation)(Push-Pop.md に代替案)
