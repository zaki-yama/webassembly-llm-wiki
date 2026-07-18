---
title: FIX済みproposal(Finished Proposals)
type: concept
updated: 2026-07-18
---

# FIX済みproposal(Finished Proposals)

Phase 4を完了し本体仕様にマージされたproposalの一覧。
出典: [finished-proposals.md](https://github.com/WebAssembly/proposals/blob/main/finished-proposals.md)

## Wasm 3.0 で入ったもの(2025-09-17 完了)

| Proposal | 概要 |
|---|---|
| Garbage collection | struct/array型とGCヒープ。言語処理系の新バックエンド基盤 |
| Typed Function References | 型付き関数参照と `call_ref` |
| Tail call | 末尾呼び出し `return_call` |
| Exception handling | 例外の throw/catch(2025-07-23 WG投票) |
| Memory64 | 64bitアドレスの線形メモリ |
| Multiple memories | 1モジュール複数メモリ |
| Relaxed SIMD | プラットフォーム依存を許容する高速SIMD |
| JS String Builtins | JS文字列操作をimport組み込み関数として提供 |
| Extended Constant Expressions | 定数式の拡張 |
| Branch Hinting | 分岐確率のヒント |
| Custom Annotation Syntax | テキスト形式のアノテーション構文 |

## Wasm 2.0 で入ったもの(2025-03-20 完了)

Reference Types、Bulk memory operations、Fixed-width SIMD、Multi-value、Sign-extension operators、Non-trapping float-to-int conversions、JS BigInt to i64 integration

## Wasm 1.0 (MVP)

MVP、Import/Export of Mutable Globals

## 関連

- 現在進行中のproposal一覧: [[overview]]
