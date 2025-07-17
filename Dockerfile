# FINAL Dockerfile: ARM64-Only, Local Binaries + WGCF via Script

FROM alpine:3.18

# 安装基础依赖
# bash: 是运行安装脚本所必需的
# curl: 用于下载安装脚本
# tar: entry.sh 内部可能会使用
RUN apk add --no-cache bash curl tar ca-certificates

# --- 安装您提供的本地二进制文件 ---
COPY wireproxy-linux-arm64 /usr/local/bin/wireproxy
COPY warp-linux-arm64 /usr/local/bin/warp

# --- 使用您指定的脚本安装 WGCF ---
# 这个脚本会自动检测 arm64 架构并安装最新版本的 wgcf
RUN curl -fsSL git.io/wgcf.sh | bash

# --- 统一设置可执行权限 ---
RUN chmod +x /usr/local/bin/wireproxy /usr/local/bin/warp /usr/local/bin/wgcf

# --- 最终设置 ---
WORKDIR /wgcf
COPY entry.sh /usr/local/bin/entry.sh
RUN chmod +x /usr/local/bin/entry.sh

ENTRYPOINT ["/usr/local/bin/entry.sh"]
