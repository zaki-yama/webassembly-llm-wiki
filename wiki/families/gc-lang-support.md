---
title: GC言語サポート(GC Language Support)
type: family
members: [custom-descriptors, js-primitive-builtins, stringref, shared-everything-threads]
updated: 2026-07-19
---

# GC言語サポート(GC Language Support)

## 概要

Wasm GC(Wasm 3.0でFIX)の上でJava・Kotlin・Dart・Scala等のマネージド言語を**実用性能で**動かすための「GC第2章」proposal群。GC本体は型と割り当てを提供したが、実運用で(1) オブジェクトのメモリ効率、(2) JSとの相互運用、(3) マルチスレッド、の3つの壁が見つかり、それぞれをproposalが埋めている。

## メンバー

| 提案 | Phase | 埋める壁 |
|---|---|---|
| [[custom-descriptors]] | 3 | vtable分のメモリ+JSからのメソッド呼び出し |
| [[js-primitive-builtins]] | 2 | JSプリミティブ変換のグルーコード除去 |
| [[stringref]] | 1 | 文字列のゼロコピー(JS String Builtinsに先行された) |
| [[shared-everything-threads]] | 1 | GCオブジェクトのスレッド間共有 |

FIX済みの基盤: Garbage collection、Typed Function References、JS String Builtins(→ [[finished-proposals]])

## 横断テーマ

- **実測駆動**: このfamilyの提案はJ2CL(Google)、Kotlin/Wasm(JetBrains)、Dart(Google)、Scala.js各チームのプロファイル実測から生まれており、explainerにベンチマーク由来の動機が明記される傾向がある
- **exact types**: custom-descriptorsが導入する `(ref (exact $t))` は、shared-everything-threads等の他提案からも参照される型システム基盤になりつつある
- **文字列戦争の決着**: 第一級型(stringref)vs 組み込みimport(JS String Builtins)の設計対立はbuiltins側が先にFIXし、以後のプリミティブ系はbuiltinsパターンで進んでいる

## 関連family

- [[js-interop]] — 大きく重なる(JS連携の摩擦はGC言語で顕在化した)
- [[concurrency]] — shared-everything-threadsが両方に属する
