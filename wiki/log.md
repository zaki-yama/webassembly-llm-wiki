# Log

## [2026-08-16] weekly | 2026-W33

- **[[compact-import-section]]**: 2026-08-04、CG対面会合でPhase 3→4投票が可決([commit](https://github.com/WebAssembly/proposals/commit/f0db14a5555abf7b931667fd289755124a3bf37e))。ページのfrontmatter `phase`・フェーズ遷移表・「経緯と現状」を更新
- **[[wide-arithmetic]]**: 2026-08-05、CG対面会合でPhase 3→4投票が可決([commit](https://github.com/WebAssembly/proposals/commit/bdd089a6c2e3188d6e053a90d9b15a65e1226e3c))。ページを同様に更新。リポジトリはWebAssembly/specのforkで、`proposal_repos`のSHA差分329件はほぼ全て上流spec同期のノイズ(wide-arithmetic固有ファイルの変更なし)と確認した上でSHAのみ更新
- 先週「結果未確認」としていたこの2件を [[2026-08-04-cg]] の「確認できたフェーズ変化」に移動。Acquire-Release AtomicsのPhase 3投票は今週も進展なし(READMEはPhase 2のまま)
- **WASI**: 2026-08-06のWASI Subgroup会議でComponent Model map型・`implements`アノテーション/`external-id`の採否投票がいずれもfull consensusで可決。新規に [[2026-08-06-wasi]] を要約ページとして作成。これを取り込んだ**WASI v0.3.1**が2026-08-11にリリース([commit](https://github.com/WebAssembly/WASI/commit/691de6f0f2e5924e187499e2f7826125976c1f1c))。[[wasi-roadmap]]に反映
- **Component Model**: README/ExplainerがWASI 0.3.1リリースを踏まえて更新、asyncテストの非決定性を減らす調整。[[component-model-overview]]に反映
- エンジン実装状況: Wide ArithmeticのPhase 4移行に伴い、Chrome/Firefox/Safari/Node.js/Denoの実装フラグ定義がfeatures.jsonに追加([commit](https://github.com/WebAssembly/website/commit/23b7b90af087b3e081b0c433d70d29f6dbbf0984))。[[wide-arithmetic]]に反映
- webassembly.org/news、bytecodealliance.org/articlesとも今週の新着なし
- [[overview]]・[[index]] のフェーズ一覧スナップショットを更新
- [[2026-W33]] を生成。手順5(Artifact公開)はCI環境のためスキップ

## [2026-08-09] weekly | 2026-W32

- **[[fp16]]**(旧Half Precision): 2026-08-04〜05のCG対面会合を経て2026-08-06、Phase 1→2に昇格・champion交代(Ilya Rezvov→Brendan Dahl)。新規deepenしてテンプレート水準のページを作成([WebAssembly/half-precision](https://github.com/WebAssembly/half-precision) Overview.mdより)。`state/watch-state.json` の `proposal_repos` に追加
- **[[acquire-release-atomics]]**(旧relaxed-atomics): 2026-08-06に改名。リポジトリも `relaxed-atomics` → `acquire-release-atomics` に改称(GitHub上でリネーム済み、旧URLは404)。フェーズはPhase 2のまま。旧ページ `relaxed-atomics.md` を `acquire-release-atomics.md` にリネームし、`overview.md`/`families/concurrency.md`/`threads.md`/`shared-everything-threads.md`/`index.md` の内部リンクを一括更新。`watch-state.json` の `proposal_repos` キーも更新
- Compact Import Section・Wide ArithmeticのPhase 4投票は対面会合アジェンダにあったが、proposals READMEにフェーズ変化の反映なし(結果不明。議事録本文も"TBD"のまま未記入)
- 対面会合の内容を [[2026-08-04-cg]] として要約ページ化(投票結果が一部確認できたため)
- WASI: `docs/Release.md` 新設でリリーストレインを「隔月・第2火曜」に正式化(0.3.1は2026-08-04→2026-08-11に後ろ倒し)。Component Model機能の採否投票プロセスを`CONTRIBUTING.md`に新設、初適用として`map<t>`・`implements`が2026-08-06 WASI Subgroup会議のアジェンダに。[[wasi-roadmap]]に反映
- エンジン実装状況: Acquire-Release AtomicsをChrome(フラグ付き)・Binaryenが追加、WizardがWide Arithmeticを追加(フラグ付き)。ChicoryがEndiveに改名しBytecode Alliance傘下へ。[[wide-arithmetic]]・[[acquire-release-atomics]]に反映、Chicory/Endiveはニュースレターのみ
- component-modelリポジトリは設計文書の変更なし(リリースプロセス文書のみ)
- [[2026-W32]] を生成。手順5(Artifact公開)はCI環境のためスキップ

## [2026-08-02] weekly | 2026-W31

- proposals: フェーズ変化なし(READMEに差分なし)。静かな週
- CG 2026-07-28のvideo call、Stack Subgroup 2026-08-10のvideo callがともに中止。2026-08-04〜05のCG対面会合(Princeton, Siemensホスト)に議論が集約
- 対面会合の議題を確認: Compact Import Section(Phase 4投票)・Wide Arithmetic(Phase 4投票 or 議論)・Relaxed Atomics(Phase 3投票の可能性)・Half Precision(→FP16に改名しPhase 2ポール)など。結果は来週号で報告予定
- component-model: 非推奨だった `canon backpressure.set` 組み込みをCanonical ABI/Explainer/Binaryから削除(`backpressure.inc`/`dec`へ一本化)。[[component-model-overview]]に反映
- WASI: wasi-httpの`fields`リソースについて、転送時シリアライズでのフィールド名ケース保持要件を緩和(HPACK静的テーブル活用のため)。[[wasi-roadmap]]に反映
- エンジン実装状況(features.json): 前回確認時点から新規コミットなし
- custom-page-sizes(SpaceWasm追加)・custom-descriptors(exact/non-exact heap typeのspectec内部リファクタ)は軽微な変更のためSHA更新のみ
- [webassembly.org/news](https://webassembly.org/news/) に新着なし(最新は2026-01-21)
- [[2026-W31]] を生成。手順5(Artifact公開)はCI環境のためスキップ

## [2026-07-26] weekly | 2026-W30

- proposals: [[js-promise-integration]]・[[content-security-policy]]がPhase 4→5(2026-06-24のWG投票、proposals READMEへの反映は2026-07-22)。[[multibyte-array-access]]がPhase 1→2(2026-07-14 CG投票)
- [[multibyte-array-access]]を一次情報(Overview.md)からdeepenして新規作成、[[gc-lang-support]] familyのメンバーに追加(双方向整合)。[[overview]]・[[index]]のフェーズ一覧も更新
- 新規ミーティング要約 [[2026-06-24-wg]] を作成(JSPI・CSPのPhase 5投票の詳細)
- WASI Subgroup 2026-07-09の議事録から、Component Modelの`implements`/`external-id`実験実装を[[wasi-roadmap]]に反映。`wasi-gfx`→`wasi-webgpu`改名、WASI Phase 2のOCI registry要件追加も記録
- エンジン実装状況(features.json): Wasmtime 47でGC/exception handlingがデフォルト有効、Wasmtime 46でBranch Hinting更新(→[[compilation-hints]])、Node.jsのJSPI/exnref対応更新(→[[js-promise-integration]])、OwiがSIMD対応
- component-model: テキスト形式のインデックス解析規則の整理、`realloc`のスレッド実行セマンティクス定義を[[component-model-overview]]に反映(意味論変更ではなく明確化が中心)
- 2026-08-04〜05のCG対面会合(Princeton)の議題を確認、ニュースレターに次回の見どころとして記載(Component Model・Relaxed Atomics・Wide Arithmetic等の投票予定)
- [webassembly.org/news](https://webassembly.org/news/) に新着なし(最新は2026-01-21)。WASIの新リリースなし(0.3.0が現行)
- [[2026-W30]] を生成。手順5(Artifact公開)はCI環境のためスキップ


## [2026-07-19] deepen | familiesページ作成

- 横断ページを3つ作成: [[concurrency]]、[[js-interop]]、[[gc-lang-support]](proposalページ側のfrontmatter `families:` と双方向で整合、機械検証済み)
- binary-size familyはメンバー1件のため見送り

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

## [2026-07-19] weekly | 2026-W29(再チェック)

- CI経由で週次更新を再実行。`state/watch-state.json` の各 `last_sha` を起点に proposals / meetings / WASI / component-model / website(features.json)を再度diff確認したが、直近の実行(07-18)からの新規コミット・議事録・リリースはなし(全リポジトリ `ahead_by: 0`)
- [webassembly.org/news](https://webassembly.org/news/) も新着なし(最新は2026-01-21 "The States of WebAssembly")
- 差分がないため [[2026-W29]]・各wikiページの内容は変更なし(既存の記述を保持)。`watch-state.json` は `last_checked` のみ更新
- 手順5(Artifact公開)はCI環境のためスキップ

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
