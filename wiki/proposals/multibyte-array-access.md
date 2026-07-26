---
title: Multibyte Array Access
type: proposal
phase: 2
repo: https://github.com/WebAssembly/multibyte-array-access
families: [gc-lang-support]
updated: 2026-07-26
---

# Multibyte Array Access

**Phase 2(仕様文面あり)** / Champion: Brendan Dahl

## 一言でいうと

既存の線形メモリ用load/store命令を**Wasm GCの数値・ベクタ・パック配列型**にも使えるように再利用し、GC配列へのマルチバイトアクセスを1命令で行えるようにする提案。

## なぜ必要か(Motivation)

Dartのtyped array、JVMのbyte配列、独自struct表現など、多くの言語処理系は `(array i8)` のようなGC配列をバイトバッファやカスタムデータ型のバッキングストアとして使っている。しかし現状これらへの読み書きは要素単位の`array.get`/`array.set`の連続呼び出しに頼るしかなく、マルチバイト値1つを組み立てるだけでも複数命令が必要で性能上のボトルネックになっていた。線形メモリの`i32.load`等が持つ「オフセット+アラインメント+エンディアン変換」を1命令でこなす効率性を、GC配列にもそのまま持ち込む。

## 仕組み

出典: [Overview.md](https://github.com/WebAssembly/multibyte-array-access/blob/bdc1b8cfba59ed1705eafc619cae18146e20a39d/proposals/multibyte-array-access/Overview.md)

- **命令の再利用**: `i32.load`/`i64.store`等の通常の線形メモリ命令、および`v128.load8x8_s`等のSIMD load/store系命令をそのまま流用する。新しいニーモニックは追加しない
- **型付きimmediate**: `memarg`(flags/offset)に加え、対象のGC配列型を指す`typeidx`をimmediateとして追加する。配列要素型は`i8`/`i16`/`i32`/`i64`/`f32`/`f64`/`v128`のいずれかの数値・パック型で、store系は`mut`必須
- **エンコーディング**: `memarg`の`flags`のbit 5を立てることで「配列版」と判別する(bit 6=memidxの有無と共存不可)。既存の線形メモリ命令のオペコードをそのまま再利用するため命令セットは増えない

| 項目 | 内容 |
|---|---|
| 対象命令 | 通常のload/store(i32/i64/f32/f64、各拡張/切り詰め版)、SIMD load/store(splat/zero/lane系含む)、計40命令超 |
| スタック形状(load) | `[ref: (ref null $t), address: i32] -> [val]` |
| 境界チェック | `ea + S ≤ array.len × 要素サイズ`。範囲外・null参照はトラップ |
| バイト順 | リトルエンディアン固定(線形メモリ命令と同じ) |

## 例

```wat
;; (array (mut i32)) 型 $t への読み書き
(i32.load (type $t) offset=4 (local.get $array) (local.get $address))
(i32.store (type $t) (local.get $array) (local.get $address) (local.get $val))
```

## フェーズ遷移

| 時期 | できごと | Phase |
|---|---|---|
| 2025-11-03 | Phase 1でproposals一覧に追加([#223](https://github.com/WebAssembly/proposals/pull/223)) | →1 |
| 2026-07-14 | CG会合の議題としてPhase 2投票が行われる([議事録](https://github.com/WebAssembly/meetings/blob/main/main/2026/CG-2026-07-14.md)、投票の集計は議事録に未記載) | 1→2 |
| 2026-07-22 | proposals READMEに反映([#235](https://github.com/WebAssembly/proposals/pull/235)) | - |

## 経緯と現状

- 発端は[design issue #1569](https://github.com/WebAssembly/design/issues/1569)と[GC issue #395](https://github.com/WebAssembly/gc/issues/395)。「新しい配列専用命令を別途追加する」案も検討されたが、CGのstraw pollで既存命令の再利用が支持された
- 代替案(reinterpret cast、配列の一部をメモリにpinする、[slice proposal](https://github.com/WebAssembly/design/issues/1555)の利用)はいずれも本提案より複雑と判断され不採用
- 現在Phase 2。エンジン実装はこれから

## 関連

- [[gc-lang-support]] — GC言語を実用にする「GC第2章」proposal群。本提案はメモリ効率の壁を埋める
- 例外処理と同様、Garbage collection(Wasm 3.0、[[finished-proposals]])が導入した配列型の上に構築される

## 一次情報

- [Overview.md](https://github.com/WebAssembly/multibyte-array-access/blob/bdc1b8cfba59ed1705eafc619cae18146e20a39d/proposals/multibyte-array-access/Overview.md)(本ページの主な出典)
- [リポジトリ](https://github.com/WebAssembly/multibyte-array-access)
