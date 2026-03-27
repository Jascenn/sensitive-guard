#!/bin/bash
# Sensitive Guard - Shell 函数包装

# 取消可能存在的别名
unalias cat 2>/dev/null
unalias less 2>/dev/null
unalias grep 2>/dev/null

cat() {
  if command -v scat &>/dev/null; then
    scat "$@"
  else
    command cat "$@"
  fi
}

less() {
  if command -v sless &>/dev/null; then
    sless "$@"
  else
    command less "$@"
  fi
}

grep() {
  if command -v sgrep &>/dev/null; then
    sgrep "$@"
  else
    command grep "$@"
  fi
}
