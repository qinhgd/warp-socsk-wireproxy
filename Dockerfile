# wireproxy/Dockerfile
# ARM64-Only, copies binaries from local context

FROM alpine:3.18

# Install base dependencies (wgcf needs curl and tar)
RUN apk add --no-cache curl tar wireguard-tools

# === Install binaries provided by you ===
# Copy your pre-downloaded binaries into the image
COPY wireproxy-linux-arm64 /usr/local/bin/wireproxy
COPY warp-linux-arm64 /usr/local/bin/warp
# Make them executable
RUN chmod +x /usr/local/bin/wireproxy /usr/local/bin/warp

# === Install WGCF (for initial account registration) ===
# CORRECTED: Simplified the tar command for robustness
RUN curl -fsSL "https://github.com/ViRb3/wgcf/releases/download/v2.2.19/wgcf_2.2.19_linux_arm64.tar.gz" -o /tmp/wgcf.tar.gz && \
    tar -xzf /tmp/wgcf.tar.gz -C /usr/local/bin/ && \
    chmod +x /usr/local/bin/wgcf && \
    rm /tmp/wgcf.tar.gz

# Create working directory and copy the entrypoint script
WORKDIR /wgcf
COPY entry.sh /usr/local/bin/entry.sh
RUN chmod +x /usr/local/bin/entry.sh

# Set the entrypoint
ENTRYPOINT ["/usr/local/bin/entry.sh"]
