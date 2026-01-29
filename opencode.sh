#!/bin/bash
# Opencode 启动脚本 - 自动加载 .env 环境变量

cd "$(dirname "$0")"

# 查找 opencode 命令的绝对路径
OPENCODE_BIN="$(which opencode)"

if [ -z "$OPENCODE_BIN" ]; then
  echo "Error: opencode command not found. Please install it globally or check your PATH."
  exit 1
fi

# 使用 node 的 -r 参数加载 dotenv/config
node -r dotenv/config "$OPENCODE_BIN" "$@"