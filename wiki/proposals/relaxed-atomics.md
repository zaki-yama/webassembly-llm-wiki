---
title: Relaxed Atomics
type: proposal
phase: 2
repo: https://github.com/WebAssembly/relaxed-atomics
families: [concurrency]
updated: 2026-07-19
---

# Relaxed Atomics

**Phase 2(仕様文面あり)** / Champion: Conrad Watt & Rezvan Mahdavi Hezaveh

## 一言でいうと

[[threads]] のアトミック命令(すべて逐次一貫=seqcst)に、より弱い **acquire-release(`acqrel`)オーダリング**と、スピンロック効率化のための **`pause` 命令**を追加する提案。

## なぜ必要か(Motivation)

seqcstは推論しやすい代わりに、weak orderingのハードウェア(ARM等)では重いバリアを要求する。C/C++/Rustの `memory_order_acquire/release` を使う並行データ構造は、Wasmに落とすと全部seqcstに格上げされて性能を失う。またJavaやOCamlのような「より強いメモリモデルを持つGC言語」をWasm GCで動かす際の基盤としても、中間の強さのオーダリングが必要になる([[shared-everything-threads]] が本提案のacqrelをGC共有アクセスに使う想定)。

## 仕組み

出典: [Overview.md](https://github.com/WebAssembly/relaxed-atomics/blob/577af5822847a2975a27e7a7905f73041adc2899/proposals/relaxed-atomics/Overview.md)

| 要素 | 説明 |
|---|---|
| `acqrel` オーダリング | 既存の線形メモリアトミック命令に追加される新しいオーダリング。**acquire load**(後続アクセスがこれより前に並び替わらない)/ **release store**(先行アクセスがこれより後に並び替わらない)/ acqrelフェンス |
| `pause` | スピンロックのビジーウェイトループに入れるヒント命令(x86の `pause`、ARMの `yield` 相当)。セマンティクス上はno-opで、電力効率とハイパースレッド性能を改善 |
| 将来への開放 | [[shared-everything-threads]] などの後続proposalが自分のアトミック操作(GC共有データ等)にacqrelをopt-inできるよう設計 |

「relaxed」という名前だが、C++の `memory_order_relaxed`(完全無順序)を入れるかは慎重に議論されており、まずacqrelが中心。無順序アトミクスの形式化(out-of-thin-air問題)は学術的にも難しく、threads提案時代からの継続課題。

## フェーズ遷移

| 時期 | できごと | Phase |
|---|---|---|
| 2023-10 | 対面CG会合の「Post-MVP threads discussion」でPhase 1投票(shared-everything-threadsと同源の議論)([議事録](https://github.com/WebAssembly/meetings/blob/main/main/2023/CG-10.md)) | →1 |
| 2026-06-04 | Phase 2としてproposals READMEに記載([#233](https://github.com/WebAssembly/proposals/pull/233)) | 1→2 |

## 経緯と現状

- [[threads]] がPhase 4に進む過程で「弱いオーダリングは分離して別proposalに」と整理された、threadsの正式な続編
- 形式メモリモデル(threadsのseqcstモデルの拡張)が仕様面の中心作業

## 関連

- [[threads]] — 前提となる基盤(seqcstアトミクス)
- [[shared-everything-threads]] — 本提案のオーダリングを利用する後続

## 一次情報

- [Overview.md](https://github.com/WebAssembly/relaxed-atomics/blob/577af5822847a2975a27e7a7905f73041adc2899/proposals/relaxed-atomics/Overview.md)(本ページの主な出典)
- [リポジトリ](https://github.com/WebAssembly/relaxed-atomics)
