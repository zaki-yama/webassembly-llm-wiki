---
title: WebAssembly仕様策定の全体像
type: concept
updated: 2026-08-09
---

# WebAssembly仕様策定の全体像

## 組織とプロセス

WebAssemblyの標準化は W3C の2つのグループで進む。

- **Community Group (CG)**: 誰でも参加できる場。proposalの議論・フェーズ投票はここで行われる。隔週火曜にビデオ会議があり、議事録は [WebAssembly/meetings](https://github.com/WebAssembly/meetings) の `main/YYYY/CG-MM-DD.md` に残る
- **Working Group (WG)**: 正式な勧告(Recommendation)を出すW3C標準のグループ。Phase 4以降を担当
- **Subgroup**: 特定領域のCG分科会。WASI, GC, threads, stack, debugging など。議事録は meetings リポジトリの各サブディレクトリ

## フェーズ制度

proposalは [phases.md](https://github.com/WebAssembly/meetings/blob/main/process/phases.md) に定められた6段階を進む。フェーズ移行はCGミーティングでの投票(poll)で決まる。

| Phase | 名称 | 意味 |
|---|---|---|
| 0 | Pre-Proposal | アイデア段階。[design リポジトリのissue](https://github.com/WebAssembly/design/issues)で議論 |
| 1 | Feature Proposal | CGが見込みありと判断。専用リポジトリが作られる |
| 2 | Proposed Spec Text Available | 正確・完全な仕様文面がある |
| 3 | Implementation Phase | テストスイート完備。エンジンでの実装が進む |
| 4 | Standardize the Feature | 2つ以上のWeb VMで実装済み。WGへ移管 |
| 5 | The Feature is Standardized | 標準化完了。本体仕様へのマージ待ち |

「FIXした」= Phase 4の完了を経て [finished-proposals.md](https://github.com/WebAssembly/proposals/blob/main/finished-proposals.md) に載ること。詳細は [[finished-proposals]] を参照。

## 仕様バージョン

- **Wasm 1.0** (MVP): 2017年
- **Wasm 2.0**: 2025-03-20 完了。SIMD、reference types、bulk memory など
- **Wasm 3.0**: 2025-09-17 完了。GC、tail call、exception handling、Memory64、multi-memory など([公式アナウンス](https://webassembly.org/news/2025-09-17-wasm-3.0/))

## 現在のproposalフェーズ一覧(2026-08-09時点のスナップショット)

出典: [WebAssembly/proposals README](https://github.com/WebAssembly/proposals)

### Phase 5(標準化完了・マージ待ち)
- [[js-promise-integration]] — Francis McCabe(2026-06-24 WG投票でPhase 5)
- [[content-security-policy]] — Francis McCabe(2026-06-24 WG投票でPhase 5)

### Phase 4(標準化中)
- [[threads]] — Conrad Watt

### Phase 3(実装中)
- [[esm-integration]] — Asumu Takikawa, Ms2ger & Guy Bedford
- [[wide-arithmetic]] — Alex Crichton and Jamey Sharp
- [[stack-switching]] — Francis McCabe & Sam Lindley
- [[compact-import-section]] — Ryan Hunt
- [[custom-page-sizes]] — Nick Fitzgerald
- [[custom-descriptors]] — Thomas Lively

### Phase 2(仕様文面あり)
- [[relaxed-dead-code-validation]] — Conrad Watt and Ross Tate
- [[wat-numeric-values]] — Ezzat Chamudi
- [[extended-name-section]] — Ben Visness
- [[rounding-variants]] — Kloud Koder
- [[compilation-hints]] — Emanuel Ziegler
- [[js-primitive-builtins]] — Sébastien Doeraene
- [[acquire-release-atomics]] — Conrad Watt & Rezvan Mahdavi Hezaveh(2026-08-06に"Relaxed Atomics"から改名)
- [[multibyte-array-access]] — Brendan Dahl(2026-07-14 CG投票でPhase 2)
- [[fp16]] — Brendan Dahl(2026-08-04〜05 CG対面会合で"Half Precision"から改名・championも交代の上Phase 1→2)

### Phase 1(提案段階)
個別ページあり: Component Model(→ [[component-model-overview]])、[[shared-everything-threads]]、[[stringref]]、[[type-imports]]、[[memory-control]]

その他のPhase 1: WebAssembly C and C++ API、Flexible Vectors、Profiles、Frozen Values、More Array Constructors、JIT Interface、Type Reflection for JS API、JS Text Encoding Builtins

## 関連領域

- **WASI**: WASI Subgroupで開発されるシステムインターフェース。→ [[wasi-roadmap]]
- **Component Model**: モジュール合成・言語間相互運用の枠組み。WASI 0.2以降の基盤。→ [[component-model-overview]]

## エンジン実装状況

[webassembly.org/features](https://webassembly.org/features/) が各ブラウザ・ランタイムの機能サポート表。
データソースは [features.json](https://github.com/WebAssembly/website/blob/main/features.json)。
