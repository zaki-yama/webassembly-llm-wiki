---
title: Shared-Everything Threads
type: proposal
phase: 1
repo: https://github.com/WebAssembly/shared-everything-threads
families: [concurrency, gc-lang-support]
updated: 2026-07-19
---

# Shared-Everything Threads

**Phase 1(提案段階)** / Champion: Andrew Brown, Conrad Watt, and Thomas Lively

## 一言でいうと

[[threads]] では線形メモリしか共有できないのに対し、**テーブル・関数・グローバル・GCオブジェクトまで「すべて」をスレッド間で共有**できるようにする包括的proposal。TLS(thread-local storage)やスレッド生成の組み込みも含む。

## なぜ必要か(Motivation)

threads提案(Phase 4)は線形メモリ言語(C/C++/Rust)のWebスレッドには十分だったが、次の穴が残った:

- **共有テーブルがない** → 動的リンクがスレッド環境で極端に複雑・低速
- **参照値を共有できない** → **Wasm GCプログラムはスレッドを一切使えない**(Java/Kotlin等の本物のマルチスレッド言語がGCバックエンドで並列化できない)
- **非JS環境にスレッド生成の標準がない** → wasi-threadsの経験から、エコシステム共通の仕組みが必要と判明

出典は2019年の論文 "Weakening WebAssembly" まで遡り、threads提案が意図的に落とした部分を回収する位置づけ。

## 仕組み

出典: [Overview.md](https://github.com/WebAssembly/shared-everything-threads/blob/065aa53822e17eea69bfc049df67a16cbd03d9ce/proposals/shared-everything-threads/Overview.md)(冒頭に「活発に改稿中、大きな変更を予期せよ」と明記)

| 要素 | 説明 |
|---|---|
| `shared` アノテーション | テーブル・関数・グローバル・GCヒープ型に付ける静的注釈。**shared なものはsharedなものしか参照できない**ことを型システムで保証(shared-unshared境界の健全性) |
| thread-local globals | 言語ランタイムがTLSを構築するための、スレッドごとに値を持つglobal |
| 共有GCデータへのアトミックアクセス | seqcstおよびacqrel([[acquire-release-atomics]] のオーダリングをGCに適用)のstruct/arrayアクセス命令 |
| managed waiter queues | GCオブジェクトで使えるfutex的なwait/notify機構(線形メモリのwait/notifyのGC版) |
| スレッド管理組み込み | スレッド生成等のライフサイクル管理をComponent Model組み込みとして提供(コア命令にしない) |

FAQでは「thread ID」「join」「exit」等の意図的な非対応(ホスト任せ)や、[[stack-switching]] との直交性も整理されている。

## 例

```wat
;; 共有可能なGC構造体型(shared同士しか参照できない)
(type $point (shared (struct (field (mut f64)) (field (mut f64)))))
;; スレッドローカルなglobal
(global $tls (shared thread_local) (mut i32) (i32.const 0))
```

## フェーズ遷移

| 時期 | できごと | Phase |
|---|---|---|
| 2023-10-11 | 対面CG会合の「Post-MVP threads discussion」でPhase 1投票([議事録](https://github.com/WebAssembly/meetings/blob/main/main/2023/CG-10.md)、[スライド](https://github.com/WebAssembly/meetings/blob/main/main/2023/presentations/2023-10-11-thread-spawn-proposal.pdf)) | →1 |
| 2023-11-21 | proposals一覧に追加([#178](https://github.com/WebAssembly/proposals/pull/178)) | 1 |

## 経緯と現状

- Wasm GC言語(Java/Kotlin/Dart)の並列化ニーズと、WASI側のスレッド標準化ニーズ(wasi-threadsの後継)が合流した「傘」proposal
- エンジンへの影響が非常に大きい(GCヒープの並行化、shape/hidden classの共有など)ため、議論は活発だが進行は慎重。Threads Subgroupの議事録([meetings/threads](https://github.com/WebAssembly/meetings/tree/main/threads))が一次情報
- オーダリング面は [[acquire-release-atomics]](Phase 2)に依存する形で分業

## 関連

- [[threads]] — 前提(線形メモリの共有)
- [[acquire-release-atomics]] — 本提案が使うメモリオーダリングの供給元
- [[custom-descriptors]] — exact types等、GC型システムの拡張で交差する
- [[stack-switching]] — 直交する並行性(FAQで関係を整理)

## 一次情報

- [Overview.md](https://github.com/WebAssembly/shared-everything-threads/blob/065aa53822e17eea69bfc049df67a16cbd03d9ce/proposals/shared-everything-threads/Overview.md)(本ページの主な出典)
- [リポジトリ](https://github.com/WebAssembly/shared-everything-threads)
