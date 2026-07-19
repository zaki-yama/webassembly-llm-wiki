---
title: Compact Import Section
type: proposal
phase: 3
repo: https://github.com/WebAssembly/compact-import-section
updated: 2026-07-19
---

# Compact Import Section

**Phase 3(実装フェーズ)** / Champion: Ryan Hunt(提案発表はBen Visness)

## 一言でいうと

import sectionのバイナリ表現を圧縮する提案。「同じモジュール名からの大量のimport」でモジュール名(や型)の繰り返しを省き、バイナリサイズとパース時間を削減する。

## なぜ必要か(Motivation)

現行のバイナリ形式ではimportごとに `(モジュール名, アイテム名, 型)` の3つ組を毎回書く。`"env"` から1,000個importするモジュールは `"env"` という文字列を1,000回持つことになる。特に **JS String Builtins**(Wasm 3.0でFIX)では文字列定数ごとにimportが要るため、importが数千個に膨れ、1つあたり最低5バイトの冗長分が積み上がる。gzip等の圧縮で緩和はされるが、(a) 展開後のパース時間は変わらず、(b) 圧縮後でも数KBの無駄が残ることが実測([スプレッドシート](https://docs.google.com/spreadsheets/d/1QgA26STK3GRmV10uNqNLvWoHdWhA81sGSVwr0wF_540/edit?gid=0#gid=0))で示されている。

## 仕組み

出典: [Overview.md](https://github.com/WebAssembly/compact-import-section/blob/9a54f93710ae2dc0d431951390df2c94ee0aae42/proposals/compact-import-section/Overview.md)

バイナリに2つの**コンパクトエンコーディング**を追加する(既存形式も有効なまま):

| 形式 | 内容 |
|---|---|
| 既存 | `(モジュール名, アイテム名, 型)` の3つ組 × N |
| コンパクト1 (`0x7F`) | モジュール名1つ + `(アイテム名, 型)` のリスト |
| コンパクト2 (`0x7E`) | モジュール名1つ + 型1つ + アイテム名のリスト(型まで共通の場合) |

- 判別バイト `0x7F`/`0x7E` は既存実装では「unknown import type」エラーになる位置にあり、後方互換(古いエンジンは新形式を明確に拒否)
- オーバーヘッドは3〜4バイトなので、冗長なモジュール名・型が1つでもあればほぼ確実に元が取れる
- テキスト形式にも `(import "mod" (item "foo" ...) (item "bar" ...))` 形式を追加
- **validation・実行セマンティクスへの変更はゼロ**(純粋にエンコーディングの問題)

ASTごと変える案(importをモジュール名でグループ化)は、JS APIの `Module.imports` の互換性を壊すため見送り。新しいsection IDを振る案も、既存形式との混在順序が保存できなくなるため見送った。

## 例

```wat
;; 既存
(import "env" "f1" (func ...))
(import "env" "f2" (func ...))

;; コンパクト形式(モジュール名 "env" を1回だけ書く)
(import "env"
  (item "f1" (func ...))
  (item "f2" (func ...)))
```

## フェーズ遷移

| 時期 | できごと | Phase |
|---|---|---|
| 2024-07-18 | proposals一覧に追加([#191](https://github.com/WebAssembly/proposals/pull/191)) | →1 |
| 2025-11-18 | Phase 2へ([#226](https://github.com/WebAssembly/proposals/pull/226)) | 1→2 |
| 2026-01-13 | CG会合でBen Visnessが実測データとともに発表しPhase 3投票([議事録](https://github.com/WebAssembly/meetings/blob/main/main/2026/CG-2026-01-13.md)、[#228](https://github.com/WebAssembly/proposals/pull/228))。会合では「型の圧縮も入れるか」のstraw pollで22対2で「両方」が支持された | 2→3 |

## 経緯と現状

- JS String Builtinsの普及(Java/Kotlin/DartのGCバックエンドが文字列定数importを大量に吐く)が直接の動機。実測ではimport sectionが最大78KB縮んだ例が報告されている
- 実装状況: [features](https://webassembly.org/features/)

## 関連

- [[js-primitive-builtins]] — import爆発のもう一つの当事者(JSプリミティブのimport組み込み)
- [[finished-proposals]] — JS String Builtins(この提案の主要ユースケース)

## 一次情報

- [Overview.md](https://github.com/WebAssembly/compact-import-section/blob/9a54f93710ae2dc0d431951390df2c94ee0aae42/proposals/compact-import-section/Overview.md)(本ページの主な出典)
- [リポジトリ](https://github.com/WebAssembly/compact-import-section)
