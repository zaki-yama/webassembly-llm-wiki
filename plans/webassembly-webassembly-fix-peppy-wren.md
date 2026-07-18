# WebAssembly仕様キャッチアップ用 LLM Wiki プロジェクト計画

## Context

WebAssemblyの仕様策定状況(どのproposalが議論中で、どれがFIXしたか)を継続的に追いかけたい。llm-wiki.md のパターン(LLMが維持する永続的なwiki)をベースに、週次でニュースレター的なアップデートを受け取れる仕組みを作る。

ユーザーの決定事項:
- **配信形態**: wiki内のMarkdownページ + claude.ai上のArtifact(Webページ)。内容へのQ&AはClaude Codeセッションで行う
- **実行方法**: GitHub Actions(週次cron)
- **スコープ**: コア仕様(WebAssembly/proposals) + WASI + Component Model
- **言語**: 日本語(技術用語・proposal名は英語のまま)

## 調査結果: ウォッチすべき情報源

| 情報源 | 内容 | 追い方 |
|---|---|---|
| [WebAssembly/proposals](https://github.com/WebAssembly/proposals) | 全proposalのフェーズ(Phase 0〜5)を一元管理するメタリポジトリ。README.mdとfinished-proposals.mdの差分がフェーズ変化そのもの | コミット差分 |
| [WebAssembly/meetings](https://github.com/WebAssembly/meetings) | CG/WGミーティングの議事録。`main/2026/CG-MM-DD.md` 形式。フェーズ移行の投票(poll)はここで起きる | 新規ファイル検出 |
| [webassembly.org/features](https://webassembly.org/features/) | 各エンジン(Chrome/Firefox/Safari等)の機能実装状況。データは [features.json](https://github.com/WebAssembly/website/blob/main/features.json) | features.jsonの差分 |
| [WebAssembly/WASI](https://github.com/WebAssembly/WASI) + [wasi.dev/roadmap](https://wasi.dev/roadmap) | WASIのproposalとリリース(0.3.0が2026-06リリース済、0.3.xリリーストレイン進行中) | リリース・議事録(meetings repo の `wasi/`) |
| [WebAssembly/component-model](https://github.com/WebAssembly/component-model) | Component Modelの仕様・WIT機能提案 | コミット・リリース |
| [webassembly.org/news](https://webassembly.org/news/) | 公式ニュース(例: Wasm 3.0完了 2025-09) | 新規記事 |
| 補助: [Bytecode Alliance blog](https://bytecodealliance.org/articles/), [WasmWeekly](https://wasmweekly.news/) | エコシステム動向。取りこぼし補完用 | 週次で目視相当のチェック |

フェーズ制度: [meetings/process/phases.md](https://github.com/WebAssembly/meetings/blob/main/process/phases.md)。Phase 0(検討)→1(提案)→2(仕様文面)→3(実装)→4(標準化)→5(標準化済み・本体仕様へマージ)。「FIXした」= Phase 5 / finished-proposals.md入り。

## リポジトリ構成(新規作成)

```
webassembly-llm-wiki/
├── CLAUDE.md                  # スキーマ: wiki構造・規約・ワークフロー定義
├── llm-wiki.md                # 元のアイデアファイル(そのまま保持)
├── raw/                       # 取り込んだ生ソース(不変)
├── wiki/
│   ├── index.md               # 全ページのカタログ
│   ├── log.md                 # 追記専用の作業ログ(`## [YYYY-MM-DD] ingest | ...` 形式)
│   ├── overview.md            # Wasm仕様策定の全体像(フェーズ制度の解説含む)
│   ├── proposals/             # proposal毎に1ページ(frontmatter: phase, repo, 最終更新日)
│   │   ├── stack-switching.md など
│   ├── wasi/                  # WASI関連(roadmap, 各proposal)
│   ├── component-model/
│   ├── meetings/              # CG/WG議事録の要約(重要回のみ)
│   └── newsletter/            # 週次ニュースレター 2026-W30.md 形式
├── state/
│   └── watch-state.json       # 前回チェック時点の状態(各repoの最終確認コミットSHA、処理済み議事録ファイル一覧)
├── .claude/skills/weekly-update/SKILL.md   # /weekly-update スキル
└── .github/workflows/weekly-update.yml     # 週次cron
```

## 実施ステップ(この順番で進める)

### Step 1: リポジトリ初期化とスキーマ作成
- `git init` + GitHubリポジトリ作成(`gh repo create`)
- `CLAUDE.md` を作成: wiki構造、ページ規約(frontmatter、`[[リンク]]`)、ingest/query/lint/weekly-updateの各ワークフロー、日本語記述ルールを定義

### Step 2: 初期ベースラインの構築(一度きりの大きなingest)
- WebAssembly/proposals のREADMEとfinished-proposals.mdから全proposalの現在フェーズを取得し、主要proposal(Phase 2以上 + 注目のPhase 1)の個別ページを `wiki/proposals/` に作成
- WASI(0.3.0リリース状況・roadmap)、Component Modelの現状ページを作成
- `overview.md`(フェーズ制度と全体地図)、`index.md`、`log.md` を作成
- `state/watch-state.json` に現時点の各repoのHEAD SHAを記録 → 以降の週次差分の起点

### Step 3: /weekly-update スキルの作成
週次更新の手順を `.claude/skills/weekly-update/SKILL.md` に定義:
1. `watch-state.json` を読み、前回以降の差分を収集
   - `gh api` で WebAssembly/proposals のコミット差分(フェーズ変化検出)
   - WebAssembly/meetings の新規議事録ファイル(`main/`, `wasi/`)→ 中身を読んで投票結果・重要議論を抽出
   - features.json の差分(エンジン実装状況の変化)
   - WASI / component-model の新規リリース・マージされた主要PR
   - webassembly.org/news の新着
2. 差分を該当するwikiページ(proposals/等)に反映
3. `wiki/newsletter/2026-Wnn.md` を生成(構成: 今週のハイライト / フェーズ移行 / 議事録から / 実装状況 / WASI・Component Model / その他)
4. ニュースレターをArtifactとして公開(初回以降は同一URLを更新)
5. `watch-state.json` と `index.md`、`log.md` を更新してコミット

### Step 4: 手動で1回実行して品質確認
- ローカルのClaude Codeセッションで `/weekly-update` を実行し、ニュースレターの内容・粒度を確認して調整(GitHub Actions化の前に出力品質を固める)

### Step 5: GitHub Actions化
- `.github/workflows/weekly-update.yml`: 週次cron(例: 月曜 09:00 JST)+ `workflow_dispatch`
- [claude-code-action](https://github.com/anthropics/claude-code-action) で `/weekly-update` 相当のプロンプトを実行、結果をコミット&プッシュ
- 認証: `CLAUDE_CODE_OAUTH_TOKEN` または `ANTHROPIC_API_KEY` をSecretsに設定

## 元のllm-wiki構想との対比

**踏襲している部分:**
- 3層アーキテクチャ: raw sources(`raw/`)/ wiki(`wiki/`)/ スキーマ(`CLAUDE.md`)
- `index.md`(内容カタログ)+ `log.md`(`## [日付] 種別 | タイトル` 形式の追記専用ログ)の2特殊ファイル
- Ingest / Query / Lint の3操作。Queryの回答をwikiにページとして還元し知識を複利化する思想
- wikiは全てLLMが書き、人間はソース選定・方向付け・質問に専念
- Obsidian互換のMarkdown + `[[リンク]]`、gitによる履歴管理

**変更・拡張している部分(理由つき):**
- **pull型→watch型**: 元の構想は「人間がソースを持ち込んでingest」が中心。本計画は情報源が固定的(GitHub上の数リポジトリ)なため、**LLMが自動で差分を取りに行く定点観測**を主軸にする。手動ingest(気になった記事の取り込み)は補助的に残る
- **`state/watch-state.json` の追加**: 元の構想にない要素。「前回どこまで見たか」を機械可読に持たないと週次差分が検出できないため導入
- **newsletter/ の定期自動生成**: 元の構想の「Query結果のページ化」を、週次で自動実行する定型クエリとして制度化したもの
- **自動化(GitHub Actions)**: 元の構想は対話的な運用が基本(バッチingestは選択肢として言及される程度)。週次更新という要求のため自動化する。ただしStep 4で対話的に品質を固めてから移行する
- **Artifact公開**: 元の構想はObsidianで読む前提。配信面としてWebページを追加

**採用を見送ったもの(必要になったら導入):**
- Obsidian Web Clipper・画像のローカルDL(ソースがほぼGitHub上のテキストのため。`raw/` は消える可能性のあるブログ記事等の保存用として残す)
- qmd等の検索エンジン(規模が小さいうちは `index.md` で十分)
- Marp / Dataview

## 既知のリスクと対応

- **GitHub Actions内でのArtifact更新**: Artifact公開はclaude.aiアカウントに紐づく機能のため、CI環境(claude-code-action)で利用できない可能性がある。Step 5で検証し、不可の場合のフォールバック: (a) ActionsはMarkdown生成+コミットまで担当し、Artifact更新はローカルセッションで随時実施、または (b) WebページをGitHub Pagesに切り替え
- **議事録の量**: CG議事録は長大なことがある。週次ジョブでは「投票結果」「フェーズ移行議題」を優先抽出し、詳細要約は関心のある回だけ手動ingestする運用にする

## 検証方法

1. Step 2完了後: `wiki/index.md` から数ページ辿り、フェーズ情報が [WebAssembly/proposals](https://github.com/WebAssembly/proposals) の実際の記載と一致することを確認
2. Step 4: `/weekly-update` を実行し、直近1週間の実際の動き(コミット・議事録)がニュースレターに反映されることを確認。Q&Aとして「今Phase 4にあるproposalは?」等を質問して回答品質を確認
3. Step 5: `workflow_dispatch` で手動トリガーし、コミットが積まれることを確認
