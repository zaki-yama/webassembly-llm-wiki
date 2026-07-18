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
  wasi/               # WASI関連(roadmap、主要proposal)
  component-model/    # Component Model関連
  meetings/           # 重要なCG/WGミーティングの要約(YYYY-MM-DD-cg.md 形式)
  newsletter/         # 週次ニュースレター(YYYY-Wnn.md 形式、ISO週番号)
state/
  watch-state.json    # 前回チェック時点の状態(下記参照)
site/
  quartz.config.yaml  # 公開サイト(Quartz)の設定。deploy-siteワークフローが使用
plans/                # 実装計画(wikiの一部ではない)
```

## 公開サイト

wikiは https://zaki-yama.github.io/webassembly-llm-wiki/ にQuartzで公開されている。
mainへの `wiki/` 変更のpushで `.github/workflows/deploy-site.yml` が自動デプロイする。

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
- 一次情報(GitHub上のREADME、議事録、コミット)へのURLを必ず含める
- 新しい情報が既存の記述と矛盾する場合は黙って上書きせず、「〜とされていたが、YYYY-MM-DDのXXにより〜に変わった」と経緯を残す

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
  }
}
```

## ワークフロー

### ingest(手動ソース取り込み)
1. ユーザーが `raw/` に置いたソース(または指定したURL)を読む
2. 要点を議論し、関連するwikiページを作成・更新する(1ソースで複数ページに波及してよい)
3. `index.md` を更新、`log.md` に `## [YYYY-MM-DD] ingest | <タイトル>` を追記

### weekly(週次更新)
`/weekly-update` スキル(`.claude/skills/weekly-update/SKILL.md`)に従う。
差分収集 → wikiページ反映 → `newsletter/YYYY-Wnn.md` 生成 → state更新 → コミット。
(サイトへの反映はpush後にdeploy-siteワークフローが自動で行う)

### query(質問応答)
1. `index.md` から関連ページを探して読み、一次情報URLつきで回答する
2. 回答が再利用価値を持つ場合(比較表・分析など)はwikiページとして保存し、indexとlogを更新

### lint(健全性チェック)
ページ間の矛盾、古い記述(フェーズ変化の反映漏れ)、孤立ページ、リンク切れを点検し、
修正提案をユーザーと相談してから反映。`log.md` に記録。

## 情報源(ウォッチ対象)

| ソース | 見るもの |
|---|---|
| github.com/WebAssembly/proposals | README.md / finished-proposals.md のフェーズ変化 |
| github.com/WebAssembly/meetings | `main/YYYY/` と `wasi/YYYY/` の新規議事録(投票結果を優先) |
| github.com/WebAssembly/website | `features.json`(エンジン実装状況) |
| github.com/WebAssembly/WASI | リリース、roadmap変化 |
| github.com/WebAssembly/component-model | コミット、リリース、主要PR |
| webassembly.org/news | 新着記事 |
| bytecodealliance.org/articles, wasmweekly.news | 補助(取りこぼし確認) |

## コミット規約

- ニュースレター生成時: `weekly: 2026-W30`
- 手動ingest時: `ingest: <ソース名>`
- スキーマ・ツール変更時: 通常のコミットメッセージ
