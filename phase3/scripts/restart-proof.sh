#!/usr/bin/env bash
set -euo pipefail

DOCKER_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../docker" && pwd)"
cd "${DOCKER_DIR}"

echo "==> docker ps (before)"
docker ps

echo "==> docker compose restart"
docker compose restart
docker ps

echo "==> restart Docker daemon"
sudo systemctl restart docker
sleep 3

echo "==> ensure services up"
docker compose up -d
docker ps

echo "==> DONE: now verify HTTPS:"
echo "curl -I https://midtermdevops.trananhminh.uk"