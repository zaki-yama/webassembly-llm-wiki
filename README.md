# webassembly-llm-wiki

WebAssemblyの仕様策定状況(どのproposalが議論中で、どれがFIXしたか)を追跡する、LLM維持型のwiki。

[Andrej Karpathyの LLM Wiki](https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f)([llm-wiki.md](./llm-wiki.md) に全文コピー)の「LLMが永続的なwikiを構築・維持する」パターンを、固定的な情報源を定点観測する **watch型** にアレンジしたもの。wikiのページはすべてClaude Codeが書き、人間は情報源の選定・方向付け・質問を担当する。

## できること

- **公開サイト**: wiki全体を [zaki-yama.github.io/webassembly-llm-wiki](https://zaki-yama.github.io/webassembly-llm-wiki/) でQuartzにより公開(グラフビュー・バックリンク・全文検索つき。更新は [RSS](https://zaki-yama.github.io/webassembly-llm-wiki/index.xml) で購読可能)
- **週次ニュースレター**: 毎週、proposalのフェーズ変化・CG/WG議事録・エンジン実装状況・WASI/Component Modelの動きを収集し、`wiki/newsletter/YYYY-Wnn.md` を生成
- **Q&A**: このリポジトリでClaude Codeを開いて質問する(例:「Stack Switchingの現状は?」「今Phase 4にあるproposalは?」)。wikiを参照して一次情報URLつきで回答され、価値のある回答はwikiに還元される
- **手動ingest**: 気になった記事を `raw/` に置いて「ingestして」と頼むと、wikiに統合される

## ディレクトリ構成

```
CLAUDE.md             # スキーマ: wiki構造・規約・ワークフロー定義(LLMへの指示書)
llm-wiki.md           # 元になったアイデアファイル
raw/                  # 手動で取り込む生ソース(不変)
wiki/
  index.md            # 全ページのカタログ(エントリポイント)
  log.md              # 追記専用の作業ログ
  overview.md         # Wasm標準化プロセスの全体像とproposal一覧スナップショット
  proposals/          # コア仕様のproposal毎に1ページ
  wasi/               # WASI関連
  component-model/    # Component Model関連
  meetings/           # 重要なCG/WG・subgroupミーティングの要約
  newsletter/         # 週次ニュースレター
state/watch-state.json  # 前回チェック時点の各リポジトリのSHA(週次差分の起点)
site/quartz.config.yaml # 公開サイト(Quartz)の設定
.claude/skills/weekly-update/  # /weekly-update スキル(週次更新の手順書)
.github/workflows/weekly-update.yml  # 週次cron(日曜21:00 JST)
.github/workflows/deploy-site.yml    # wiki/変更時にQuartzでビルドしGitHub Pagesへデプロイ
```

## ウォッチしている情報源

| ソース | 見るもの |
|---|---|
| [WebAssembly/proposals](https://github.com/WebAssembly/proposals) | proposalのフェーズ(Phase 0〜5)変化 |
| [WebAssembly/meetings](https://github.com/WebAssembly/meetings) | CG/WG・subgroup議事録(投票結果を優先) |
| [WebAssembly/website](https://github.com/WebAssembly/website) | features.json(エンジン実装状況) |
| [WebAssembly/WASI](https://github.com/WebAssembly/WASI) | リリース、roadmap |
| [WebAssembly/component-model](https://github.com/WebAssembly/component-model) | コミット、リリース |
| [webassembly.org/news](https://webassembly.org/news/) | 公式ニュース |

## 週次更新の仕組み

1. `state/watch-state.json` に記録された前回SHAから、`gh api` で各リポジトリの差分を収集
2. フェーズ変化・議事録の投票結果などを該当するwikiページへ反映
3. `wiki/newsletter/YYYY-Wnn.md` を生成し、index / log / state を更新してコミット

- **ローカル実行**: Claude Codeで `/weekly-update`
- **自動実行**: GitHub Actionsが毎週日曜21:00 JSTに実行(`workflow_dispatch` で手動トリガーも可)
- **サイト反映**: mainに `wiki/` の変更がpushされると `deploy-site` ワークフローがQuartzでビルドしてGitHub Pagesへ自動デプロイする([#1](https://github.com/zaki-yama/webassembly-llm-wiki/issues/1) で導入)

### サイトのローカルプレビュー

Quartz本体はこのリポジトリに含めず、ビルド時に取得する構成(CIも同じ)。ローカルで確認するには:

```sh
./site/preview.sh   # 初回はQuartzのclone+npm ciが走る。以降は http://localhost:8080 ですぐ見られる
```

### 認証

GitHub Actionsからの認証は **Claude Proプランのサブスクリプション枠**(OAuthトークン)で行う。

- ローカルで `claude setup-token` を実行し、`gh secret set CLAUDE_CODE_OAUTH_TOKEN` で登録する(トークン失効時も同じ手順で更新)
- 週次実行の利用量は普段のClaude Code利用と同じプラン枠から消費される

代替として **Workload Identity Federation**(APIクレジット課金、Secret不要)も設定済み。Claude Console(`Settings → Workload identity`)にこのリポジトリのmainブランチのみを許可するfederation ruleがあり、ワークフローの `claude_code_oauth_token` をWIF inputs(`anthropic_federation_rule_id` 等、git履歴参照)+ `permissions: id-token: write` に置き換えれば切り替えられる。疎通確認は `anthropic-wif-test` ワークフローを手動実行する。
