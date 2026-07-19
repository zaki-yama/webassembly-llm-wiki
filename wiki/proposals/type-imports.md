---
title: Type Imports
type: proposal
phase: 1
repo: https://github.com/WebAssembly/proposal-type-imports
updated: 2026-07-19
---

# Type Imports

**Phase 1(提案段階)** / Champion: Andreas Rossberg

## 一言でいうと

**型そのものをimport/export**できるようにする提案。ホストや他モジュールが定義する抽象型への**型付き参照** `(ref $t)` を作れるようになり、`externref`/`anyref` への「型消し」とその復元の実行時チェックが不要になる。

## なぜ必要か(Motivation)

現状、ホストのオブジェクト(ファイルハンドル等)や他モジュールの型をWasmで受け渡すには `externref` / `anyref` というトップ型を使うしかなく、実質**untyped**になる。APIは受け取るたびに実行時型チェックが必要で、型健全性の恩恵が境界で失われる。型をimportできれば、API関数は `(ref $file)` のような正確な型を要求でき、Wasmの型システムがホスト側のチェックを不要にする。

## 仕組み

出典: [Overview.md](https://github.com/WebAssembly/proposal-type-imports/blob/13d907c9134c2549d99c8e0025832d577a5b275a/proposals/type-imports/Overview.md)

MVPとして意図的に最小限:

| 要素 | 説明 |
|---|---|
| 型import | `(import "m" "t" (type $t (sub <absheaptype>)))` — 抽象heap type(`any`/`extern`/`func` 等)を上限(bound)とする抽象型として取り込む |
| 型export | `(export "t" (type $t))` — デフォルトは**透明**(定義が見える)。インスタンス化時にimport制約の検証に使われる |
| 表現の静的既知性 | boundが表現(uniform representation)を静的に決めるため、コンパイル時に型の実体が未知でもコードが出せる |
| validation限定 | 実行時セマンティクスへの影響なし(トップ型を使った場合との差はvalidationのみ) |
| private型(post-MVP) | exportを**不透明**にして抽象データ型として封じ込める機構。キャストで突き破れないことを要求。MVPからは外されている |

## 例

```wat
;; ホストの抽象型をimportし、型付き参照でAPIを宣言
(import "host" "file" (type $file (sub extern)))
(import "host" "read" (func $read (param (ref $file)) (result i32)))
```

`$read` に渡せるのは `$file` 型の参照だけであることをWasmの型システムが保証し、ホスト側の実行時チェックが不要になる。

## フェーズ遷移

| 時期 | できごと | Phase |
|---|---|---|
| 2019-06-26 | proposals一覧に追加([コミット](https://github.com/WebAssembly/proposals/commits/main/README.md)) | →1 |
| (以後) | Phase 1に留まる。GC/typed function referencesの完成(Wasm 3.0)を待って再設計された経緯がある | 1 |

## 経緯と現状

- 2019年からある最古参級のPhase 1 proposal。前提技術(reference types → typed function references → GC)が順に標準化されるのを待つ形で長期熟成されてきた
- Component Modelのresource型([[component-model-overview]])は、モジュール境界での抽象型・ハンドルという同じ問題意識をコンポーネント層で解いており、役割分担(コア型システム vs コンポーネントABI)が議論の背景にある

## 関連

- [[finished-proposals]] — Typed Function References / GC(前提となった基盤)
- [[component-model-overview]] — resource型(コンポーネント層での類似解)

## 一次情報

- [Overview.md](https://github.com/WebAssembly/proposal-type-imports/blob/13d907c9134c2549d99c8e0025832d577a5b275a/proposals/type-imports/Overview.md)(本ページの主な出典)
- [リポジトリ](https://github.com/WebAssembly/proposal-type-imports)
