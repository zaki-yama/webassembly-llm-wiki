---
title: WASI ロードマップ
type: wasi
repo: https://github.com/WebAssembly/WASI
updated: 2026-07-18
---

# WASI ロードマップ

WASI (WebAssembly System Interface) はブラウザ外でWasmを動かすためのシステムAPI群。
CGの **WASI Subgroup** で開発される。議事録は [meetings/wasi](https://github.com/WebAssembly/meetings/tree/main/wasi)。

## バージョンの流れ

| バージョン | 状態 | 特徴 |
|---|---|---|
| WASI 0.1 (Preview 1) | 広く利用中(レガシー) | witx IDL。POSIX/CloudABI由来 |
| WASI 0.2 (Preview 2) | 安定版 | [[component-model-overview\|Component Model]] + Wit IDLベースに全面再設計。モジュール化 |
| WASI 0.3 (Preview 3) | **現行プレビュー。0.3.0 が 2026-06-11 リリース** | Component Modelネイティブの `async` / `stream<T>` / `future<T>` により非同期を言語横断で統合 |

## 0.3.x の今後(リリーストレイン)

[wasi.dev/roadmap](https://wasi.dev/roadmap) によると、0.3.0以降は後方互換な0.3.xを継続的にリリースする方針。

2026-06-25のWASI Subgroup会議([[2026-06-25-wasi]])で暫定スケジュールが示された:

| バージョン | 予定日 | 内容 |
|---|---|---|
| 0.3.1 | 2026-08-04 | maps、implements、fixed-length lists |
| 0.3.2 | 2026-10-06 | error context、stream splice/forward |
| 0.3.3 | 2026-12-01 | cooperative threads |

このほかroadmapにはキャンセレーション、`stream<u8>` 系のゼロコピー経路などのテーマが挙がっている。

## 実装

- Wasmtime 43+ と jco が WASI 0.3 をサポート

## 関連

- [[component-model-overview]]
- WASI proposal一覧: [docs/Proposals.md](https://github.com/WebAssembly/WASI/blob/main/docs/Proposals.md)
