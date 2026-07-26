---
title: WASI ロードマップ
type: wasi
repo: https://github.com/WebAssembly/WASI
updated: 2026-07-26
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

`implements`(名前付きimport)と`external-id`は、2026-07-09のWASI Subgroup会議で実験的にComponent Model仕様とWasmtimeに実装済みと報告された([議事録](https://github.com/WebAssembly/meetings/blob/main/wasi/2026/WASI-07-09.md)、[#613](https://github.com/WebAssembly/component-model/pull/613)、[#672](https://github.com/WebAssembly/component-model/pull/672))。Wasmtimeでは`component-model-implements`フラグの背後で有効化されている。
| 0.3.2 | 2026-10-06 | error context、stream splice/forward |
| 0.3.3 | 2026-12-01 | cooperative threads |

このほかroadmapにはキャンセレーション、`stream<u8>` 系のゼロコピー経路などのテーマが挙がっている。

## 実装

- Wasmtime 43+ と jco が WASI 0.3 をサポート

## その他

- `wasi-gfx` proposalは `wasi-webgpu` に改名([#939](https://github.com/WebAssembly/WASI/commit/6408017)、WASI Subgroupの2026-07-09会議で`wasi:surface`から`wasi:webgpu`への名前空間分離が報告された)
- WASI Phase 2のエントリ要件にOCIレジストリでのWIT公開が追加された(タグはwit中のパッケージバージョン文字列と一致必須。[#938](https://github.com/WebAssembly/WASI/commit/02b8d3b))

## 関連

- [[component-model-overview]]
- WASI proposal一覧: [docs/Proposals.md](https://github.com/WebAssembly/WASI/blob/main/docs/Proposals.md)
