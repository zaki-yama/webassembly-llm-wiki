---
name: deepen-proposal
description: proposalページを一次情報(リポジトリのExplainer等)から深掘りし、テンプレート水準に書き直す
---

# proposalページ深掘り手順

引数: proposalのslug(例: `stack-switching`)。複数指定されたら1つずつ順に処理する。
CLAUDE.mdの「proposalページのテンプレート」「ソース優先順位」「ページ規約」に従うこと。

## 1. 一次情報の取得

1. `wiki/proposals/<slug>.md` のfrontmatterから `repo:` を得る(なければ [proposals README](https://github.com/WebAssembly/proposals) のリンク集で探して補う)
2. リポジトリの説明文書を探す。優先順:
   - `proposals/<name>/Explainer.md`(または `Overview.md`)— spec forkリポジトリの標準配置
   - ルートの `Explainer.md` / `Overview.md`
   - `README.md`(上記がない場合の最後の手段)
   ```
   gh api repos/WebAssembly/<name>/contents --jq '.[].name'   # ルートを見る
   gh api repos/WebAssembly/<name>/contents/proposals --jq '.[].name' 2>/dev/null
   ```
3. 見つけた文書のrawをscratchpadに保存して**全体を読む**(長い場合も少なくとも構成・Motivation・命令一覧・例は読む)
4. 現在のHEAD SHAを控える(`gh api repos/WebAssembly/<name>/commits/HEAD --jq .sha`)。
   引用リンクはこのSHAでpermalink化する

## 2. フェーズ遷移の再構成

「いつPhaseが動いたか」は proposals リポジトリのREADME履歴から機械的に掘れる:

```
# READMEへの変更履歴から、この proposal の行が動いたコミットを探す
gh api "repos/WebAssembly/proposals/commits?path=README.md&per_page=100" \
  --jq '.[] | {sha: .sha[0:7], date: .commit.committer.date[0:10], msg: (.commit.message | split("\n")[0])}'
```

- コミットメッセージに proposal 名やフェーズ移動が書かれていることが多い。曖昧なら該当コミットのpatchを確認
- 遷移日付近のCG議事録(`WebAssembly/meetings` の `main/YYYY/CG-*.md`)を探し、**投票(poll)の記録**があれば議事録へのSHA付きリンクを張る
- 見つからない遷移は無理に埋めず「proposals READMEへの追加: YYYY-MM」など判る範囲で書く

## 3. ページの書き直し

CLAUDE.mdのテンプレート構成(一言でいうと / なぜ必要か / 仕組み / 例 / フェーズ遷移 / 経緯と現状 / 関連 / 一次情報)で書き直す。分量の目安は80〜120行。見本: [[stack-switching]]

- 「仕組み」は新命令・型を表にまとめる。「例」はExplainerのWATコードを1つ引用(出典リンク付き)
- 既存ページの記述と一次情報が食い違ったら、precedence(CLAUDE.md)に従い経緯を残して修正
- frontmatterの `updated:` を今日に、`families:` を該当があれば設定(families側の `members:` も同期)

## 4. 後始末

1. `state/watch-state.json` の `proposal_repos` に `"WebAssembly/<name>": {"last_sha": "<HEAD SHA>"}` を記録
2. `wiki/index.md` の該当行に深掘り済みマーク(下記)を付ける
   - index.mdでは深掘り済みページを `✔` で示す(例: `- [[stack-switching]] ✔ — ...`)。無印は「一覧情報のみの薄いページ」を意味する
3. `wiki/log.md` に `## [YYYY-MM-DD] deepen | <slug>` を追記
4. コミット: `deepen: <slug>`(複数まとめて処理した場合は範囲表記でよい)
