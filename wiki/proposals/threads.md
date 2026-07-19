---
title: Threads
type: proposal
phase: 4
repo: https://github.com/WebAssembly/threads
families: [concurrency]
updated: 2026-07-19
---

# Threads

**Phase 4(標準化)** / Champion: Conrad Watt

## 一言でいうと

**共有線形メモリ**と**アトミック命令**を導入し、複数の実行主体(Web Workerなど)が同じメモリを安全に読み書きできるようにする提案。スレッドの生成・joinはWasm自身ではなく**embedder(ホスト)の責務**とする設計。

## なぜ必要か(Motivation)

C/C++/Rustなどのマルチスレッドプログラム(pthreads等)をWasmに移植するには、(1) スレッド間で共有できるメモリ、(2) データ競合を避けるアトミック操作、(3) スレッド間の待ち合わせ、が最低限必要になる。この提案はその3点だけをコア仕様に追加し、「スレッドをどう作るか」はホスト(WebならWeb Worker)に委ねることで、Wasm本体を小さく保つ。

## 仕組み

出典: [Overview.md](https://github.com/WebAssembly/threads/blob/979d0fcb994439423d63b2f0a8a7332d6285dd84/proposals/threads/Overview.md)

| 要素 | 説明 |
|---|---|
| `(memory 1 1 shared)` | **共有線形メモリ**。agent cluster(Workerたち)の間で共有できる。sharedなら最大サイズ必須 |
| agent / agent cluster | 実行主体とその集まり(Web埋め込みではECMAScriptのagent概念に対応)。「スレッド」に相当 |
| `i32.atomic.load` 等 | アトミックload/store(8/16/32/64bit幅)。現在は**すべて逐次一貫(seqcst)** |
| `i32.atomic.rmw.add` 等 | read-modify-write(add/sub/and/or/xor/xchg)。変更前の値を返す |
| `i32.atomic.rmw.cmpxchg` | compare-exchange。ロックの実装に使う |
| `memory.atomic.wait32/64` | 指定アドレスの値が期待値なら**ブロックして待つ**(タイムアウト可)。futex相当 |
| `memory.atomic.notify` | 同じアドレスで待っているagentを起こす |
| `atomic.fence` | メモリオーダリングのフェンス |
| JS API拡張 | `WebAssembly.Memory({shared: true})`。bufferは `SharedArrayBuffer` になる |

アトミックアクセスは**アラインメント必須**(非アラインはトラップ)。非共有メモリに対してもアトミック命令は使える。

## 例

Overviewのミューテックス実装(抜粋)。`cmpxchg` でロック取得を試み、失敗したら `wait` で眠る:

```wat
;; ロック取得を試みる: 0(未ロック)なら1(ロック)に置き換える
(func $tryLockMutex (param $mutexAddr i32) (result i32)
  (i32.atomic.rmw.cmpxchg
    (local.get $mutexAddr)
    (i32.const 0)   ;; 期待値: unlocked
    (i32.const 1))  ;; 置換値: locked
  (i32.eqz))

;; 取れるまで待つ
(func (export "lockMutex") (param $mutexAddr i32)
  (block $done
    (loop $retry
      (call $tryLockMutex (local.get $mutexAddr))
      (br_if $done)
      (memory.atomic.wait32
        (local.get $mutexAddr) (i32.const 1) (i64.const -1))
      (drop)
      (br $retry))))
```

ホスト側はメインスレッドで `WebAssembly.Memory` を作り、`postMessage` でWorkerに共有する(メインスレッドではブロッキング`wait`不可、Workerでは可)。

## フェーズ遷移

| 時期 | できごと | Phase |
|---|---|---|
| 2017頃 | 提案開始(MVP直後の最初期proposalの一つ)。ブラウザでは2019年前後から出荷 | 0→2 |
| 2021-03 | Conrad Wattがchampionに([コミット](https://github.com/WebAssembly/proposals/commits/main/README.md)) | - |
| 2022-10-26 | Phase 3へ([#152](https://github.com/WebAssembly/proposals/pull/152))。形式化(メモリモデル)が長年の課題だった | 2→3 |
| 2023-10-11 | ハイブリッドCG会合でPhase 4投票、SF37/F7/N2/A0/SA0で可決("wild applause")([議事録](https://github.com/WebAssembly/meetings/blob/main/main/2023/CG-10.md)) | 3→4 |

## 経緯と現状

- 各ブラウザでは仕様に先行して長年出荷済み(Spectre対応でSharedArrayBufferが一時無効化された経緯もあり、仕様化が実装に大きく遅れた珍しいproposal)。実装状況: [features](https://webassembly.org/features/)
- メモリモデル(弱いオーダリングの形式定義)の難しさがPhase 4までの長い道のりの主因。現在のアトミクスはすべてseqcstで、より弱いオーダリングは [[relaxed-atomics]](Phase 2)に分離された
- 共有できるのは線形メモリのみ。GCオブジェクトや関数まで共有する後継が [[shared-everything-threads]](Phase 1)

## 関連

- [[relaxed-atomics]] — acquire/release等の弱いオーダリング(分離された続編)
- [[shared-everything-threads]] — 「すべてを共有する」後継提案
- [[stack-switching]] — 並行性のもう一つの軸(単一スレッド内の制御フロー)

## 一次情報

- [Overview.md](https://github.com/WebAssembly/threads/blob/979d0fcb994439423d63b2f0a8a7332d6285dd84/proposals/threads/Overview.md)(本ページの主な出典)
- [リポジトリ](https://github.com/WebAssembly/threads)
