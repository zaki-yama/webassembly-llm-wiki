---
title: Compilation Hints
type: proposal
phase: 2
repo: https://github.com/WebAssembly/compilation-hints
updated: 2026-07-26
---

# Compilation Hints

**Phase 2(仕様文面あり)** / Champion: Emanuel Ziegler

## 一言でいうと

custom sectionを通じて、エンジンに**コンパイル戦略のヒント**(どの関数をどのtierでコンパイルすべきか、呼び出し頻度、インライン化候補など)を渡せるようにする提案。セマンティクスへの影響はゼロで、純粋な性能改善。

## なぜ必要か(Motivation)

エンジンは「どの関数をベースラインで済ませ、どれを最適化コンパイルするか」をヒューリスティクスと実行時フィードバックで決めているが、前者は粗い近似で、後者は収集に時間と計測コストがかかる。ソース解析・AOT分析・事前プロファイリングで得た情報をモジュールに添付できれば、エンジンは最初から良い判断ができる。ネイティブのPGOと違い、**Wasmはモジュール生成後にヒントだけ追記・差し替えできる**(再コンパイル不要)のも利点で、利用シーンごとに異なるヒントを持たせる運用も可能。

## 仕組み

出典: [Overview.md](https://github.com/WebAssembly/compilation-hints/blob/89e67030f433ac3faa38b7347721c2e333395ed0/proposals/compilation-hints/Overview.md)

Branch Hinting(Wasm 3.0でFIX)の枠組みを拡張し、`metadata.code.*` という命名規約のcustom section群としてヒントを定義する:

- 各セクションは「関数インデックス+(バイトオフセット, ヒント長, ヒント内容)のリスト」という共通構造(オフセット0は関数レベルのヒント)
- ヒントの種類(検討中のものを含む): コンパイル優先順位、実行頻度、インライン化、tier選択など
- custom sectionなので**未対応エンジンは無視するだけ**。annotations(Wasm 3.0)との統合でテキスト形式との往復も保てる

## フェーズ遷移

| 時期 | できごと | Phase |
|---|---|---|
| 2024-02-21 | Phase 1でproposals一覧に追加([#179](https://github.com/WebAssembly/proposals/pull/179)) | →1 |
| 2025-02-19 | Phase 2へ([#204](https://github.com/WebAssembly/proposals/pull/204)) | 1→2 |

2023-10の対面CG会合でV8チーム(Emanuel Ziegler)が最初の構想を発表している([議事録](https://github.com/WebAssembly/meetings/blob/main/main/2023/CG-10.md)のWasm compilation hintsセッション)。

## 経緯と現状

- V8での実験実装が先行。大規模Wasmアプリ(Photoshop等)の起動時間問題が実務的背景
- 「ヒントの種類をどこまで標準化するか」(エンジン固有にしない範囲)が主要な設計論点
- 2026-07-20、WasmtimeがBranch Hintingサポートをフラグ付きで更新([commit](https://github.com/WebAssembly/website/commit/80da839)、[v46.0.0](https://github.com/bytecodealliance/wasmtime/releases/tag/v46.0.0))。本提案の前身であるBranch Hintingのエンジン対応が広がりつつある

## 関連

- [[finished-proposals]] — Branch Hinting(本提案の直接の前身)/ Custom Annotation Syntax(テキスト形式統合)
- [[extended-name-section]] — 同じくcustom section系

## 一次情報

- [Overview.md](https://github.com/WebAssembly/compilation-hints/blob/89e67030f433ac3faa38b7347721c2e333395ed0/proposals/compilation-hints/Overview.md)(本ページの主な出典)
- [リポジトリ](https://github.com/WebAssembly/compilation-hints)
