---
title: Numeric Values in WAT Data Segments
type: proposal
phase: 2
repo: https://github.com/WebAssembly/wat-numeric-values
updated: 2026-07-19
---

# Numeric Values in WAT Data Segments

**Phase 2(仕様文面あり)** / Champion: Ezzat Chamudi

## 一言でいうと

テキスト形式(WAT)のdata segmentに、文字列リテラルだけでなく**数値のリスト**を書けるようにする提案。テキスト形式だけの変更で、バイナリ形式・セマンティクスへの影響はない。

## なぜ必要か(Motivation)

現状、data segmentの初期値は文字列(`"\09\ab\cd\ef"` のようなエスケープ)でしか書けない。浮動小数点数の表や整数配列をメモリに置きたいとき、人間が手でIEEE 754のバイト列に変換して書くのは現実的でなく、可読性も皆無。数値をそのまま書ければ、手書きWATやコード生成・教材でメモリ初期値を自然に表現できる。

## 仕組み

出典: [Overview.md](https://github.com/WebAssembly/wat-numeric-values/blob/6af2f33d2860390345e31580908cb4670730600e/proposals/wat-numeric-values/Overview.md)

data segment内に型付きの数値リスト構文を追加する:

```wat
(data (offset (i32.const 0))
  (f32 0.2 0.3 0.4)   ;; → cdcc4c3e 9a99993e cdcccc3e(リトルエンディアン)
)
(memory $1
  (data (i8 1 2))      ;; → 0102
)
```

- 使える型: `i8` / `i16` / `i32` / `i64` / `f32` / `f64`(整数はビット幅ごと、浮動小数はIEEE 754表現に変換)
- 文字列形式と混在可能
- **バイナリ形式は不変**(アセンブル時にバイト列へ変換されるだけ)。validation・実行への変更なし

## フェーズ遷移

| 時期 | できごと | Phase |
|---|---|---|
| 2019頃 | 提案 | →1 |
| 2020-11-24 | Phase 2へ([#92](https://github.com/WebAssembly/proposals/pull/92)) | 1→2 |

2020年からPhase 2の長期滞留proposal。ツール(wabt等)での実装が主な残作業だが、テキスト形式のみの小粒な変更のため優先度が上がりにくい。

## 経緯と現状

- 影響範囲がテキスト形式のツールチェーン(wat2wasm、wasm-tools等)に限られるため、エンジン側の作業はない
- 類似の「テキスト形式の書き味改善」系としては、アノテーション構文(Wasm 3.0でFIX)がある

## 関連

- [[extended-name-section]] — 同じく「開発体験・ツール向け」系のproposal

## 一次情報

- [Overview.md](https://github.com/WebAssembly/wat-numeric-values/blob/6af2f33d2860390345e31580908cb4670730600e/proposals/wat-numeric-values/Overview.md)(本ページの主な出典)
- [リポジトリ](https://github.com/WebAssembly/wat-numeric-values)
