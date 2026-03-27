#!/bin/bash
# Sensitive Guard FUSE 方案安装脚本

set -e

echo "🔒 Sensitive Guard FUSE 方案安装"
echo ""

# 检查 macFUSE
if ! command -v mount_macfuse &> /dev/null; then
    echo "📦 安装 macFUSE..."
    brew install --cask macfuse

    echo ""
    echo "⚠️  重要提示："
    echo "1. 打开 系统偏好设置 → 安全性与隐私"
    echo "2. 点击 允许 macFUSE"
    echo "3. 重启 Mac"
    echo ""
    echo "重启后重新运行此脚本"
    exit 0
fi

echo "✅ macFUSE 已安装"

# 创建虚拟环境
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VENV_DIR="$SCRIPT_DIR/venv"

if [ ! -d "$VENV_DIR" ]; then
    echo "📦 创建 Python 虚拟环境..."
    python3 -m venv "$VENV_DIR"
fi

# 安装依赖
echo "📦 安装 Python 依赖..."
source "$VENV_DIR/bin/activate"
pip install -q fusepy

echo ""
echo "✅ 安装完成！"
echo ""
echo "使用方法："
echo "  bash fuse/start.sh  - 启动 FUSE"
echo ""
