#!/usr/bin/env bash
# wikiをQuartzでローカルプレビューする(http://localhost:8080)。
# Quartz本体はリポジトリに含めず、キャッシュディレクトリにcloneして使う。
# CIと同じ構成: deploy-site.yml と同じQUARTZ_REFを使うこと(変更時は両方更新)。
#
# 使い方:
#   ./site/preview.sh          # ビルドして開発サーバー起動
#   ./site/preview.sh --build  # ビルドのみ(出力先を表示して終了)
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
QUARTZ_REF=9cf87ff1c248a8ca551093214b0fec3b31415009 # deploy-site.yml のQUARTZ_REFと揃える
CACHE_DIR="${QUARTZ_CACHE_DIR:-$HOME/.cache/webassembly-llm-wiki-quartz}"

if [ ! -d "$CACHE_DIR/.git" ]; then
  echo "Quartzを $CACHE_DIR にcloneします..."
  git clone --filter=blob:none https://github.com/jackyzha0/quartz.git "$CACHE_DIR"
fi
git -C "$CACHE_DIR" fetch -q origin "$QUARTZ_REF"
git -C "$CACHE_DIR" checkout -q "$QUARTZ_REF"

cp "$REPO_ROOT/site/quartz.config.yaml" "$CACHE_DIR/quartz.config.yaml"
rm -rf "$CACHE_DIR/content"
mkdir "$CACHE_DIR/content"
cp -R "$REPO_ROOT/wiki/." "$CACHE_DIR/content/"
find "$CACHE_DIR/content" -name .gitkeep -delete

cd "$CACHE_DIR"
if [ ! -d node_modules ]; then
  npm ci
fi
npx quartz plugin install

if [ "${1:-}" = "--build" ]; then
  npx quartz build
  echo "ビルド完了: $CACHE_DIR/public"
else
  npx quartz build --serve
fi
