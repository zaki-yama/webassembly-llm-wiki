# proposalページ深掘り(deepen)計画

## Context

ユーザーレビューで「`wiki/proposals/` の情報が薄く、proposalリポジトリを直接見ないと内容がわからない。これではAIエージェントへの質問にも答えられない」という指摘を受けた。

原因: 初期ベースライン構築時、proposals一覧のREADME(各proposal 1行)+LLMの事前知識だけからページを作り、**各proposalリポジトリの一次情報(Explainer等)をingestしていなかった**。llm-wikiの思想(一次情報を読んで知識を蓄積し、質問はwikiだけで答えられる状態にする)に達していない。

さらに根本原因として、「個々のproposalリポジトリを参照する」という行動がCLAUDE.md/スキルのどこにも規定されていなかった。**LLMの行動はスキーマが規定する**ので、規約と手順書の整備を含めて対処する。

サンプルとして [[stack-switching]] をExplainer(約1,200行)から書き直し、深さ・分量はユーザー承認済み(「一言でいうと / Motivation / 仕組み(命令表) / WATコード例 / 経緯と現状 / 関連 / 一次情報」構成、約100行)。

## 検討結果1: 情報源は raw/ に残すか、gh apiオンデマンド取得を続けるか

**結論: オンデマンド取得(現行)を継続。raw/ にリポジトリは置かない。**

| 観点 | オンデマンド取得 | raw/にclone/submodule |
|---|---|---|
| 鮮度 | 常に最新 | 同期作業が新たな運用負担 |
| サイズ | wikiだけで軽量 | meetingsリポジトリ等は巨大で肥大が止まらない |
| 差分検出 | compare APIが用途に直結 | pull→diff→コミットのサイクルが増える |
| 再現性 | watch-state.jsonのSHA + SHA付きpermalinkで担保 | スナップショット保持が唯一の優位点 |

判断理由:
- ウォッチ対象はW3C/WebAssembly組織配下の公開gitリポジトリで、消失リスクが極めて低く、それ自体がバージョン管理されている。こちらで複製を持つ意味がほぼない
- llm-wiki.mdにおける raw/ の本来の役割は「人間が持ち込む、消えるかもしれないソースの不変アーカイブ」(クリップ記事・PDF等)。公開リポジトリはこれに該当しない
- アーカイブすべきは「ソースの複製」ではなく「**抽出した知識(wikiページ)+SHA付きの出典リンク**」
- 大量に読む一括作業(今回のdeepen等)は、scratchpadへの一時shallow cloneで取得を最適化する(リポジトリには残さない)

なお、比較対象の tc39-llm-wiki は raw/ をsubmoduleで持つが、これは「歴史コーパス334ファイルを何度もgrepしながら段階的に精読する」ワークロードでの正当な別解(submoduleポインタ=wikiが反映した素材時点の記録)。本プロジェクトは「毎週の差分を読む」定点観測型なので前提が異なる。

## 検討結果2: tc39-llm-wiki との比較と採用点

比較対象: https://github.com/Jxck/tc39-llm-wiki (AGENTS.md)。同じ llm-wiki.md 発の先行事例だが、**アーカイブ精読型**(逐語録2012〜2026を段階精読する歴史wiki)であり、本プロジェクトの**定点観測型**(週次差分+ニュースレター)とはワークロードが異なる。

| 観点 | tc39-llm-wiki | 本プロジェクト |
|---|---|---|
| raw/ | submodule(grepが作業基盤) | 持たない(上記のとおり) |
| 機械抽出層 | tools/のPythonスクリプト+_generated/(議題索引・人物ページ・ステージ一覧) | なし(LLMが維持) |
| リンク | 標準Markdown相対リンク(VSCodeプレビュー対応を優先) | Obsidian wikilink(Quartz/Obsidianネイティブ) |
| Query還元 | ユーザ確認後にfile back | LLM判断で還元 |

### 採用することにした点

1. **ソース優先順位(precedence)の明文化**: フェーズの確定値=proposalsリポジトリが一次 / 経緯・投票=議事録が一次 / エンジン実装状況=features.jsonが一次。食い違ったら読み取りを疑い両者を辿り直す。CLAUDE.mdに追加
2. **フェーズ遷移テーブルをproposalページの必須セクションに**: 「いつ・どの会合で・何が起きてフェーズが動いたか」の時系列テーブル(議事録へのSHA付きリンク)。proposals READMEのgit履歴から遷移時期を再構成する。mermaid推移グラフは任意(Quartzはmermaid対応)
3. **families(横断ページ)**: 並行処理系・JS連携系など複数proposalを束ねるsynthesisページ。frontmatterで双方向メンバーシップ(`families:` ⇔ `members:`)。個別の経緯はproposalページに置き、familyには複製しない
4. **精読済み/未精読の明示**: index.mdでdeepen済みページを区別し、段階的作業の進捗を可視化
5. **コミット規約の拡張**: `deepen:` / `lint:` プレフィックスを追加
6. **手順の正本一元化**: 「手順の正本はスキル(SKILL.md)、CLAUDE.mdは規約とポインタ」と明記し二重管理を防ぐ(彼らの「コマンドはポインタ、AGENTS.mdが正本」の逆向き適用)

### 見送った点(理由つき)

- **tools/による機械抽出**: 21proposalの規模ではLLM維持で足りる。100超で再検討
- **人物ページ**: Wasmはchampion数が少なく、略号文化もない
- **フォーマッタ(oxfmt)+hooks**: 効果が薄い
- **標準Markdownリンクへの変更**: Quartz採用済みのためwikilink継続
- **Query還元前のユーザ確認**: 現行の「LLM判断で還元」を維持

## 実施内容

### Step 1: 規約整備(コミット1つ)

- **CLAUDE.md**:
  - 情報源表に「各proposalのリポジトリ(ページfrontmatterの `repo:`)」行を追加
  - precedence節を追加
  - proposalページのテンプレート規約(必須セクション: 一言でいうと / なぜ必要か / 仕組み / 例 / フェーズ遷移 / 経緯と現状 / 関連 / 一次情報)
  - 「proposalページの新規作成・大幅更新時は `repo:` のExplainer(→Overview→READMEの優先順)を必ず読む」「引用はSHA付きpermalink」の行動ルール
  - familiesページ規約(双方向メンバーシップ)
  - コミット規約に `deepen:` / `lint:` を追加
  - 「手順の正本はスキル」の一元化ルール
- **`.claude/skills/deepen-proposal/SKILL.md`** を新設: 1proposalを深掘りする再現可能な手順(explainer探索→読む→テンプレで書く→フェーズ遷移をREADME履歴から再構成→index/log更新)
- **`.claude/skills/weekly-update/SKILL.md`**: 新規proposal検出・フェーズ移行時に該当リポジトリをdeepen水準でingestするステップ、proposal_repos差分チェックを追加

### Step 2: 既存21ページのdeepen(Phase単位でコミット)

優先順: Phase 4(3ページ)→ Phase 3(5ページ、stack-switching済み)→ Phase 2(7ページ)→ 注目Phase 1(4ページ)。
各ページで: リポジトリのExplainer/Overview/READMEをingest → テンプレ構成で書き直し → フェーズ遷移テーブルをproposals READMEのgit履歴+議事録から再構成。

### Step 3: families作成とstate拡張(コミット1つ)

- `wiki/families/` に横断ページを作成(想定: concurrency / js-interop / gc-lang-support / binary-size あたり。deepenの過程で確定)
- `state/watch-state.json` に `proposal_repos`(各proposalリポジトリのSHA)を追加し、weekly-updateで週次差分チェック(21リポジトリ×compare 1回で軽量)。Explainerの設計変更もwikiに自動反映される
- `index.md` に精読状態を反映

## 検証方法

1. deepen済みページだけを見て「このproposalは何を解決し、どう動き、今どこにいるか」に答えられること(リポジトリを見に行かずに)
2. `/deepen-proposal <slug>` を任意の1ページに実行し、手順書だけで同品質のページができること
3. Quartzローカルビルド(`./site/preview.sh --build`)でリンク切れゼロを確認(mainマージ後、Quartz PRと合流した状態で)
