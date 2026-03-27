# 测试环境使用指南

## 快速开始

### 1. 启动测试容器

```bash
cd ~/Development/sensitive-guard
docker run -it --rm -v $(pwd):/test ubuntu:22.04 bash
```

### 2. 在容器内安装

```bash
cd /test
bash install.sh
source ~/.bashrc
```

### 3. 测试脱敏效果

```bash
# 测试 ENV 文件
cat test/.env.example

# 测试 JSON 文件
cat test/config.example.json
```

### 4. 查看真实内容对比

```bash
# 脱敏版本
cat test/.env.example

# 真实内容
command cat test/.env.example
```

### 5. 退出容器

```bash
exit
```

容器会自动删除，不留痕迹。
