# Sensitive Guard - 项目总览

## 项目简介

Sensitive Guard 是一个自动检测并脱敏配置文件中敏感信息的工具，专为技术演示场景设计。

## 核心功能

- 🔍 自动检测敏感字段（API Key、Token、密码等）
- 🔒 实时脱敏显示（保留前后 4 个字符）
- 📋 支持多种文件格式（JSON、ENV、YAML）
- 🎯 原文件不被修改，纯内存操作

## 项目结构

```
sensitive-guard/
├── bin/                    # 可执行命令
│   ├── scat               # 安全 cat 命令
│   ├── sless              # 安全 less 命令
│   └── sgrep              # 安全 grep 命令
├── lib/                    # 核心库
│   └── core.sh            # 脱敏引擎
├── config/                 # 配置文件
│   └── shell-functions.sh # Shell 函数包装
├── fuse/                   # FUSE 方案（可选）
│   ├── sensitive_fs.py    # FUSE 文件系统
│   └── start.sh           # 启动脚本
├── docs/                   # 文档
│   ├── COMPARISON.md      # 方案对比
│   ├── USAGE.md           # 使用指南
│   └── FUSE-COST-ANALYSIS.md  # 成本分析
├── install.sh             # Shell 方案安装
├── install-fuse.sh        # FUSE 方案安装
└── README.md              # 项目说明
```

## 两种方案

### 方案 A：Shell Hook（推荐）

**特点：**
- 零依赖，纯 Shell 实现
- 即装即用，无需重启
- 覆盖终端命令

**安装：**
```bash
bash install.sh
source ~/.zshrc
```

### 方案 B：FUSE（全覆盖）

**特点：**
- 全局覆盖（终端 + GUI）
- 需要 macFUSE
- 首次安装需重启

**安装：**
```bash
bash install-fuse.sh
bash fuse/start.sh
```

详细对比见：[docs/COMPARISON.md](COMPARISON.md)

---

## 快速开始

### 1. 安装（Shell 方案）

```bash
cd ~/Development/sensitive-guard
bash install.sh
source ~/.zshrc
```

### 2. 测试

```bash
cat ~/.openclaw/openclaw.json
# 敏感信息自动打码
```

### 3. 查看真实内容

```bash
command cat ~/.openclaw/openclaw.json
```

---

## 支持的敏感字段

- API: apiKey, api_key, API_KEY, APIKEY
- App: appId, appSecret, APP_ID, APP_SECRET
- Token: token, botToken, accessToken, refreshToken
- 密码: password, passwd, pwd, secret, secretKey

---

## 文档索引

- [使用指南](USAGE.md)
- [方案对比](COMPARISON.md)
- [成本分析](FUSE-COST-ANALYSIS.md)
