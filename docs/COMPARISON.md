# Sensitive Guard - 方案对比

## 方案 A：Shell Hook 方案（轻量级）

### 架构
```
原文件 → Shell 函数拦截 → 脱敏 → 终端显示
```

### 安装步骤
```bash
cd ~/Development/sensitive-guard
bash install.sh
source ~/.zshrc
```

### 安装成本
- **大小**: < 1 MB
- **耗时**: < 10 秒
- **依赖**: 无
- **权限**: 无需特殊权限
- **重启**: 不需要

### 覆盖范围
- ✅ 终端命令（cat/less/grep）
- ❌ GUI 编辑器（VSCode/Cursor）
- ❌ 其他应用程序

### 优点
- 零依赖，纯 Shell 实现
- 即装即用，无需重启
- 维护简单，代码量小
- 不影响系统稳定性

### 缺点
- 只覆盖终端场景
- GUI 工具需手动开关
- 需要记住绕过方法（command/\）

---

## 方案 B：FUSE 方案（全覆盖）

### 架构
```
原文件 → FUSE 虚拟层 → 脱敏 → 所有程序
```

### 安装步骤
```bash
# 1. 安装 macFUSE
brew install --cask macfuse
# 需要：系统偏好设置 → 允许 → 重启 Mac

# 2. 安装 Sensitive Guard
cd ~/Development/sensitive-guard
bash install-fuse.sh

# 3. 启动 FUSE
bash fuse/start.sh
```

### 安装成本
- **大小**: ~28 MB（macFUSE 14MB + Python 13MB + 本体 1MB）
- **耗时**: 1-2 分钟（不含重启）
- **依赖**: macFUSE + Python
- **权限**: 需要系统扩展权限
- **重启**: 首次安装必须重启

### 覆盖范围
- ✅ 终端命令
- ✅ GUI 编辑器（VSCode/Cursor）
- ✅ 所有应用程序

### 优点
- 全局覆盖，所有程序生效
- 用户无感知，自动脱敏
- 支持实时切换脱敏模式

### 缺点
- 安装复杂，需要重启
- 依赖外部组件
- 维护成本高
- 可能影响系统稳定性

---

## 使用场景对比

### 场景 1：终端演示

**Shell 方案:**
```bash
cat ~/.openclaw/openclaw.json  # ✅ 自动脱敏
```

**FUSE 方案:**
```bash
cat ~/demo/.openclaw/openclaw.json  # ✅ 自动脱敏
```

**结论**: 两者效果一样

---

### 场景 2：VSCode 打开配置

**Shell 方案:**
```bash
# ❌ 显示真实内容，需手动切换
demo-mode on  # 替换文件
code ~/.openclaw/openclaw.json
```

**FUSE 方案:**
```bash
# ✅ 自动脱敏
code ~/demo/.openclaw/openclaw.json
```

**结论**: FUSE 更好

---

### 场景 3：编辑并保存

**Shell 方案:**
```bash
demo-mode off  # 恢复真实文件
vim ~/.openclaw/openclaw.json  # 正常编辑
```

**FUSE 方案:**
```bash
vim ~/demo/.openclaw/openclaw.json
# 看到脱敏内容，保存时自动写入真实文件
```

**结论**: FUSE 更智能

---

## 推荐选择

### 选择 Shell 方案（方案 A）如果：
- ✅ 主要在终端演示
- ✅ 希望零依赖、即装即用
- ✅ 不想重启 Mac
- ✅ 追求简单稳定

### 选择 FUSE 方案（方案 B）如果：
- ✅ 经常用 GUI 工具演示
- ✅ 需要全局覆盖
- ✅ 可以接受安装复杂度
- ✅ 已经安装了 macFUSE

---

## 混合使用

**最佳实践：**
1. 默认使用 Shell 方案（日常使用）
2. 重要演示前安装 FUSE 方案（全覆盖）
3. 演示结束后卸载 FUSE（保持系统干净）
