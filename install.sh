#!/usr/bin/env bash
# Build the aibox image and install the wrapper. Re-run to upgrade either.
set -euo pipefail

here=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)
prefix="${PREFIX:-$HOME/.local}"
bindir="$prefix/bin"

die() { printf 'install: %s\n' "$1" >&2; exit 1; }

command -v docker >/dev/null || die "docker not found on PATH"
docker info >/dev/null 2>&1 || die "cannot reach the docker daemon"

# UID/GID are baked in so the container user matches whoever installed.
docker build \
  --build-arg UID="$(id -u)" \
  --build-arg GID="$(id -g)" \
  -t aibox:latest \
  "$here"

install -Dm755 "$here/aibox" "$bindir/aibox"
printf 'installed %s\n' "$bindir/aibox"

case ":$PATH:" in
  *":$bindir:"*) ;;
  *) printf 'warning: %s is not on your PATH\n' "$bindir" >&2 ;;
esac
