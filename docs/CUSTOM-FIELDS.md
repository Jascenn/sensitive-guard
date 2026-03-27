# 自定义字段配置指南

## 快速开始

### 1. 打开配置文件

```bash
vim ~/.sensitive-guard/config/custom-fields.conf
```

### 2. 添加自定义字段

在文件末尾添加你的字段名，每行一个：

```bash
# 示例：添加数据库密码字段
DATABASE_PASSWORD
DB_PASSWORD

# 示例：添加自定义 API Key
MY_CUSTOM_API_KEY
STRIPE_SECRET_KEY
```

### 3. 重新加载配置

```bash
source ~/.zshrc
```

### 4. 测试

```bash
cat your-config-file
# 自定义字段会自动脱敏
```

---

## 配置规则

### 支持的格式

**ENV 格式：**
```bash
MY_CUSTOM_API_KEY=abc1234567890xyz
```

**脱敏后：**
```bash
MY_CUSTOM_API_KEY=abc1************xyz
```

### 字段命名规范

- 支持大写字母、数字、下划线
- 建议使用全大写（ENV 文件惯例）
- 示例：`MY_API_KEY`、`DATABASE_PASSWORD`、`STRIPE_KEY`

---

## 常见场景

### 场景 1：添加数据库凭证

```bash
# 编辑配置文件
vim ~/.sensitive-guard/config/custom-fields.conf

# 添加以下字段
DATABASE_URL
MYSQL_PASSWORD
POSTGRES_PASSWORD
REDIS_PASSWORD
```

### 场景 2：添加第三方服务 Key

```bash
# 添加以下字段
STRIPE_SECRET_KEY
STRIPE_PUBLISHABLE_KEY
TWILIO_AUTH_TOKEN
SENDGRID_API_KEY
AWS_SECRET_ACCESS_KEY
```

### 场景 3：添加 OAuth 凭证

```bash
# 添加以下字段
OAUTH_CLIENT_SECRET
GITHUB_CLIENT_SECRET
GOOGLE_CLIENT_SECRET
```

---

## 已内置支持的字段

以下字段无需手动添加，已自动支持：

**API Keys:**
- API_KEY, APIKEY, api_key
- ANTHROPIC_API_KEY
- LIONCC_API_KEY, LIONCCAPI_KEY
- VOLCENGINE_API_KEY
- GEMINI_API_KEY

**Tokens:**
- TOKEN, ACCESS_TOKEN, REFRESH_TOKEN, BOT_TOKEN

**App 凭证:**
- APP_ID, APPID, app_id
- APP_SECRET, APPSECRET, app_secret
- WECHAT_APPID, WECHAT_SECRET

**密码/密钥:**
- password, passwd, pwd
- secret, secretKey, secret_key, SECRET

---

## 故障排除

### 问题：添加字段后不生效

**解决方案：**
```bash
# 1. 检查配置文件格式
cat ~/.sensitive-guard/config/custom-fields.conf

# 2. 确保没有多余空格或特殊字符

# 3. 重新加载配置
source ~/.zshrc

# 4. 测试
~/.sensitive-guard/bin/scat your-file
```

### 问题：字段名包含特殊字符

自定义字段仅支持：大写字母、数字、下划线

**正确示例：**
- MY_API_KEY ✅
- DATABASE_PASSWORD ✅

**错误示例：**
- my-api-key ❌（包含中划线）
- api.key ❌（包含点号）
