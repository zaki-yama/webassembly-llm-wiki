---
title: WASI ロードマップ
type: wasi
repo: https://github.com/WebAssembly/WASI
updated: 2026-08-09
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

2026-06-25のWASI Subgroup会議([[2026-06-25-wasi]])では「隔月・第1火曜」ベースの暫定スケジュール(0.3.1=2026-08-04など)が示されていたが、2026-08-06に `docs/Release.md` が新設され、**隔月・第2火曜**を正式なリリーストレインとして文書化する形に変わった([commit](https://github.com/WebAssembly/WASI/commit/a72eb0926f05c912a81bcd6dde6c1e0231878c30))。2026-07-23のWASI Subgroup会議で、0.2.x時代からの慣例だった第1火曜のままだと採用予定の新機能(maps/implements等)に対する投票の時間が取れないため、1週間後ろ倒しして第2火曜に揃える案が議論された([議事録](https://github.com/WebAssembly/meetings/blob/main/wasi/2026/WASI-07-23.md))。

| バージョン | 予定日 | 内容 |
|---|---|---|
| 0.3.0 | 2026-06-11(one-off) | 初回プレビューリリース |
| 0.3.1 | 2026-08-11 | maps(`map<t>`)、implements(名前付きimport)、fixed-length lists(`list<t, n>`)。いずれも下記「Component Model機能の採用プロセス」に基づく採否投票待ち |
| 0.3.2 | 2026-10-13 | error context、stream splice/forward |
| 0.3.3 | 2026-12-08 | cooperative threads |
| 0.3.4〜0.3.9 | 2027-02-09、04-13、06-08、08-10、10-12、12-14(いずれも第2火曜) | 未定 |

`implements`(名前付きimport)と`external-id`は、2026-07-09のWASI Subgroup会議で実験的にComponent Model仕様とWasmtimeに実装済みと報告された([議事録](https://github.com/WebAssembly/meetings/blob/main/wasi/2026/WASI-07-09.md)、[#613](https://github.com/WebAssembly/component-model/pull/613)、[#672](https://github.com/WebAssembly/component-model/pull/672))。Wasmtimeでは`component-model-implements`フラグの背後で有効化されている。`map<t>`はABI変更を必要とせずJcoで実装済みと報告されている([WASI-07-23議事録](https://github.com/WebAssembly/meetings/blob/main/wasi/2026/WASI-07-23.md))。

このほかroadmapにはキャンセレーション、`stream<u8>` 系のゼロコピー経路などのテーマが挙がっている。

## Component Model機能の採用プロセス(新設)

2026-08-06、`CONTRIBUTING.md` と `.github/RELEASE.md` に、WASIがComponent Model側のgated feature(絵文字タグで管理される新WIT構文・型・canonical ABI機能)に依存する際の正式な手続きが追加された([commit](https://github.com/WebAssembly/WASI/commit/a72eb0926f05c912a81bcd6dde6c1e0231878c30))。従来、WASI proposalの `@unstable` → `@since` 昇格にはPhase 3投票が必要だったが、それとは別に「WASIの`@since`ゲート済みAPIが特定のCM機能に依存してよいか」もWASI Subgroupの投票事項として明文化された。

- CM機能が採用対象になるのは**安定**した場合のみ:設計が固まり破壊的変更が見込まれない、かつ複数ランタイム/ツールチェインでの実装とプレリリース版での実運用フィードバックを経ていること
- 手順: (1) 安定化前は `0.3.0-rc-*` 等のプレリリース版、または未出荷のWASI proposalでのみ実験的に利用可。安定版リリーストレインはその機能なしで実装可能な状態を保つ (2) 対象のCM機能・依存するWASI API・実装実績をissueとして提出 (3) WASI Subgroup会議のアジェンダにフェーズ昇格投票と同様の形で採否投票を追加 (4) 可決後、次リリースの`@since` APIがそのCM機能に依存可能になり、リリースノートに明記される
- 2026-08-06のWASI Subgroup会議で、このプロセスの初適用として **`map<t>`**([WASI#943](https://github.com/WebAssembly/WASI/issues/943))と **`implements`アノテーション**([WASI#942](https://github.com/WebAssembly/WASI/issues/942))の採否投票がアジェンダに上がった。本ページ執筆時点(2026-08-09)では議事録に投票結果の記載はまだない([WASI-08-06議事録](https://github.com/WebAssembly/meetings/blob/main/wasi/2026/WASI-08-06.md))

## 実装

- Wasmtime 43+ と jco が WASI 0.3 をサポート

## その他

- `wasi-gfx` proposalは `wasi-webgpu` に改名([#939](https://github.com/WebAssembly/WASI/commit/6408017)、WASI Subgroupの2026-07-09会議で`wasi:surface`から`wasi:webgpu`への名前空間分離が報告された)
- WASI Phase 2のエントリ要件にOCIレジストリでのWIT公開が追加された(タグはwit中のパッケージバージョン文字列と一致必須。[#938](https://github.com/WebAssembly/WASI/commit/02b8d3b))
- wasi-http: `fields` リソースのフィールド名は取得時には元のケース(大文字・小文字)を保持する必要があるが、**転送時にシリアライズする際は別のケースを使ってよい**と緩和された。HPACK静的テーブル(RFC 7541 Appendix A、フィールド名は小文字)を活用した効率的な符号化を妨げないための変更([#926](https://github.com/WebAssembly/WASI/commit/7264983))

## 関連

- [[component-model-overview]]
- WASI proposal一覧: [docs/Proposals.md](https://github.com/WebAssembly/WASI/blob/main/docs/Proposals.md)
