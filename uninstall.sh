#!/bin/bash
# Sensitive Guard 卸载脚本

set -e

echo "🗑️  Sensitive Guard 卸载程序"
echo ""

# 确认卸载
read -p "确定要卸载 Sensitive Guard 吗？(y/N) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "已取消卸载"
    exit 0
fi

# 删除安装目录
if [ -d "$HOME/.sensitive-guard" ]; then
    echo "📦 删除安装目录..."
    rm -rf "$HOME/.sensitive-guard"
    echo "✓ 已删除 ~/.sensitive-guard"
fi

# 清理 .zshrc
if [ -f "$HOME/.zshrc" ]; then
    echo "📝 清理 .zshrc..."
    sed -i.bak '/# Sensitive Guard/d' "$HOME/.zshrc"
    sed -i.bak '/sensitive-guard/d' "$HOME/.zshrc"
    echo "✓ 已清理 .zshrc"
fi

# 清理 .bashrc
if [ -f "$HOME/.bashrc" ]; then
    echo "📝 清理 .bashrc..."
    sed -i.bak '/# Sensitive Guard/d' "$HOME/.bashrc"
    sed -i.bak '/sensitive-guard/d' "$HOME/.bashrc"
    echo "✓ 已清理 .bashrc"
fi

echo ""
echo "✅ 卸载完成！"
echo ""
echo "💡 重新加载 shell: source ~/.zshrc"
