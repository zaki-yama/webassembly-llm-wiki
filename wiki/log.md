# Log

## [2026-08-30] weekly | 2026-W35

- proposals: フェーズ変化なし(READMEに差分なし)
- **[[component-model-overview]]**: 今週最大の変更。**リエントランスモデルの再設計**([#705](https://github.com/WebAssembly/component-model/commit/2f13265)): Canonical ABIから`ComponentInstance.may_enter`フラグ・`parent`フィールドによる親子追跡・`may_enter_from`/`enter_from`/`leave_to`トラップ機構を全廃。旧Component Invariant #2(donut wrapping時のみ再入をトラップで防ぐ)と#3(オプトインなしのコア実行を暗黙シリアライズ)を単一の#2「run-to-completion」則に統合し、`Store.nesting_depth`ベースの単純なアサーションに置き換えた。donut wrappingでの再入はホストからの再入と対等に扱われるようになり、トラップで防がれる特別な再入ケースがなくなった(Explainer/Concurrency/CanonicalABI/Linkingの広範な書き換えを確認して反映)。ほかに[#708](https://github.com/WebAssembly/component-model/commit/4acb0de)(future readable end dropのバグ修正)、[#704](https://github.com/WebAssembly/component-model/commit/0036fe1)(`strongly-unique`のハイフン非依存化)、[#714](https://github.com/WebAssembly/component-model/commit/50a1ab9)(WIT `use-names-list`の末尾カンマ許可)を反映
- **[[custom-descriptors]]**: Overview.mdでサブタイピング規則を引き締め。supertype側にも`descriptor`節を必須化し、規則群を「complete square」則として図式的に整理、`ref.cast_desc_eq`の健全性根拠を明記([commit](https://github.com/WebAssembly/custom-descriptors/commit/7b64bc8))
- **[[compact-import-section]]**: リポジトリは2コミット差だが設計文書(Overview.md)は無変更(spectec同期ノイズ+テストファイルのみ)。features.jsonにChromeのフラグ付き実装が追加されたため経緯と現状に反映([commit](https://github.com/WebAssembly/website/commit/3bfcd17169ffbd4ef2cb9e9eb6baa0021c416e6c))
- **[[acquire-release-atomics]]**: テストファイル(`threaded.wast`)のみの変更。設計文書に変化なし、Phase 3投票も進展なし
- ミーティング: CG 2026-08-25キャンセル。CG 2026-09-08・Stack Subgroup 2026-09-21は将来アジェンダ(後者は"Introduction to Reified Fibers"という新規話題を掲載、[[stack-switching]]に隣接)で議事メモなし
- **WASI Subgroup 2026-08-20**の議事メモが今週リポジトリに追記され、新規に [[2026-08-20-wasi]] を作成。投票はないが、リリースプロセスの運用細則(次回0.3.2は2026-10-13、投票にかける提案は投票回の1週間前までにissue提出)と250件超のissueトライアージ方針(WASI loggingは`wasi:otel`へ吸収されクローズ方向、mmap MVPは[[memory-control]]側への差し戻し等)を[[wasi-roadmap]]・[[memory-control]]に反映
- エンジン実装状況: Wasmer 7.3.0がmulti-memory対応、標準ランタイム表に新規エンジンzwasm追加。features.jsonの`typeReflection`(js-types側の別proposal、当wiki未追跡)のphase表記がPhase 3→1に訂正されたが、これは当wikiの追跡対象proposal一覧には含まれない
- webassembly.org/news、bytecodealliance.org/articlesとも今週の新着なし
- [[2026-W35]] を生成。手順5(Artifact公開)はCI環境のためスキップ

## [2026-08-23] weekly | 2026-W34

- proposals: フェーズ変化なし(READMEに差分なし)。静かな週
- ミーティング: WG 2026-08-19・Threads Subgroup 2026-08-18・Stack Subgroup 2026-08-24はいずれも議題不足でキャンセル。WASI 2026-08-20は通常アジェンダで開催(0.3.1リリースのアナウンス)だが議事メモは未記入で大きな決定は確認できず
- **[[extended-name-section]]**: Overview.mdの文面整理(意味論変更なし)。「elem names」→「element segment names」等の表記統一、`@name`アノテーションとname sectionの非同期に触れる動機説明を追加([commit](https://github.com/WebAssembly/extended-name-section/commit/d4af276))。リポジトリは257コミット差があったが、実質的な変更は本Overview.md 1件のみ(残りは上流spec同期のノイズ)
- **[[custom-descriptors]]**: テストファイルのみの変更、設計文書に変化なし。SHAのみ更新
- **[[acquire-release-atomics]]**: 参照インタプリタの実装作業が継続(interpreter/testファイルのみ、Overview.mdに変化なし)。Phase 3投票は今週も進展なし。watr v5.9.0がサポート追加([commit](https://github.com/WebAssembly/website/commit/ca557f09266bb722f6cd091f4d7d68048106efa0))
- **[[fp16]]**: watr v5.8.0がサポート追加([commit](https://github.com/WebAssembly/website/commit/5d466d1b084924b75ee4e57d9e3e83051eb4fbf5))
- **エンジン実装状況**: features.jsonに新規ランタイム`Wasm3`追加([commit](https://github.com/WebAssembly/website/commit/bd5e179e1b0eb27a546d3a59951134cc861dbfbb))。Wasmiの表示順整理(機能差分なし)は反映見送り
- **[[component-model-overview]]**: コンポーネント値型の最大静的サイズ規定(`elem_size <= 2^28-1`、[#688](https://github.com/WebAssembly/component-model/commit/ce4fb2b9435e1a45ff4403a769f7ef650e92e9cc))、Canonical ABIのキャンセレーション配送順序バグ修正2件([#707](https://github.com/WebAssembly/component-model/commit/1af0b35e1bfc03bd4ad9603be2f676316ff9f420)ほか)、WIT `strongly-unique`規則の推移性明確化・resourceメソッドへのfeature gate許可([#703](https://github.com/WebAssembly/component-model/commit/a0d6134013bd83563c7477be1b67fcdfa138880d)、[#700](https://github.com/WebAssembly/component-model/commit/1b265a6))を反映
- **WASI**: `specifications/wasi-0.3.1/Overview.md`追加。8/11リリース済み0.3.1の正式仕様文書がリポジトリに反映された(リリース自体の後追いで新機能なし。[commit](https://github.com/WebAssembly/WASI/commit/3071db04c857b3a2c047d3d1ac694bc41f021796))。[[wasi-roadmap]]に反映
- webassembly.org/news、bytecodealliance.org/articlesとも今週の新着なし
- [[2026-W34]] を生成。手順5(Artifact公開)はCI環境のためスキップ

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
