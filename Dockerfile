# Claude ships as a single native ELF; the installer stage exists only to fetch it
# so the final image needs no Node, npm, or curl-to-bash at runtime.
FROM debian:trixie-slim AS claude
RUN apt-get update \
 && apt-get install -y --no-install-recommends ca-certificates curl \
 && curl -fsSL https://claude.ai/install.sh | bash \
 && cp -L /root/.local/bin/claude /claude

FROM debian:trixie-slim

# Match the host user so files in the bind-mounted project stay owned by them.
ARG UID=1000
ARG GID=1000

RUN apt-get update \
 && apt-get install -y --no-install-recommends \
      ca-certificates \
      curl \
      git \
      less \
      procps \
      ripgrep \
      sudo \
 && rm -rf /var/lib/apt/lists/*

# Root is available via sudo, not by running everything as root
RUN groupadd -g "$GID" dev \
 && useradd -m -u "$UID" -g "$GID" -s /bin/bash dev \
 && printf 'dev ALL=(ALL) NOPASSWD:ALL\n' > /etc/sudoers.d/dev \
 && chmod 0440 /etc/sudoers.d/dev

COPY --from=claude /claude /usr/local/bin/claude

# CLAUDE_CONFIG_DIR is where credentials, transcripts, prompt history and
# .claude.json all live.
# We create a new dir per project and bind mount it into the container.
ENV CLAUDE_CONFIG_DIR=/home/dev/.claude \
    DISABLE_AUTOUPDATER=1

USER dev
WORKDIR /home/dev
