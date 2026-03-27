#!/bin/bash
# Sensitive Guard - 核心脱敏引擎（优化版）

GUARD_DIR="${SENSITIVE_GUARD_HOME:-$HOME/.sensitive-guard}"
RULES_FILE="$GUARD_DIR/rules.json"
CACHE_DIR="$GUARD_DIR/cache"
CUSTOM_FIELDS_FILE="$GUARD_DIR/config/custom-fields.conf"

# 初始化
init_guard() {
  mkdir -p "$GUARD_DIR" "$CACHE_DIR"
}

# 读取自定义字段
load_custom_fields() {
  if [ -f "$CUSTOM_FIELDS_FILE" ]; then
    grep -v '^#' "$CUSTOM_FIELDS_FILE" | grep -v '^[[:space:]]*$'
  fi
}

# 脱敏单个值（保留前后4个字符）
mask_value() {
  local value="$1"
  local len=${#value}

  if [ $len -le 8 ]; then
    echo "********"
  else
    local prefix="${value:0:4}"
    local suffix="${value: -4}"
    local middle_len=$((len - 8))
    local stars=$(printf '%*s' $middle_len | tr ' ' '*')
    echo "${prefix}${stars}${suffix}"
  fi
}

# 脱敏 DATABASE_URL 中的密码
mask_database_url() {
  local url="$1"

  # 匹配格式：protocol://user:password@host:port/db
  if echo "$url" | grep -qE '://[^:]+:[^@]+@'; then
    # 提取密码部分
    local protocol=$(echo "$url" | cut -d':' -f1)
    local rest=$(echo "$url" | cut -d'/' -f3-)
    local user=$(echo "$rest" | cut -d':' -f1)
    local pass_and_host=$(echo "$rest" | cut -d':' -f2-)
    local password=$(echo "$pass_and_host" | cut -d'@' -f1)
    local host_and_db=$(echo "$pass_and_host" | cut -d'@' -f2-)

    # 脱敏密码
    local masked_pass=$(mask_value "$password")
    echo "${protocol}://${user}:${masked_pass}@${host_and_db}"
  else
    echo "$url"
  fi
}

# 脱敏函数（新策略：先识别字段名，再脱敏值）
desensitize_content() {
  local content="$1"

  # 敏感字段关键词（不区分大小写）
  local keywords="(password|passwd|pwd|secret|key|token|credential|auth|appid|appsecret)"

  # 检测文件格式
  local is_json=false
  if echo "$content" | grep -qE '^\s*[{[]'; then
    is_json=true
  fi

  if [ "$is_json" = true ]; then
    # JSON 格式处理 - 逐行处理
    while IFS= read -r line; do
      # 检查是否包含敏感关键词
      if echo "$line" | grep -qiE "\"[^\"]*${keywords}[^\"]*\"\s*:\s*\"[^\"]+\""; then
        # 提取完整的 "value" 部分
        local full_line="$line"
        local value=$(echo "$line" | grep -oE ':\s*"[^"]+"' | sed 's/:\s*"//;s/"$//')

        # 脱敏
        if [ -n "$value" ] && [ ${#value} -gt 8 ]; then
          local masked=$(mask_value "$value")
          # 直接字符串替换
          echo "${full_line/$value/$masked}"
        else
          echo "$line"
        fi
      else
        echo "$line"
      fi
    done <<< "$content"
  else
    # ENV 格式处理
    echo "$content" | while IFS= read -r line; do
      # 跳过注释和空行
      if echo "$line" | grep -qE '^\s*#|^\s*$'; then
        echo "$line"
        continue
      fi

      # 提取字段名和值
      if echo "$line" | grep -qE '^[A-Z_]+='; then
        field=$(echo "$line" | cut -d'=' -f1)
        value=$(echo "$line" | cut -d'=' -f2-)

        # 特殊处理 DATABASE_URL（优先判断）
        if echo "$field" | grep -qiE 'database.*url|db.*url'; then
          masked=$(mask_database_url "$value")
          echo "${field}=${masked}"
        # 匹配包含敏感关键词的字段
        elif echo "$field" | grep -qiE "${keywords}"; then
          if [ ${#value} -gt 8 ]; then
            masked=$(mask_value "$value")
            echo "${field}=${masked}"
          else
            echo "$line"
          fi
        else
          echo "$line"
        fi
      else
        echo "$line"
      fi
    done
  fi
}
