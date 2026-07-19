---
title: Memory Control
type: proposal
phase: 1
repo: https://github.com/WebAssembly/memory-control
updated: 2026-07-19
---

# Memory Control

**Phase 1(提案段階)** / Champion: Deepti Gandluri & Ben Visness

## 一言でいうと

線形メモリの細かい制御 — **コピー削減・メモリフットプリント削減・メモリ保護** — を可能にするサブ提案群の「傘」proposal。

## なぜ必要か(Motivation)

現在の線形メモリは「成長するだけの、保護のない連続バッファ」で、次の3つの実務問題がある:

1. **コピーが多い**: WebCodecs/WebGPU/ML系のWebアプリでは、Web APIからWasmメモリへデータを入れるのに中間バッファ経由のコピーが避けられず、ネイティブ比で無視できないオーバーヘッド
2. **フットプリントを減らせない**: メモリは伸びるだけで縮められず、解放APIもない。モバイルではプロセスkillの原因になり、Windowsのcommit limitのようなシステム制限にも触れる(Unityの報告が有名)
3. **保護がない**: nullポインタでトラップしたい言語、定数データをread-onlyにしたいツールチェーン、デコード中のバッファを守りたいコーデックなどの要求に応えられない

## 仕組み

出典: [Overview.md](https://github.com/WebAssembly/memory-control/blob/62fac131de7e6406c9c05b493457025c2e42a15c/proposals/memory-control/Overview.md)

Phase 1らしく、複数のサブ提案に分割して検討中(Phase 2までに統廃合される想定と明記):

| サブ提案 | 対象 | 内容 |
|---|---|---|
| BYOB for WebAssembly.Memory | コピー | `ReadableStream` のBYOB APIでfetch/Blob/OPFSがWasmメモリへ**直接書き込む** |
| `memory.discard` | フットプリント | ページをゼロクリアして「解放」する命令。仮想メモリのあるホストでは物理メモリを実際に返せる |
| 静的メモリ保護 | 保護 | メモリ先頭にno-access/read-only領域をオプションで設ける(nullポインタ・定数データ用) |
| `mappable` | コピー/保護 | メモリ先頭に「マップ可能」特殊領域を設け、ファイルマップ等を許す |
| `virtual` モード | 全部 | ページ単位のmap/unmapができる新モード(主要OSの仮想メモリAPIの可搬サブセットを実質公開) |

複数メモリを使う設計(専用メモリをbind/unbind)は「移植容易性・ツールチェーン統合・polyfill可能性」の理由で退けられ、**単一線形メモリ前提**に舵を切った経緯がAlternativesに記録されている。

## フェーズ遷移

| 時期 | できごと | Phase |
|---|---|---|
| 2022-04-22 | proposals一覧に追加([#144](https://github.com/WebAssembly/proposals/pull/144)) | →1 |

## 経緯と現状

- JS API(ArrayBuffer)との相互作用が難所: read-onlyなArrayBufferの概念がJSにない(TC39側のlimited/readonly ArrayBuffer提案に依存)、複数ArrayBufferが同じバッキングストアを共有できない、など
- `memory.discard` はもっとも合意が取りやすいサブ提案として先行しやすい位置にある

## 関連

- [[custom-page-sizes]] — メモリ型拡張の隣接proposal(こちらはページサイズ)
- [[finished-proposals]] — Memory64 / Multiple memories(線形メモリ系譜)

## 一次情報

- [Overview.md](https://github.com/WebAssembly/memory-control/blob/62fac131de7e6406c9c05b493457025c2e42a15c/proposals/memory-control/Overview.md)(本ページの主な出典。各サブ提案は同ディレクトリの個別文書)
- [リポジトリ](https://github.com/WebAssembly/memory-control)
