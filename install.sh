#!/bin/bash
# Sensitive Guard 安装脚本

set -e

INSTALL_DIR="$HOME/.sensitive-guard"
REPO_URL="https://github.com/yourusername/sensitive-guard"

echo "🔒 Sensitive Guard 安装程序"
echo ""

# 检测操作系统
detect_os() {
  case "$(uname -s)" in
    Darwin*) echo "macos" ;;
    Linux*)  echo "linux" ;;
    *)       echo "unknown" ;;
  esac
}

OS=$(detect_os)
echo "📍 检测到系统: $OS"

# 检查依赖
check_dependencies() {
  echo "🔍 检查系统依赖..."
  local missing=()

  if ! command -v sed &> /dev/null; then
    missing+=("sed")
  else
    echo "  ✓ sed"
  fi

  if ! command -v grep &> /dev/null; then
    missing+=("grep")
  else
    echo "  ✓ grep"
  fi

  if [ ${#missing[@]} -gt 0 ]; then
    echo "❌ 缺少依赖: ${missing[*]}"
    exit 1
  fi

  echo "✅ 所有依赖已满足"
}

check_dependencies

# 安装
echo ""
echo "📦 开始安装..."
echo ""

# 创建安装目录
echo "1️⃣ 创建目录结构..."
mkdir -p "$INSTALL_DIR"/{bin,lib,config}
echo "  ✓ ~/.sensitive-guard/bin"
echo "  ✓ ~/.sensitive-guard/lib"
echo "  ✓ ~/.sensitive-guard/config"

# 复制文件
echo ""
echo "2️⃣ 安装核心文件..."
cp -r bin/* "$INSTALL_DIR/bin/"
echo "  ✓ scat (安全 cat 命令)"
echo "  ✓ sless (安全 less 命令)"
echo "  ✓ sgrep (安全 grep 命令)"

cp -r lib/* "$INSTALL_DIR/lib/"
echo "  ✓ core.sh (脱敏引擎)"

# 复制配置文件
if [ -f "config/shell-functions.sh" ]; then
  cp config/shell-functions.sh "$INSTALL_DIR/config/"
  echo "  ✓ shell-functions.sh (命令包装)"
fi

if [ -f "config/custom-fields.conf" ]; then
  cp config/custom-fields.conf "$INSTALL_DIR/config/"
  echo "  ✓ custom-fields.conf (自定义字段)"
fi

# 添加到 PATH
echo ""
echo "3️⃣ 配置 Shell 环境..."
SHELL_RC="$HOME/.zshrc"
if [ -f "$HOME/.bashrc" ]; then
  SHELL_RC="$HOME/.bashrc"
fi

if ! grep -q "sensitive-guard" "$SHELL_RC"; then
  echo "" >> "$SHELL_RC"
  echo "# Sensitive Guard" >> "$SHELL_RC"
  echo 'export PATH="$HOME/.sensitive-guard/bin:$PATH"' >> "$SHELL_RC"
  echo 'source "$HOME/.sensitive-guard/config/shell-functions.sh"' >> "$SHELL_RC"
  echo "  ✓ 已添加到 $SHELL_RC"
fi

echo ""
echo "✅ 安装完成！"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📖 使用方法"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "1️⃣ 重新加载 Shell："
echo "   source $SHELL_RC"
echo ""
echo "2️⃣ 查看配置文件（自动脱敏）："
echo "   cat ~/.env"
echo "   less config.json"
echo "   grep API_KEY .env"
echo ""
echo "3️⃣ 查看真实内容："
echo "   command cat ~/.env"
echo ""
echo "💡 提示：cat/less/grep 命令已自动包装，无需使用 scat"
echo ""

