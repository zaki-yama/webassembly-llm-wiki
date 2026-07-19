---
title: ESM Integration
type: proposal
phase: 3
repo: https://github.com/WebAssembly/esm-integration
families: [js-interop]
updated: 2026-07-19
---

# ESM Integration

**Phase 3(実装フェーズ)** / Champion: Asumu Takikawa, Ms2ger & Guy Bedford

## 一言でいうと

WasmモジュールをJSの**ESモジュールとして** `import` できるようにする提案。`import { foo } from "./mod.wasm"` や `<script type=module>` でWasmがモジュールグラフの一部として解決・インスタンス化される。

## なぜ必要か(Motivation)

現在のWasmロードは命令的なJS API(`fetch` → importオブジェクト組み立て → `WebAssembly.instantiateStreaming`)を毎回手書きする必要がある。宣言的な `import` にすることで:

- **エルゴノミクス**: `import { foo } from "./myModule.wasm"; foo();` の2行になる
- **ツールチェーンの統一**: webpack / Rollup / Parcel が各々独自実装してきた「WasmをESMとして扱う」挙動を標準化し、静的解析と相互運用を可能にする

TC39の [Source Phase Imports](https://github.com/tc39/proposal-source-phase-imports)(`import source`)と連携し、「モジュール解決・取得はESMに任せつつ、インスタンス化は自分でやる」パターンも提供する。

## 仕組み

出典: [README.md](https://github.com/WebAssembly/esm-integration/blob/798588074fc599ed05061e921aa64ce36d0495ac/proposals/esm-integration/README.md)

| 要素 | 説明 |
|---|---|
| 評価フェーズimport | `import { foo } from "./m.wasm"` — ホストが直接インスタンス化。importはJSモジュールグラフから解決 |
| Source Phase import | `import source m from "./m.wasm"` — `WebAssembly.Module` 相当を受け取り、**複数回・カスタムimportで**インスタンス化できる(`WebAssembly.Module` のprototypeに `AbstractModuleSource` が入る) |
| 動的import | `await import("./m.wasm")` / `await import.source("./m.wasm")` の両フェーズ対応 |
| importの解釈 | Wasmモジュールのimportモジュール名をJSのモジュール指定子(URL、import maps対応)として解釈 |
| snapshotting | importは前もって一括で渡される(後からの更新は反映されない)。**Wasm同士の循環importは非対応**(片方がReferenceError) |
| CSP統合 | ESM経由のWasmは `script-src` で検証される(JSと同等の扱い) |
| 段階的実装 | まずsource phaseのみ→評価フェーズも、の2段階実装をベンダに許容 |

## 例

```js
// 宣言的(評価フェーズ)
import { foo } from "./myModule.wasm";
foo();

// Source Phase: 同じモジュールを異なるimportで複数インスタンス化
import source myModule from "./myModule.wasm";
const { foo: a } = new WebAssembly.Instance(myModule, { ...imports1 });
const { foo: b } = new WebAssembly.Instance(myModule, { ...imports2 });
```

## フェーズ遷移

| 時期 | できごと | Phase |
|---|---|---|
| 2017頃 | 提案開始(最初期のproposalの一つ) | →1 |
| 2019-03-19 | Phase 2へ([コミット](https://github.com/WebAssembly/proposals/commits/main/README.md)) | 2 |
| 2022-03-14 | champion交代(現体制へ)([#136](https://github.com/WebAssembly/proposals/pull/136)) | - |
| (その後) | TC39のSource Phase Imports成立を受けて設計を再構成し、Phase 3へ | 2→3 |

## 経緯と現状

- 長年停滞していたが、TC39側のSource Phase Imports提案の登場で「カスタムインスタンス化をどう表現するか」問題が解け、活性化した
- サーバランタイムが先行: **Denoは実装済み**(v2.1でfirst-class Wasm support)、**Node.jsはフラグ付き**(`--experimental-wasm-modules`)。ブラウザ向けには [ES Module Shims](https://github.com/guybedford/es-module-shims) のpolyfillがある
- 実装状況: [features](https://webassembly.org/features/)

## 関連

- [[js-promise-integration]] — JS統合のもう一つの面(非同期)
- [[content-security-policy]] — ESM経由のWasmは `script-src` 管轄になる(本提案のCSP節と関係)

## 一次情報

- [README.md](https://github.com/WebAssembly/esm-integration/blob/798588074fc599ed05061e921aa64ce36d0495ac/proposals/esm-integration/README.md)(本ページの主な出典。EXAMPLES.mdもある)
- [リポジトリ](https://github.com/WebAssembly/esm-integration)
