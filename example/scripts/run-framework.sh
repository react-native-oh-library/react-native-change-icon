#!/usr/bin/env bash
# 指定 RN 框架版本后安装依赖并运行 example。
# 用法: npm run run:harmony -- 0.72|0.77|0.82|0.84|0.86
set -euo pipefail

EXAMPLE="$(cd "$(dirname "$0")/.." && pwd)"
cd "$EXAMPLE"

VERSION="${1:-}"
if [[ "$VERSION" == "--" ]]; then
  VERSION="${2:-}"
fi
case "$VERSION" in
  0.72|0.77|0.82|0.84|0.86) ;;
  *)
    echo "用法: npm run run:harmony -- 0.72|0.77|0.82|0.84|0.86"
    exit 1
    ;;
esac

echo "==> 切换框架 $VERSION"
node ./scripts/use-framework.js "$VERSION"

echo "==> npm install"
npm install --legacy-peer-deps
node ./scripts/use-framework.js "$VERSION" --sync-har

if command -v ohpm >/dev/null 2>&1; then
  OHPM="ohpm"
elif [[ -x "/Applications/DevEco-Studio.app/Contents/tools/ohpm/bin/ohpm" ]]; then
  OHPM="/Applications/DevEco-Studio.app/Contents/tools/ohpm/bin/ohpm"
else
  echo "找不到 ohpm"
  exit 1
fi

echo "==> ohpm install"
rm -rf harmony/oh_modules harmony/entry/oh_modules harmony/.ohpm
(cd harmony && "$OHPM" install)

LIB="$(cd "$EXAMPLE/.." && pwd)"
SKILL="${RN_RUN_HARMONY_EXAMPLE:-$HOME/.cursor/skills/rn-run-harmony-example/scripts/run-example.sh}"
echo "==> 运行 example"
bash "$SKILL" --lib-path "$LIB"
