# FINAL Dockerfile: ARM64-Only, Local Binaries + Reliable WGCF Download

FROM alpine:latest

# 为 wgcf 下载命令设置默认架构
ARG TARGETARCH=arm64

# 安装基础依赖
RUN apk add --no-cache curl tar ca-certificates

# --- 安装您提供的本地二进制文件 ---
COPY wireproxy-linux-arm64 /usr/local/bin/wireproxy
COPY warp-linux-arm64 /usr/local/bin/warp

# --- 使用您发现的、最可靠的方法安装 WGCF ---
ARG WGCF_VERSION=v2.2.19
RUN curl -fL -o /usr/local/bin/wgcf "https://github.com/ViRb3/wgcf/releases/download/${WGCF_VERSION}/wgcf_${WGCF_VERSION#v}_linux_${TARGETARCH}" && \
    chmod +x /usr/local/bin/wgcf

# --- 为本地文件统一设置可执行权限 ---
RUN chmod +x /usr/local/bin/wireproxy /usr/local/bin/warp

# --- 最终设置 ---
WORKDIR /wgcf
COPY entry.sh /usr/local/bin/entry.sh
RUN chmod +x /usr/local/bin/entry.sh

ENTRYPOINT ["/usr/local/bin/entry.sh"]
