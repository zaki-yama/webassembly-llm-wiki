---
title: Stack Switching
type: proposal
phase: 3
repo: https://github.com/WebAssembly/stack-switching
updated: 2026-07-19
---

# Stack Switching

**Phase 3(実装フェーズ)** / Champion: Francis McCabe & Sam Lindley

## 一言でいうと

1つのWasmインスタンスが**複数の実行スタックを切り替えながら動ける**ようにする提案。型付き継続(typed continuation)という単一の低レベル機構を導入し、コルーチン・async/await・ジェネレータ・軽量スレッド・エフェクトハンドラといった「非局所制御フロー」を言語処理系が自前で構築できるようにする。

## なぜ必要か(Motivation)

多くの言語(Go, Kotlin, Python, OCaml, Haskell…)は async/await・ジェネレータ・軽量スレッドなどの非局所制御フローを言語の中核機能として持つ。現在のWasmにはスタックを中断・再開する手段がないため、これらの言語をWasmにコンパイルするには、CPS変換やAsyncifyのようなプログラム全体の変換(コスト大・モジュール合成を壊す)に頼るしかない。

この提案の戦略は「個別の制御フロー機能(コルーチン命令、ジェネレータ命令…)を足していく」のではなく、**それらすべての基盤になる単一の機構=継続**を提供すること([Explainer / Motivation](https://github.com/WebAssembly/stack-switching/blob/c7be390539e5fc10669c88cadc4fa4b32fba1d47/proposals/stack-switching/Explainer.md#motivation))。

## 仕組み

**継続(continuation)= あるスタック上の実行のスナップショット**を第一級の参照値として扱う。

- **非対称切り替え(asymmetric)**: `suspend` でタグと値を投げて中断し、`resume` 時に設置したハンドラが「中断された継続+値」を受け取る。例外処理のtag機構を再利用しており、親子(caller-callee)関係を作るため、トラップ・例外・embedder統合と自然に合成できる
- **対称切り替え(symmetric)**: `switch` で現在の継続の中断と別の継続の再開を一度に行う(ピア関係)。スケジューラを介さない直接切り替えができる
- 継続は**one-shot**(一度resumeしたら使えない)。resumeされた継続は現在の継続に「接ぎ木」される

主要な新要素([Explainer / Specification changes](https://github.com/WebAssembly/stack-switching/blob/c7be390539e5fc10669c88cadc4fa4b32fba1d47/proposals/stack-switching/Explainer.md#specification-changes)):

| 要素 | 説明 |
|---|---|
| `(cont $ft)` | 関数型から作る**継続型**(新しい複合型)。`cont`/`nocont` がheap typeの上限/下限 |
| `cont.new` | typed funcrefから継続を生成(実行はresumeまで始まらない) |
| `cont.bind` | 継続への部分適用(引数の一部を先に束縛) |
| `suspend $tag` | 現在の継続を中断し、対応するハンドラへ制御と値を渡す |
| `resume $ct (on $tag ...)` | 継続を実行。tagごとのハンドラ(`on`節)を設置する |
| `resume_throw` | 継続に例外を投げ込んで実行(タスクのキャンセルに使う) |
| `switch` | 対称切り替え: 現在の継続を中断し、指定した継続へ直接切り替え |

タグは例外処理(Wasm 3.0でFIX済み)の `tag` を拡張したもので、**戻り値型を持てる**ようになる(resume側から中断地点へ渡す値の型)。

## 例: ジェネレータ

Explainerの最初の例。ジェネレータが `suspend` で値を1つずつ消費者に渡す:

```wat
(tag $gen (param i32))            ;; ジェネレータ→消費者に渡す値

(func $generator
  (local $i i32)
  (local.set $i (i32.const 100))
  (loop $loop
    (suspend $gen (local.get $i)) ;; 中断して $i を消費者へ
    (local.tee $i (i32.sub (local.get $i) (i32.const 1)))
    (br_if $loop)))

(func $consumer
  (local $c (ref $ct))
  (local.set $c (cont.new $ct (ref.func $generator)))
  (loop $loop
    (block $on_gen (result i32 (ref $ct))
      (resume $ct (on $gen $on_gen) (local.get $c)) ;; 継続を実行
      (return))                   ;; ジェネレータが完走したら終了
    (local.set $c)                ;; 中断された継続を保存
    (call $print)                 ;; 生成された値を処理
    (br $loop)))
```

タスクスケジューラの例(非対称版・対称版)やキャンセルの例もExplainerにある。

## フェーズ遷移

| 時期 | できごと | Phase |
|---|---|---|
| 2020頃〜 | Stack Subgroupで複数の設計案(fibers、typed continuations等)を比較検討 | 0〜1 |
| 2024-08-28 | Phase 2へ([#196](https://github.com/WebAssembly/proposals/pull/196)) | 1→2 |
| 2025-10 | 対面CG会合でPhase 3投票、SF22/F20/N1/A2/SA0で可決([議事録](https://github.com/WebAssembly/meetings/blob/main/main/2025/CG-10.md))。V8(KM)が「Phase 3は『技術的に解決済み』のシグナルになるが、我々はまだそう感じていない」と反対を登録した上でのconsensus | 2→3 |
| 2026-01-12 | proposals READMEに反映([#227](https://github.com/WebAssembly/proposals/pull/227)、"Leftover from October hybrid meeting") | - |

## 経緯と現状

- Stack Subgroup(CG分科会)で複数の設計案(fibers案、typed continuations案など)が長く比較検討され、現在のExplainerは**typed continuationsベース+対称切り替えの統合**に収斂した。議事録: [meetings/stack](https://github.com/WebAssembly/meetings/tree/main/stack)
- 現在 **Phase 3**。エンジン実装状況は [webassembly.org/features](https://webassembly.org/features/) を参照
- JS APIに閉じた限定版である [[js-promise-integration]](JSPI)が先行してPhase 4にあり、「JSのPromiseを待つ」ユースケースはJSPI、それ以外の汎用的なスタック操作は本提案、という役割分担

## 関連

- [[js-promise-integration]] — JS API側の先行サブセット
- [[shared-everything-threads]] — 並行性のもう一つの軸(こちらは共有メモリ並列)
- 例外処理(Wasm 3.0、[[finished-proposals]])— tag機構を共有する

## 一次情報

- [Explainer](https://github.com/WebAssembly/stack-switching/blob/c7be390539e5fc10669c88cadc4fa4b32fba1d47/proposals/stack-switching/Explainer.md)(本ページの主な出典)
- [リポジトリ](https://github.com/WebAssembly/stack-switching)(design-notes/, examples/ あり)
