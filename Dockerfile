# syntax=docker/dockerfile:1

# Base image can be overridden at build time.
# The upstream docs recommend a Node-based image such as node:24-trixie-slim.
ARG BASE_IMAGE=node:24-trixie-slim
FROM ${BASE_IMAGE}

# Pin or override the agent-browser version from the build command.
# Leave empty (default) to install the latest version.
ARG AGENT_BROWSER_VERSION

# Install the agent-browser CLI globally.
# If AGENT_BROWSER_VERSION is set, install that exact version.
RUN npm install -g "agent-browser${AGENT_BROWSER_VERSION:+@$AGENT_BROWSER_VERSION}"

# Download Chrome and let agent-browser install its required Linux system deps.
# Using --with-deps avoids maintaining a hand-curated package list.
# sudo is installed first because agent-browser internally invokes apt-get via sudo.
# Extra packages below enable WebGPU support in Linux containers.
# Based on: https://github.com/vercel-labs/agent-browser/blob/v0.35.1/docs/src/app/webgpu/page.mdx
#   - libvulkan1, mesa-vulkan-drivers: SwiftShader Vulkan ICD for GPU-less rendering
#   - xvfb, xauth: virtual display for --headed screenshot capture on displayless hosts
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    apt-get update && \
    apt-get install -y sudo \
        ca-certificates \
        libvulkan1 \
        mesa-vulkan-drivers \
        xvfb \
        xauth && \
    agent-browser install --with-deps

# The upstream Node image sets an entrypoint helper that we do not need.
# Clear it so CMD runs directly without docker-entrypoint.sh interference.
ENTRYPOINT []

# Keep the container alive so an AI agent can docker exec into it per session.
CMD ["sleep", "infinity"]
