#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Sensitive Guard FUSE 文件系统"""

import os
import sys
import errno
import stat
from fuse import FUSE, FuseOSError, Operations
import re

class SensitiveFS(Operations):
    def __init__(self, root):
        self.root = os.path.realpath(root)
        self.mask_mode = True  # 脱敏模式开关

        # 脱敏规则
        self.patterns = [
            (r'(sk-[a-zA-Z0-9]{4})[a-zA-Z0-9]{40}([a-zA-Z0-9]{4})', r'\1************************************\2'),
            (r'("(token|botToken|accessToken|refreshToken)": "[^"]{4})[^"]{16,}([^"]{4}")', r'\1****************\3'),
            (r'("(apiKey|api_key|API_KEY|APIKEY)": "([0-9a-zA-Z_-]{4}))[0-9a-zA-Z_-]{8,}(([0-9a-zA-Z_-]{4})")', r'\1************\4'),
            (r'("(appId|app_id|APP_ID|APPID)": "([0-9a-zA-Z_-]{4}))[0-9a-zA-Z_-]{8,}(([0-9a-zA-Z_-]{4})")', r'\1************\4'),
            (r'("(appSecret|app_secret|APP_SECRET|APPSECRET)": "[^"]{4})[^"]{8,}([^"]{4}")', r'\1************\3'),
            (r'("(password|passwd|pwd)": ")[^"]{2,}(")', r'\1********\2'),
            (r'("(secret|secretKey|secret_key)": "[^"]{4})[^"]{8,}([^"]{4}")', r'\1********\3'),
        ]

    def _full_path(self, partial):
        if partial.startswith("/"):
            partial = partial[1:]
        path = os.path.join(self.root, partial)
        return path

    def _desensitize(self, content):
        """应用脱敏规则"""
        if not self.mask_mode:
            return content

        result = content
        for pattern, replacement in self.patterns:
            result = re.sub(pattern, replacement, result)
        return result

    # 文件系统操作
    def getattr(self, path, fh=None):
        full_path = self._full_path(path)
        st = os.lstat(full_path)
        return dict((key, getattr(st, key)) for key in ('st_atime', 'st_ctime',
                     'st_gid', 'st_mode', 'st_mtime', 'st_nlink', 'st_size', 'st_uid'))

    def readdir(self, path, fh):
        full_path = self._full_path(path)
        dirents = ['.', '..']
        if os.path.isdir(full_path):
            dirents.extend(os.listdir(full_path))
        for r in dirents:
            yield r

    def read(self, path, length, offset, fh):
        full_path = self._full_path(path)
        with open(full_path, 'rb') as f:
            f.seek(offset)
            content = f.read(length)
            # 脱敏处理
            text = content.decode('utf-8', errors='ignore')
            masked = self._desensitize(text)
            return masked.encode('utf-8')

    def write(self, path, buf, offset, fh):
        """写入操作：直接透传到真实文件"""
        full_path = self._full_path(path)
        with open(full_path, 'r+b') as f:
            f.seek(offset)
            f.write(buf)
        return len(buf)

    # 其他必需操作
    def chmod(self, path, mode):
        full_path = self._full_path(path)
        return os.chmod(full_path, mode)

    def chown(self, path, uid, gid):
        full_path = self._full_path(path)
        return os.chown(full_path, uid, gid)

    def open(self, path, flags):
        full_path = self._full_path(path)
        return os.open(full_path, flags)

    def release(self, path, fh):
        return os.close(fh)

def main():
    if len(sys.argv) != 3:
        print('Usage: %s <root> <mountpoint>' % sys.argv[0])
        sys.exit(1)

    root = sys.argv[1]
    mountpoint = sys.argv[2]
    
    FUSE(SensitiveFS(root), mountpoint, nothreads=True, foreground=True)

if __name__ == '__main__':
    main()
