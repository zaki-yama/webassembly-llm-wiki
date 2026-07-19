---
name: weekly-update
description: WebAssembly仕様の週次アップデートを収集し、wikiに反映してニュースレターを生成・公開する
---

# 週次アップデート手順

前回チェック時点からの差分を収集し、wikiページへ反映した上で `wiki/newsletter/YYYY-Wnn.md` を生成する。
すべての手順で `CLAUDE.md` のページ規約(frontmatter、`[[リンク]]`、一次情報URL必須)に従うこと。

## 1. 状態の読み込み

`state/watch-state.json` を読む。各リポジトリの `last_sha` が差分の起点。

## 2. 差分収集

### 2a. proposalのフェーズ変化(最重要)

```
gh api "repos/WebAssembly/proposals/compare/<last_sha>...HEAD" --jq '{status, ahead_by, files: [.files[].filename], commits: [.commits[] | {sha: .sha[0:7], message: .commit.message}]}'
```

- `README.md` / `finished-proposals.md` に変更があれば patch を確認し、どのproposalがどのフェーズへ動いたかを特定する
- 新規proposalの追加、inactive化も検出対象

### 2b. CG/WG・subgroupミーティング議事録

```
gh api "repos/WebAssembly/meetings/compare/<last_sha>...HEAD" --jq '[.files[].filename]'
```

- 新規追加された `main/YYYY/CG-*.md` / `WG-*.md` / `wasi/`, `threads/`, `stack/`, `gc/` 等の議事録ファイルを列挙
- 新規議事録は raw contentを取得して読み、**投票(poll)の結果とフェーズ移行の議論を最優先で抽出**。次いで大きな設計議論
- 重要な回は `wiki/meetings/YYYY-MM-DD-cg.md` として要約ページを作る(全部は作らない。投票があった回・大きな決定があった回のみ)

### 2c. エンジン実装状況

```
gh api "repos/WebAssembly/website/commits?path=features.json&per_page=10" --jq '[.[] | {sha, date: .commit.committer.date, message: .commit.message}]'
```

- `features_json_last_sha` より新しいコミットがあれば差分を見て、どの機能がどのエンジンでサポートされたかを抽出

### 2d. WASI / Component Model

```
gh api "repos/WebAssembly/WASI/compare/<last_sha>...HEAD"
gh api "repos/WebAssembly/component-model/compare/<last_sha>...HEAD"
gh api repos/WebAssembly/WASI/releases --jq '[.[0:3][] | {tag_name, published_at}]'
```

- 新リリース、roadmap・Proposals.mdの変化、大きなマージPRを抽出

### 2e. 個別proposalリポジトリ(Explainer等の変更)

`watch-state.json` の `proposal_repos` にある各リポジトリを差分チェックする:

```
gh api "repos/WebAssembly/<name>/compare/<last_sha>...HEAD" --jq '{ahead_by, files: [.files[].filename]}'
```

- Explainer / Overview 等の**設計文書に変更があった場合のみ**中身を確認し、該当proposalページの「仕組み」「経緯と現状」を更新する(CI設定やテストだけの変更はSHA更新のみでよい)
- 大きな設計変更はニュースレターのproposal動向にも載せる

### 2f. 公式ニュース・補助ソース

- https://webassembly.org/news/ の新着(WebFetchで確認)
- 余裕があれば https://bytecodealliance.org/articles/ も確認(補助。なければ省略可)

## 3. wikiページへの反映

- フェーズ変化があったproposalは該当ページの `phase:` と本文を更新し、「YYYY-MM-DDのCG投票でPhase Nに移行」と経緯を書く(フェーズ遷移テーブルにも行を追加。[[overview]] のスナップショット一覧も更新)
- **新規proposal(一覧への追加・フェーズ移行での昇格)を検出したら、`/deepen-proposal` の手順で一次情報(Explainer等)をingestしてテンプレート水準のページを作る**。時間の制約でスタブに留めた場合はindex.mdで無印(未深掘り)にし、log.mdにその旨を書く
- WASI/Component Modelの動きは [[wasi-roadmap]] / [[component-model-overview]] に反映

## 4. ニュースレター生成

`wiki/newsletter/YYYY-Wnn.md`(ISO週番号、例: 2026-W29)を作成。構成:

```markdown
---
title: WebAssembly Weekly YYYY-Wnn
type: newsletter
updated: YYYY-MM-DD
---

# WebAssembly Weekly YYYY-Wnn (M/D〜M/D)

## 今週のハイライト
(最重要トピック1〜3個を2〜3文で。何もない週は「大きな動きなし」と正直に書く)

## フェーズ移行・proposal動向
## ミーティングから
## エンジン実装状況
## WASI / Component Model
## その他
```

- 各項目に一次情報(コミット・議事録・リリース)へのURLを付ける
- 関連するwikiページへ `[[リンク]]` する
- 動きがなかったセクションは省略してよい

## 5. Artifact公開

- ニュースレターをArtifactとして公開する(favicon: 🧩、タイトル: "WebAssembly Weekly")
- `watch-state.json` の `artifact_url` がnullでなければ、その `url` を指定して**同一URLを更新**する。初回公開時はURLを `artifact_url` に保存する
- Artifactツールが使えない環境(CI)ではこの手順をスキップし、その旨をログに残す

## 6. 後始末

1. `state/watch-state.json` を更新: 各リポジトリの新しいHEAD SHA(compare結果の最新コミット)、`proposal_repos` の各SHA、`last_checked` を今日の日付に
2. `wiki/index.md` のニュースレター節に新しい号を追加
3. `wiki/log.md` に `## [YYYY-MM-DD] weekly | YYYY-Wnn` を追記
4. コミット: `weekly: YYYY-Wnn`(CIの場合はプッシュも行う)
