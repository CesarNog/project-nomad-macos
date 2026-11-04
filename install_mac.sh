#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"

[[ "$(uname -s)" == "Darwin" ]] || { echo "macOS only" >&2; exit 1; }
docker info >/dev/null 2>&1 || { echo "Docker Desktop is not running" >&2; exit 1; }
docker compose version >/dev/null 2>&1 || { echo "docker compose v2 required" >&2; exit 1; }

if [[ ! -f .env ]]; then
  umask 077
  cat > .env <<ENV
NOMAD_STORAGE_PATH=${NOMAD_STORAGE_PATH:-$HOME/nomad-data/storage}
APP_KEY=$(openssl rand -hex 24)
DB_ROOT_PASSWORD=$(openssl rand -hex 24)
DB_PASSWORD=$(openssl rand -hex 24)
ENV
fi

storage="$(sed -n 's/^NOMAD_STORAGE_PATH=//p' .env)"
mkdir -p "$storage/logs"
touch "$storage/logs/admin.log"

docker compose -p project-nomad up -d
echo "UI: http://localhost:8080   logs: http://localhost:9999"
