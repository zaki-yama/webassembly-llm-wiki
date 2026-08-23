---
title: Extended Name Section
type: proposal
phase: 2
repo: https://github.com/WebAssembly/extended-name-section
updated: 2026-08-23
---

# Extended Name Section

**Phase 2(仕様文面あり)** / Champion: Ben Visness(2025-11に交代)

## 一言でいうと

デバッグ用のname custom sectionに新しいサブセクションを追加し、**テキスト形式で名前を付けられるすべての実体**(ラベル・テーブル・メモリ・グローバル・elem/data segment)にバイナリでも名前を持たせられるようにする提案。

## なぜ必要か(Motivation)

現行のname sectionはモジュール・関数・ローカル(および後の拡張で型・フィールド・タグ)しか名前を持てない。一方テキスト形式では `$myGlobal` や `$myLabel` のように多くの実体に名前を付けられる。バイナリに落とすとこれらの名前が消えるため、デバッガ・逆アセンブラ・DevToolsの表示が `global[3]` のようなインデックスになり可読性が落ちる。wasm-to-wat往復でも情報が失われる。

## 仕組み

出典: [Overview.md](https://github.com/WebAssembly/extended-name-section/blob/d4af276/proposals/extended-name-section/Overview.md)

name custom sectionに以下のサブセクションを追加する:

| サブセクション | ID | 形式 |
|---|---|---|
| label names | 3 | 関数インデックスでグループ化したindirect name map。**関数全体で通しのラベルインデックス空間**を新設(仕様のスコープ付きlabelidxとは別物) |
| table names | 5 | name map |
| memory names | 6 | name map |
| global names | 7 | name map |
| element segment names | 8 | name map |
| data segment names | 9 | name map |

custom sectionのため**セマンティクスへの影響はゼロ**。既存のname section(ID 0/1/2ほか)との共存も自明。

## フェーズ遷移

| 時期 | できごと | Phase |
|---|---|---|
| 2019-07-11 | proposals一覧に追加 | →1 |
| 2023-08-16 | Phase 2へ([#169](https://github.com/WebAssembly/proposals/pull/169)) | 1→2 |
| 2025-11-11 | championがBen Visnessに交代([#224](https://github.com/WebAssembly/proposals/pull/224)) | - |

## 経緯と現状

- ツール(wasm-tools、wabt、binaryen)やブラウザDevToolsでは既にデファクトとして実装が進んでいる部分もあり、仕様の追認に近い性格
- custom section系のためエンジンの実行系には影響せず、フェーズ進行は主にツールエコシステムのテスト整備次第
- 2026-08-13、Overview.mdの文面が整理された(意味論変更なし)。「elem names」「data names」の表記を「element segment names」「data segment names」に統一し、動機説明にテキスト形式の `@name` アノテーションが二進形式のname sectionと同期していない点を明記([commit](https://github.com/WebAssembly/extended-name-section/commit/d4af276))

## 関連

- [[wat-numeric-values]] — 同じく開発体験・ツール系
- [[compilation-hints]] — custom sectionを使う別系統(こちらは性能ヒント)

## 一次情報

- [Overview.md](https://github.com/WebAssembly/extended-name-section/blob/d4af276/proposals/extended-name-section/Overview.md)(本ページの主な出典)
- [リポジトリ](https://github.com/WebAssembly/extended-name-section)
