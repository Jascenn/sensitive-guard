#!/bin/bash
# Sensitive Guard FUSE 启动脚本

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VENV_DIR="$SCRIPT_DIR/../venv"
MOUNT_POINT="$HOME/demo"
ROOT_DIR="$HOME"

# 检查 macFUSE
if ! command -v mount_macfuse &> /dev/null; then
    echo "❌ macFUSE 未安装"
    echo "安装: brew install --cask macfuse"
    exit 1
fi

# 激活虚拟环境
source "$VENV_DIR/bin/activate"

# 创建挂载点
mkdir -p "$MOUNT_POINT"

# 启动 FUSE
echo "🚀 启动 Sensitive Guard FUSE..."
echo "📂 挂载点: $MOUNT_POINT"
echo "💡 使用 Ctrl+C 停止"

python3 "$SCRIPT_DIR/sensitive_fs.py" "$ROOT_DIR" "$MOUNT_POINT"
