---
title: JS Promise Integration (JSPI)
type: proposal
phase: 4
repo: https://github.com/WebAssembly/js-promise-integration
families: [concurrency, js-interop]
updated: 2026-07-19
---

# JS Promise Integration (JSPI)

**Phase 4(標準化)** / Champion: Francis McCabe

## 一言でいうと

同期的に書かれたWasmコードが、JSの非同期API(Promise)を**あたかも同期呼び出しのように**待てるようにするJS API拡張。Wasm側の実行をsuspendし、Promiseの解決時にresumeする。

## なぜ必要か(Motivation)

C/C++などから来たWasmモジュールは同期的なAPI(ファイルI/O等)を前提に書かれているが、Webの外部APIはほぼすべて非同期(Promise)。従来はEmscriptenのAsyncify(コード全体を変換して中断可能にする。サイズ・速度のコスト大)でエミュレートするしかなかった。JSPIはこの「同期的な見た目 ⇔ 非同期な現実」のギャップを**エンジンネイティブのスタック切り替え**で埋める。アプリ全体を書き直さずに(リンク時の設定だけで)レガシーな同期型コードをWebの非同期環境で動かせる。

## 仕組み

出典: [Overview.md](https://github.com/WebAssembly/js-promise-integration/blob/5b247b1026d2f438eefe51914a79f4218cbda9f9/proposals/js-promise-integration/Overview.md)

APIは2つの要素の**ペア**で構成される:

| API | 役割 |
|---|---|
| `WebAssembly.Suspending(fn)` | **import側**に付ける印。呼び出し先がPromiseを返したら、Wasmの実行をsuspendし、解決値を「同期的な戻り値」としてresumeする。rejectされたら例外として伝播 |
| `WebAssembly.promising(fn)` | **export側**に付ける印。exportをPromiseを返す関数にラップする。最初のsuspend発生時点でこのPromiseが呼び出し元へ返り、ラップされたexportが完走したとき解決される |

- ペアが崩れた使い方(Suspendingなimportがsuspendしたのに、対応するexportがpromisingでない)は**トラップ**
- suspendできるのはWasmフレームだけ(promising呼び出しとSuspending呼び出しの間にJSフレームが挟まるとsuspend不可)— これが「JSPIはstack-switchingのJS API限定版」たる所以
- 2回目以降のsuspendはブラウザのイベントループにだけ見え、ホストアプリからは最初のPromiseしか見えない

## 例

Overviewの「レガシーC」パターン。同期的な `fetch` 相当を待つ:

```js
// import側: Promiseを返すJS関数をSuspendingでマーク
const suspending_fetch = new WebAssembly.Suspending(
  (url) => fetch(url).then(r => r.text()));

const { exports } = await WebAssembly.instantiate(module, {
  env: { fetch_data: suspending_fetch }
});

// export側: promisingでラップして呼ぶ
const main = WebAssembly.promising(exports.main);
await main();  // Wasm内のfetch_data呼び出しは"同期的"に見える
```

## フェーズ遷移

| 時期 | できごと | Phase |
|---|---|---|
| 2021-08-20 | Phase 1でproposals一覧に追加([#119](https://github.com/WebAssembly/proposals/pull/119)) | →1 |
| 2022-04-22 | Phase 2へ([#143](https://github.com/WebAssembly/proposals/pull/143)) | 1→2 |
| 2022-10-26 | Phase 3へ | 2→3 |
| 2025-04-08 | CG会合でPhase 4投票、SF24/F14/N3/A0/SA0で可決([議事録](https://github.com/WebAssembly/meetings/blob/main/main/2025/CG-04-08.md)、[#207](https://github.com/WebAssembly/proposals/pull/207)) | 3→4 |

Phase 4投票では、Stacks Subgroupでの事前poll(コアの [[stack-switching]] との関係整理)を経てブラウザベンダの合意が得られた経緯が議事録に残っている。

## 経緯と現状

- EmscriptenはJSPIバックエンド(`-sJSPI`)を提供済みで、Asyncifyの置き換えが進む。実装状況: [features](https://webassembly.org/features/)
- コア仕様の汎用スタック切り替え([[stack-switching]]、Phase 3)とは「JSPI=JS APIに閉じた先行サブセット、stack-switching=コア命令での汎用機構」という役割分担。JSPIが先にPhase 4へ進んだ

## 関連

- [[stack-switching]] — コア仕様側の汎用機構
- [[esm-integration]] — JSとの統合のもう一つの面(モジュールシステム)

## 一次情報

- [Overview.md](https://github.com/WebAssembly/js-promise-integration/blob/5b247b1026d2f438eefe51914a79f4218cbda9f9/proposals/js-promise-integration/Overview.md)(本ページの主な出典)
- [リポジトリ](https://github.com/WebAssembly/js-promise-integration)
