# Sensitive Guard

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Shell](https://img.shields.io/badge/Shell-Bash-green.svg)](https://www.gnu.org/software/bash/)
[![Platform](https://img.shields.io/badge/Platform-macOS%20%7C%20Linux-blue.svg)](https://github.com/yourusername/sensitive-guard)

🔒 自动检测并脱敏配置文件中的敏感信息（API Key、Token、密码等）

专为技术演示、截图分享、文档编写场景设计。

## ✨ 特性

- 🚀 **零依赖** - 纯 Shell 实现，无需安装额外组件
- ⚡ **即装即用** - 无需重启，无需系统权限
- 🔍 **智能识别** - 自动检测 50+ 种敏感字段
- 🎯 **保留可读性** - 保留前后 4 个字符便于识别
- 🔧 **可扩展** - 支持自定义字段配置
- 📋 **多格式支持** - JSON、ENV、YAML 等

## 🚀 快速开始

### 一键安装

```bash
curl -fsSL https://raw.githubusercontent.com/yourusername/sensitive-guard/main/install.sh | bash
source ~/.zshrc
```

### 使用

```bash
# 查看配置文件（自动脱敏）
cat ~/.openclaw/openclaw.json
cat ~/.env

# 查看真实内容
command cat ~/.env
```

## 📸 效果演示

**原始内容：**
```bash
ANTHROPIC_API_KEY=sk-ant1234567890abcdefghijklmnopqrstuvwxyz1234567890ABCD
WECHAT_SECRET=a1b2c3d4e5f6g7h8i9j0k1l2m3n4o5p6
```

**脱敏后：**
```bash
ANTHROPIC_API_KEY=sk-a************************************ABCD
WECHAT_SECRET=a1b2************o5p6
```

## 📦 支持的敏感字段

### 自动识别

**API Keys:**
- `API_KEY`, `APIKEY`, `api_key`
- `ANTHROPIC_API_KEY`, `OPENAI_API_KEY`
- `LIONCC_API_KEY`, `GEMINI_API_KEY`

**Tokens:**
- `TOKEN`, `ACCESS_TOKEN`, `REFRESH_TOKEN`
- `BOT_TOKEN`, `botToken`

**App 凭证:**
- `APP_ID`, `APPID`, `app_id`
- `APP_SECRET`, `APPSECRET`
- `WECHAT_APPID`, `WECHAT_SECRET`

**密码/密钥:**
- `password`, `passwd`, `pwd`
- `secret`, `secretKey`, `SECRET`

### 自定义字段

```bash
# 编辑配置文件
vim ~/.sensitive-guard/config/custom-fields.conf

# 添加自定义字段
DATABASE_PASSWORD
STRIPE_SECRET_KEY
```

详见：[自定义字段配置指南](docs/CUSTOM-FIELDS.md)

---

## 📚 文档

- [使用指南](docs/USAGE.md)
- [自定义字段](docs/CUSTOM-FIELDS.md)
- [方案对比](docs/COMPARISON.md)
- [项目总览](docs/PROJECT-OVERVIEW.md)

---

## 💎 赞助商

本项目由 [LionCC API](https://lioncc.ai) 提供支持

LionCC API 提供稳定、高性价比的 AI 模型 API 服务，支持 Claude、GPT-4、Gemini 等主流模型。

---

## 🔧 卸载

```bash
bash uninstall.sh
```

---

## 🤝 贡献

欢迎提交 Issue 和 Pull Request！

---

## 📄 License

[MIT License](LICENSE)

---

## ⭐ Star History

如果这个项目对你有帮助，请给个 Star ⭐
