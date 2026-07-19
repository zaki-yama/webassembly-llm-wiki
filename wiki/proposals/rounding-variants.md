---
title: Rounding Variants
type: proposal
phase: 2
repo: https://github.com/WebAssembly/rounding-mode-control
updated: 2026-07-19
---

# Rounding Variants

**Phase 2(仕様文面あり)** / Champion: Kloud Koder

## 一言でいうと

浮動小数点の基本演算(add/sub/mul/div/sqrt/変換)に、**丸め方向を命令名に埋め込んだバリアント**(`_ceil` / `_floor` / `_trunc`)を追加する提案。

## なぜ必要か(Motivation)

IEEE 754は「最近接偶数丸め」以外に上向き・下向き・ゼロ方向丸めを定義しており、**区間演算**(結果の上下界を保証する数値計算)や再現性が要求される科学計算はこれらを必要とする。ネイティブではFPUの丸めモードレジスタを切り替えられるが、Wasmには丸めモードの概念がなく、ソフトウェアエミュレーションは極端に遅い。動的な「モードレジスタ」を導入するとエンジンの最適化を阻害するため、**丸め方向を静的に命令へ焼き込む**設計を採る。

## 仕組み

出典: [Overview.md](https://github.com/WebAssembly/rounding-mode-control/blob/b07cb1c1f2d45991b6c8429d814790abad899245/proposals/rounding-mode-control/Overview.md)

- 既存の `f32/f64` の `sqrt` `add` `sub` `mul` `div`、整数⇔浮動小数変換、`demote`/`promote` に対し、`_ceil` / `_floor` / `_trunc` サフィックス付きの命令を`0xFC`プレフィックス空間に追加(例: `f64.add_floor`、`f32.convert_trunc_i32_s`、`f64.promote_trunc_f32`)
- セマンティクスはIEEE準拠で数学的に定義: `O.f_I_floor(x) = max { y ∈ O | y ≤ F(x) }`(Fは正確な数学関数)。ゼロの符号の扱いも明示定義
- 動的モード切替は導入しない(命令ごとに丸めが静的に決まるので、エンジンは命令選択だけで対応できる)

## フェーズ遷移

| 時期 | できごと | Phase |
|---|---|---|
| 2023-10-12 | proposals一覧に記録([#174](https://github.com/WebAssembly/proposals/pull/174)) | →1 |
| 2025-01-28 | Phase 2へ([#201](https://github.com/WebAssembly/proposals/pull/201)) | 1→2 |

## 経緯と現状

- ユースケースが専門的(区間演算・数値検証)なため、汎用エンジンでの実装優先度は高くない。命令数が多い(全組み合わせで約60命令)ことも議論点で、冗長な組み合わせを削る検討がOverviewに含まれる

## 関連

- [[wide-arithmetic]] — 同じく数値計算系のニッチを埋めるproposal

## 一次情報

- [Overview.md](https://github.com/WebAssembly/rounding-mode-control/blob/b07cb1c1f2d45991b6c8429d814790abad899245/proposals/rounding-mode-control/Overview.md)(本ページの主な出典)
- [リポジトリ](https://github.com/WebAssembly/rounding-mode-control)
