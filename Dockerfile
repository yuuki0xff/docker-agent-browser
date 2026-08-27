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

# Install sudo first: agent-browser's --with-deps internally invokes
# apt-get via sudo, but node:*-slim images do not ship with sudo.
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    apt-get update && apt-get install -y sudo

# Download Chrome and let agent-browser install its required Linux system deps.
# Using --with-deps avoids maintaining a hand-curated package list.
RUN agent-browser install --with-deps

# Keep the container alive so an AI agent can docker exec into it per session.
CMD ["sleep", "infinity"]
