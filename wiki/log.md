# Log

## [2026-07-19] deepen | Phase 2 + 注目Phase 1 proposals

- Phase 2の7ページをdeepen: [[relaxed-dead-code-validation]]、[[wat-numeric-values]]、[[extended-name-section]]、[[rounding-variants]]、[[compilation-hints]]、[[js-primitive-builtins]]、[[relaxed-atomics]]
- 注目Phase 1の4ページをdeepen: [[shared-everything-threads]]、[[stringref]]、[[type-imports]]、[[memory-control]]
- これで個別ページを持つ全21 proposalが深掘り済み

## [2026-07-19] deepen | Phase 3 proposals

- Phase 3の5ページを一次情報からdeepen: [[esm-integration]](README)、[[wide-arithmetic]]、[[compact-import-section]]、[[custom-page-sizes]]、[[custom-descriptors]](いずれもOverview.md)
- これでPhase 3以上の全9ページが深掘り済み

## [2026-07-19] deepen | stack-switching + Phase 4 proposals

- 「情報が薄くリポジトリを見ないとわからない」というユーザーレビューを受け、深掘り(deepen)作業を開始(計画: plans/deepen-proposals-plan.md)
- [[stack-switching]] をExplainerから書き直し(テンプレートの見本ページ)
- Phase 4の3ページを一次情報からdeepen: [[threads]](Overview.md)、[[js-promise-integration]](Overview.md)、[[content-security-policy]](CSP.md)
- 各ページにフェーズ遷移テーブル(proposals READMEのgit履歴+CG議事録の投票記録から再構成)を追加

## [2026-07-18] weekly | 2026-W29(再チェック)

- CI経由で週次更新を再実行。`state/watch-state.json` の各 `last_sha` を起点に proposals / meetings / WASI / component-model / website(features.json)を再度diff確認したが、直近の実行(同日07-18)からの新規コミット・議事録・リリースはなし(全リポジトリ `ahead_by: 0`)
- [webassembly.org/news](https://webassembly.org/news/) も新着なし(最新は2026-01-21 "The States of WebAssembly")
- 差分がないため [[2026-W29]]・各wikiページ・`watch-state.json` の内容は変更なし(既存の記述を保持)
- 手順5(Artifact公開)はCI環境のためスキップ

## [2026-07-18] weekly | 2026-W29

- 初回の週次更新(対象: 2026-07-11〜07-18)。[[2026-W29]] を生成、Artifact公開
- WASI Subgroup 06-25議事録から [[2026-06-25-wasi]] を作成、[[wasi-roadmap]] に0.3.xスケジュールを反映
- proposalsリポジトリ・features.jsonは変更なし

## [2026-07-18] ingest | 初期ベースライン構築

- WebAssembly/proposals の README.md / finished-proposals.md、phases.md、WASI README、component-model README を取り込み
- [[overview]]、[[finished-proposals]]、Phase 2以上の全proposal個別ページ(16ページ)、注目Phase 1(4ページ)、[[wasi-roadmap]]、[[component-model-overview]] を作成
- `state/watch-state.json` のベースラインは 2026-07-11 時点の各リポジトリSHA(初回週次実行で直近1週間分の差分を拾うため)
