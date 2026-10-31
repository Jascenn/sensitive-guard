# 贡献指南

感谢你对 Sensitive Guard 的关注。

## 报告问题

- 先检查 [Issues](https://github.com/Jascenn/sensitive-guard/issues) 是否已有相同问题。
- 使用仓库中的 Issue 模板提交复现步骤、系统和 Shell 版本。
- 日志、截图和示例配置必须脱敏，不要提交真实密钥。
- 安全问题请按照 [SECURITY.md](SECURITY.md) 私下报告。

## 提交代码

1. Fork 本仓库。
2. 从 `main` 创建短分支，例如 `fix/redact-bearer-token`。
3. 使用 Conventional Commits，例如 `fix: redact bearer tokens`。
4. 推送分支并创建 Pull Request。

## 本地检查

提交前至少运行：

```bash
find . -type f -name '*.sh' -print0 |
  while IFS= read -r -d '' file; do bash -n "$file"; done
python3 -m py_compile fuse/sensitive_fs.py
git diff --check
```

不要提交 `__pycache__`、本地配置、测试输出或真实凭证。

## Pull Request

请说明改动动机、影响范围、验证证据和回滚方式。每个 PR 尽量只解决一个问题。
