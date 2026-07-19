---
title: Web Content Security Policy
type: proposal
phase: 4
repo: https://github.com/WebAssembly/content-security-policy
updated: 2026-07-19
---

# Web Content Security Policy

**Phase 4(標準化)** / Champion: Francis McCabe

## 一言でいうと

Content Security Policy (CSP) にWasm専用のソースディレクティブ **`wasm-unsafe-eval`** を定義し、サイト運営者が「JSの `eval` を許可せずに、Wasmのコンパイル・実行だけを許可する」ことをできるようにする提案。コア仕様ではなくWeb API/CSP仕様(WebAppSec WGへの勧告)の位置づけ。

## なぜ必要か(Motivation)

WasmはJSの `<script>` に相当する専用のHTML要素を持たず、`WebAssembly.compile` / `instantiate` などの**JS APIを通じてのみ**ロードされる。歴史的にCSPはこれらのAPIをJSの `unsafe-eval`(テキストからコードを作る危険な操作の総称)で束ねてきたため、「Wasmは使いたいがJSの `eval` は開けたくない」サイトが、CSPを緩めすぎるか諦めるかの二択になっていた。信頼モデルの観点では、CSPは「発行者がブラウザに『どのコードを実行してよいか』を宣言する」契約であり、Wasm用に粒度の細かい鍵が必要だった。

## 仕組み

出典: [CSP.md](https://github.com/WebAssembly/content-security-policy/blob/284adaf2fecaf76ac05d35132c09e60bb4145041/proposals/CSP.md)

| 要素 | 説明 |
|---|---|
| `HostEnsureCanCompileWasmBytes` | Wasmコンパイル系APIをゲートする**ポリシーポイント**(抽象操作)。無効だと `WebAssembly.compile` 等が `CompileError` で失敗する |
| `wasm-unsafe-eval` | 新しいCSPソースディレクティブ。設定すると上記ポリシーポイントが有効になり、Wasmのロード・コンパイル・インスタンス化が許可される。**JSの `eval` には一切影響しない** |
| `unsafe-eval` との関係 | 従来どおり `unsafe-eval` はWasmも許可する(後方互換)。`unsafe-eval` があれば `wasm-unsafe-eval` の有無に関わらずそちらが優先 |

対象APIのリスク分析もExplainerに含まれる: `validate`(DoS程度)/ `compile` 系(多くの実装がここで機械語生成)/ `instantiate` 系(実行可能コードのロード+start関数の実行)。

`script-src` にWasmを含める案は「既存サイトのCSPを壊しうる」「ドメイン許可リスト方式はCDN時代に管理不能」等の理由で採らなかった(2025-08の会合でも「WebAppSec側に熱意がなかった」と経緯が説明されている)。

## 例

```
Content-Security-Policy: script-src 'self'; wasm-unsafe-eval
```

このヘッダを返すページは、自ドメインのJSと、Wasmモジュールのコンパイル・実行を許可するが、JSの `eval` / `new Function` は引き続き禁止される。

## フェーズ遷移

| 時期 | できごと | Phase |
|---|---|---|
| 2018-10頃 | proposals一覧に追加(初期championはBen Titzer) | →1 |
| 2021-02 | Francis McCabeがchampionに([#94](https://github.com/WebAssembly/proposals/pull/94)) | - |
| (長期間) | `wasm-unsafe-eval` 自体は主要ブラウザに実装・出荷され広く利用可能に | - |
| 2025-08-12 | CG会合でPhase 4投票、SF2/F24/N3/A0/SA0で可決([議事録](https://github.com/WebAssembly/meetings/blob/main/main/2025/CG-08-12.md)、[#216](https://github.com/WebAssembly/proposals/pull/216)) | 3→4 |

## 経緯と現状

- `wasm-unsafe-eval` は仕様化に先行して各ブラウザ・CSP仕様側(W3C WebAppSec)で実装が進み、実務ではすでに標準的に使われている。proposalとしての残作業はweb-api仕様文面の整備が中心
- 将来の拡張として「`script-src` のホワイトリストにWasmモジュールを含める」方向は、2025-08時点で「起こりそうにない」とchampionが明言している

## 関連

- [[esm-integration]] — Wasmに`<script>`相当の要素/モジュール統合を与える提案(実現するとCSPとの関係が再び論点になりうる)

## 一次情報

- [CSP.md](https://github.com/WebAssembly/content-security-policy/blob/284adaf2fecaf76ac05d35132c09e60bb4145041/proposals/CSP.md)(本ページの主な出典)
- [リポジトリ](https://github.com/WebAssembly/content-security-policy)
