# 常见问题 FAQ

## 安装相关

### Q: 支持哪些操作系统？
**A:** 支持 macOS 和 Linux。Windows 用户可以使用 WSL。

### Q: 需要 root 权限吗？
**A:** 不需要。所有文件安装在用户目录 `~/.sensitive-guard`。

### Q: 安装后需要重启吗？
**A:** 不需要重启系统，只需重新加载 shell：`source ~/.zshrc`

---

## 使用相关

### Q: 为什么脱敏不生效？
**A:** 检查以下几点：
1. 确认已重新加载配置：`source ~/.zshrc`
2. 检查函数是否加载：`type cat`（应显示 "cat is a function"）
3. 测试 scat 命令：`~/.sensitive-guard/bin/scat your-file`

### Q: 如何查看真实内容？
**A:** 使用以下方法绕过脱敏：
```bash
command cat file.env
\cat file.env
```

### Q: GUI 编辑器（VSCode/Cursor）会脱敏吗？
**A:** 不会。Shell 方案只影响终端命令。GUI 编辑器显示真实内容。

### Q: 某些字段没有脱敏怎么办？
**A:** 
1. 检查字段是否在支持列表中
2. 如果不在，添加到自定义配置：
```bash
vim ~/.sensitive-guard/config/custom-fields.conf
# 添加字段名
YOUR_CUSTOM_FIELD
```
3. 重新加载：`source ~/.zshrc`

### Q: 会修改原文件吗？
**A:** 不会。脱敏是纯内存操作，原文件保持不变。

---

## 性能相关

### Q: 会影响命令执行速度吗？
**A:** 影响极小。只有包含敏感字段的文件才会脱敏处理。

### Q: 大文件会卡顿吗？
**A:** 对于超大文件（>10MB），建议使用 `command cat` 查看原始内容。

---

## 兼容性

### Q: 与其他 Shell 工具冲突吗？
**A:** 不会。如果有冲突，可以临时禁用：
```bash
unset -f cat less grep
```

### Q: 支持 Bash 吗？
**A:** 支持。安装时会自动配置 .bashrc 或 .zshrc。

---

## 其他

### Q: 如何卸载？
**A:** 
```bash
bash uninstall.sh
```

### Q: 如何更新？
**A:** 
```bash
cd ~/Development/sensitive-guard
git pull
bash install.sh
```
