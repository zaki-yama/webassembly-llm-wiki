---
title: Acquire-Release Atomics
type: proposal
phase: 2
repo: https://github.com/WebAssembly/acquire-release-atomics
families: [concurrency]
updated: 2026-08-09
---

# Acquire-Release Atomics

**Phase 2(仕様文面あり)** / Champion: Conrad Watt & Rezvan Mahdavi Hezaveh

> 2026-08-06に "Relaxed Atomics" から改名された([WebAssembly/proposals#238](https://github.com/WebAssembly/proposals/commit/c7d99fdb901f7695a88d27882fccc3a4031dc39c)、[WebAssembly/relaxed-atomics#8](https://github.com/WebAssembly/relaxed-atomics/commit/2b1d87e))。リポジトリも `WebAssembly/relaxed-atomics` から `WebAssembly/acquire-release-atomics` に改称。技術的内容(acqrelオーダリングと`pause`命令)は変わらず、名前が実態(relaxed orderingではなくacquire-release ordering)に合わせて訂正された形。フェーズはPhase 2のまま。

## 一言でいうと

[[threads]] のアトミック命令(すべて逐次一貫=seqcst)に、より弱い **acquire-release(`acqrel`)オーダリング**と、スピンロック効率化のための **`pause` 命令**を追加する提案。

## なぜ必要か(Motivation)

seqcstは推論しやすい代わりに、weak orderingのハードウェア(ARM等)では重いバリアを要求する。C/C++/Rustの `memory_order_acquire/release` を使う並行データ構造は、Wasmに落とすと全部seqcstに格上げされて性能を失う。またJavaやOCamlのような「より強いメモリモデルを持つGC言語」をWasm GCで動かす際の基盤としても、中間の強さのオーダリングが必要になる([[shared-everything-threads]] が本提案のacqrelをGC共有アクセスに使う想定)。

## 仕組み

出典: [Overview.md](https://github.com/WebAssembly/acquire-release-atomics/blob/2b1d87e/proposals/acquire-release-atomics/Overview.md)

| 要素 | 説明 |
|---|---|
| `acqrel` オーダリング | 既存の線形メモリアトミック命令に追加される新しいオーダリング。**acquire load**(後続アクセスがこれより前に並び替わらない)/ **release store**(先行アクセスがこれより後に並び替わらない)/ acqrelフェンス |
| `pause` | スピンロックのビジーウェイトループに入れるヒント命令(x86の `pause`、ARMの `yield` 相当)。セマンティクス上はno-opで、電力効率とハイパースレッド性能を改善 |
| 将来への開放 | [[shared-everything-threads]] などの後続proposalが自分のアトミック操作(GC共有データ等)にacqrelをopt-inできるよう設計 |

改名前は「relaxed」を名乗っていたが、C++の `memory_order_relaxed`(完全無順序)は本提案の範囲外で、中心はacqrelのみ。無順序アトミクスの形式化(out-of-thin-air問題)は学術的にも難しく、threads提案時代からの継続課題。

## フェーズ遷移

| 時期 | できごと | Phase |
|---|---|---|
| 2023-10 | 対面CG会合の「Post-MVP threads discussion」でPhase 1投票(shared-everything-threadsと同源の議論)([議事録](https://github.com/WebAssembly/meetings/blob/main/main/2023/CG-10.md)) | →1 |
| 2026-06-04 | Phase 2としてproposals READMEに記載("Relaxed Atomics"名義、[#233](https://github.com/WebAssembly/proposals/pull/233)) | 1→2 |
| 2026-08-06 | "Relaxed Atomics" から "Acquire-Release Atomics" に改名(proposals README・リポジトリとも)。2026-08-04〜05のCG対面会合アジェンダにあった「Phase 3投票の可能性」は見送られ、改名のみ実施([proposals #238](https://github.com/WebAssembly/proposals/commit/c7d99fdb901f7695a88d27882fccc3a4031dc39c)、[relaxed-atomics #8](https://github.com/WebAssembly/relaxed-atomics/commit/2b1d87e)) | 2のまま |

## 経緯と現状

- [[threads]] がPhase 4に進む過程で「弱いオーダリングは分離して別proposalに」と整理された、threadsの正式な続編
- 形式メモリモデル(threadsのseqcstモデルの拡張)が仕様面の中心作業
- 2026-08-04〜05のCG対面会合(Siemens主催)のアジェンダには「Relaxed Atomics Update and possible Phase 3 vote」が組まれていたが、実際に行われたのは名称変更のみで、Phase 3への移行はまだ確認できていない([CG-2026-08.md](https://github.com/WebAssembly/meetings/blob/main/main/2026/CG-2026-08.md))
- 2026-08-06、`webassembly.org/features` の対象にも追加。Chromeは`--js-flags=--experimental-wasm-acquire-release`フラグの背後で対応、Binaryenはフラグなしで対応([website features.json commit](https://github.com/WebAssembly/website/commit/e10d87461277041bedce8871ff86f4cadde14103))

## 関連

- [[threads]] — 前提となる基盤(seqcstアトミクス)
- [[shared-everything-threads]] — 本提案のオーダリングを利用する後続

## 一次情報

- [Overview.md](https://github.com/WebAssembly/acquire-release-atomics/blob/2b1d87e/proposals/acquire-release-atomics/Overview.md)(本ページの主な出典)
- [リポジトリ](https://github.com/WebAssembly/acquire-release-atomics)
