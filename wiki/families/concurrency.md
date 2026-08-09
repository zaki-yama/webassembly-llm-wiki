---
title: 並行性(Concurrency)
type: family
members: [threads, acquire-release-atomics, shared-everything-threads, stack-switching, js-promise-integration]
updated: 2026-07-19
---

# 並行性(Concurrency)

## 概要

Wasmの並行性は**2つの直交する軸**で発展している:

1. **共有メモリ並列**(マルチスレッド): 複数の実行主体が同じデータを触る。[[threads]] → [[acquire-release-atomics]] → [[shared-everything-threads]] という積み上げ
2. **制御フローの中断・再開**(単一スレッド内の並行性): コルーチン・async/await。[[js-promise-integration]](JS API限定の先行版)と [[stack-switching]](コア命令の汎用版)

さらにComponent Model側にも独自の非同期モデル(`async`/`stream`/`future`、WASI 0.3の基盤 → [[component-model-overview]])があり、コア仕様の2軸とどう整合させるかが今後の大きなテーマ。

## メンバー

| 提案 | Phase | 一言 |
|---|---|---|
| [[threads]] | 4 | 共有線形メモリ+seqcstアトミクス(基盤) |
| [[acquire-release-atomics]] | 2 | acquire-releaseオーダリングと`pause`(threadsの続編) |
| [[shared-everything-threads]] | 1 | GCオブジェクト・テーブル・関数まで共有(傘proposal) |
| [[stack-switching]] | 3 | 型付き継続による中断・再開(コルーチン等の基盤) |
| [[js-promise-integration]] | 4 | JSのPromiseを同期的に待つ(stack-switchingのJS API先行版) |

## 横断テーマ

- **段階的分割**: threadsは意図的に最小(メモリ共有のみ)で出荷し、弱いオーダリングをacquire-release-atomicsへ、全共有をshared-everything-threadsへ分離した。「大きな問題を出荷可能な単位に切る」CGの典型パターン
- **スレッド生成はホスト任せ**: コア仕様はスレッドを作らない(Web Worker / wasi / Component Model組み込みに委譲)という一貫方針
- **メモリモデルの形式化**が全軸のボトルネック: threadsのPhase 4が遅れた主因であり、acquire-release-atomics(weak ordering)・shared-everything-threads(GC共有)はさらに難しい
- **2軸の交差**: shared-everything-threadsのFAQはstack-switchingとの直交性を明示的に扱う(「sharedな継続」は将来課題)

## 関連family

- [[gc-lang-support]] — Java/Kotlin等の並列GC言語はconcurrencyとgc-lang-supportの両方に依存する
