# WebAssembly LLM Wiki — スキーマ

WebAssemblyの仕様策定状況(proposal・WASI・Component Model)を追跡するLLM維持型wiki。
コンセプトは `llm-wiki.md` を参照。このファイルはその具体的な実装規約を定義する。

## 言語

wiki・ニュースレターとも日本語で記述する。技術用語・proposal名・引用は英語のまま。

## ディレクトリ構造

```
raw/                  # 手動で取り込んだ生ソース(不変。LLMは読むだけで編集しない)
wiki/
  index.md            # 全ページのカタログ。ページ追加・更新のたびに必ず更新する
  log.md              # 追記専用ログ。形式: ## [YYYY-MM-DD] <種別> | <タイトル>
                      #   種別: ingest / weekly / query / lint
  overview.md         # Wasm標準化プロセスの全体像(フェーズ制度、組織、情報源)
  proposals/          # コア仕様のproposal毎に1ページ(kebab-case.md)
  families/           # 複数proposalを束ねる横断ページ(kebab-case.md)
  wasi/               # WASI関連(roadmap、主要proposal)
  component-model/    # Component Model関連
  meetings/           # 重要なCG/WGミーティングの要約(YYYY-MM-DD-cg.md 形式)
  newsletter/         # 週次ニュースレター(YYYY-Wnn.md 形式、ISO週番号)
state/
  watch-state.json    # 前回チェック時点の状態(下記参照)
plans/                # 実装計画(wikiの一部ではない)
```

## ページ規約

- すべてのwikiページはYAML frontmatterを持つ:
  ```yaml
  ---
  title: Stack Switching
  type: proposal | wasi | component-model | meeting | newsletter | concept
  phase: 3            # proposalページのみ。0-5 または "finished"
  repo: https://github.com/WebAssembly/stack-switching   # あれば
  updated: 2026-07-18
  ---
  ```
- ページ間リンクはObsidian形式 `[[stack-switching]]` を使う(拡張子なし・パスなし)
- 一次情報(GitHub上のREADME、議事録、コミット)へのURLを必ず含める。**本文の内容を特定版に紐づけて引用・参照するときはSHA付きpermalink**(`blob/<SHA>/...`)を使う(議事録は投票後に追記されうるため)
- 新しい情報が既存の記述と矛盾する場合は黙って上書きせず、「〜とされていたが、YYYY-MM-DDのXXにより〜に変わった」と経緯を残す

## ソース優先順位(precedence)

情報源同士が食い違ったときにどれを信じるか:

- **proposalの現在フェーズ・champion** → [WebAssembly/proposals](https://github.com/WebAssembly/proposals) のREADME / finished-proposals.md が一次(現在のスナップショット。経緯は持たない)
- **フェーズ遷移の経緯・投票結果・論点** → [WebAssembly/meetings](https://github.com/WebAssembly/meetings) の議事録が一次
- **各proposalの技術的内容(仕組み・命令・型)** → 各proposalリポジトリのExplainer等が一次
- **エンジン実装状況** → website リポジトリの features.json が一次

食い違ったら、まず自分の読み取りを疑い、両方を辿り直してから修正する。

## proposalページのテンプレート

`wiki/proposals/<slug>.md` の本文は次のセクション構成を必須とする(見本: [[stack-switching]]):

1. 冒頭: **Phase N** / Champion
2. `## 一言でいうと` — 1〜2文
3. `## なぜ必要か(Motivation)` — 何が問題で、どんなアプローチを取るか
4. `## 仕組み` — 主要な新命令・型・概念(表を推奨)
5. `## 例` — 可能ならWATコード(Explainerから引用)
6. `## フェーズ遷移` — 時系列テーブル。1行=1イベント。`| 時期 | できごと | Phase |`。議事録・コミットへのSHA付きリンクを付ける。proposals READMEのgit履歴と議事録から再構成する
7. `## 経緯と現状` — 設計の変遷、実装状況、関連proposalとの役割分担
8. `## 関連` — `[[リンク]]`
9. `## 一次情報` — 出典リンク(Explainer等)

**行動ルール**: proposalページを新規作成・大幅更新するときは、必ずfrontmatterの `repo:` にあるリポジトリの説明文書を読んでから書く(探す優先順: `proposals/<name>/Explainer.md` などのExplainer → `Overview.md` → `README.md`)。proposals一覧のREADMEだけから書かない。

## familiesページ(横断ページ)

`wiki/families/<slug>.md`。複数のproposalを貫くテーマ(例: concurrency, js-interop)をまとめるsynthesisページ。

- frontmatter: `type: family` と `members: [slug, ...]` を持つ
- proposalページ側はfrontmatterに `families: [slug, ...]` を持つ。**メンバーシップは双方向で一致させる**(lint点検対象)
- 個別proposalの経緯・仕組みはproposalページに置き、familyからはリンクするだけ(複製しない)
- 本文構成: `## 概要`(束ねる軸)/ `## メンバー`(表: 提案|Phase|一言)/ `## 横断テーマ` / `## 関連family`

## watch-state.json の形式

```json
{
  "last_checked": "2026-07-18",
  "repos": {
    "WebAssembly/proposals": {"last_sha": "..."},
    "WebAssembly/meetings": {"last_sha": "..."},
    "WebAssembly/component-model": {"last_sha": "..."},
    "WebAssembly/WASI": {"last_sha": "..."},
    "WebAssembly/website": {"features_json_sha": "..."}
  },
  "artifact_url": null,
  "proposal_repos": {
    "WebAssembly/stack-switching": {"last_sha": "..."}
  }
}
```

`artifact_url` には週次ニュースレターのArtifact URLを保存し、毎週同じURLを更新する。
`proposal_repos` は個別proposalリポジトリの前回チェックSHA(deepen済みページのfrontmatter `repo:` と対応)。
週次更新で差分をチェックし、Explainer等の変更をwikiに反映する。

## ワークフロー

**手順の正本はスキル**(`.claude/skills/*/SKILL.md`)に置く。本ファイルは規約と概要のみを持ち、
同じ手順を二重に書かない(食い違ったらスキル側が正)。

### ingest(手動ソース取り込み)
1. ユーザーが `raw/` に置いたソース(または指定したURL)を読む
2. 要点を議論し、関連するwikiページを作成・更新する(1ソースで複数ページに波及してよい)
3. `index.md` を更新、`log.md` に `## [YYYY-MM-DD] ingest | <タイトル>` を追記

### weekly(週次更新)
`/weekly-update` スキル(`.claude/skills/weekly-update/SKILL.md`)に従う。
差分収集 → wikiページ反映 → `newsletter/YYYY-Wnn.md` 生成 → Artifact更新 → state更新 → コミット。

### query(質問応答)
1. `index.md` から関連ページを探して読み、一次情報URLつきで回答する
2. 回答が再利用価値を持つ場合(比較表・分析など)はwikiページとして保存し、indexとlogを更新

### deepen(proposalページの深掘り)
`/deepen-proposal` スキル(`.claude/skills/deepen-proposal/SKILL.md`)に従う。
対象proposalリポジトリのExplainerをingestし、テンプレート水準のページに書き直す。

### lint(健全性チェック)
ページ間の矛盾、古い記述(フェーズ変化の反映漏れ)、孤立ページ、リンク切れ、
families双方向メンバーシップの不整合、
proposalページのfrontmatter `repo:` にあるのに `watch-state.json` の `proposal_repos` に未登録のリポジトリ(監視漏れ)
を点検し、修正提案をユーザーと相談してから反映。`log.md` に記録。

## 情報源(ウォッチ対象)

| ソース | 見るもの |
|---|---|
| github.com/WebAssembly/proposals | README.md / finished-proposals.md のフェーズ変化 |
| 各proposalのリポジトリ(ページfrontmatterの `repo:`) | Explainer / Overview / README(技術的内容の一次情報。`watch-state.json` の `proposal_repos` で差分を監視) |
| github.com/WebAssembly/meetings | `main/YYYY/` と `wasi/YYYY/` の新規議事録(投票結果を優先) |
| github.com/WebAssembly/website | `features.json`(エンジン実装状況) |
| github.com/WebAssembly/WASI | リリース、roadmap変化 |
| github.com/WebAssembly/component-model | コミット、リリース、主要PR |
| webassembly.org/news | 新着記事 |
| bytecodealliance.org/articles, wasmweekly.news | 補助(取りこぼし確認) |

## コミット規約

- ニュースレター生成時: `weekly: 2026-W30`
- 手動ingest時: `ingest: <ソース名>`
- proposalページの深掘り時: `deepen: <slug>`(複数なら `deepen: phase-4 proposals` のように範囲で)
- lint反映時: `lint: <修正内容の要約>`
- スキーマ・ツール変更時: 通常のコミットメッセージ
