# Sensitive Guard 使用指南

## 工作原理

Sensitive Guard 通过 Shell 函数包装常用命令，在读取文件时自动应用脱敏规则。

```
原文件（不变） → cat 命令拦截 → 实时脱敏 → 显示到终端
```

**关键特性：**
- 原文件永远不被修改
- 纯内存操作，不生成临时文件
- 对应用程序完全透明

## 命令说明

### 已包装的命令

| 命令 | 说明 | 脱敏 |
|------|------|------|
| `cat` | 查看文件 | ✅ |
| `less` | 分页查看 | ✅ |
| `grep` | 搜索内容 | ✅ |

### 查看真实内容

如果需要查看未脱敏的原始内容：

```bash
# 方法 1：使用 command 绕过函数
command cat ~/.openclaw/openclaw.json

# 方法 2：使用反斜杠
\cat ~/.openclaw/openclaw.json
```

## 演示场景

### 场景 1：终端演示配置

```bash
# 直接查看，自动脱敏
cat ~/.openclaw/openclaw.json

# 搜索敏感字段，结果自动脱敏
grep "apiKey" ~/.openclaw/openclaw.json
```

### 场景 2：截图分享

```bash
# 查看配置并截图，敏感信息已打码
less ~/.openclaw/openclaw.json
```

### 场景 3：日志查看

```bash
# 查看包含敏感信息的日志
cat ~/.openclaw/app.log | grep token
```

## 编辑配置文件

### GUI 编辑器（VSCode/Cursor）

GUI 编辑器不受 Shell 函数影响，会显示真实内容。

**推荐流程：**
1. 正常用编辑器打开文件
2. 编辑并保存
3. 演示时用终端命令查看（自动脱敏）

### 终端编辑器（vim/nano）

终端编辑器会受 Shell 函数影响。

**解决方案：**
```bash
# 使用 command 绕过脱敏
command vim ~/.openclaw/openclaw.json
```

## 支持的文件格式

### JSON 格式
```json
{
  "apiKey": "sk-xxx",
  "token": "xxx"
}
```

### ENV 格式
```bash
API_KEY=sk-xxx
APP_SECRET=xxx
```

### YAML 格式
```yaml
apiKey: sk-xxx
token: xxx
```

## 故障排除

### 问题 1：脱敏不生效

**检查函数是否加载：**
```bash
type cat
# 应该显示：cat is a function
```

**解决方案：**
```bash
source ~/.zshrc
```

### 问题 2：某些字段未脱敏

检查字段名是否在支持列表中。如需添加新规则，编辑：
```bash
vim ~/.sensitive-guard/lib/core.sh
```

### 问题 3：编辑器显示脱敏内容

GUI 编辑器（VSCode/Cursor）不受影响，会显示真实内容。
终端编辑器需要用 `command vim` 绕过。
