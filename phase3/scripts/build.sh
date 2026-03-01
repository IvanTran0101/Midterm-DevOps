#!/usr/bin/env bash
set -euo pipefail

IMAGE="youngmizh/midterm-devops:1.0.1"
DOCKER_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../docker" && pwd)"

docker build -t "${IMAGE}" "${DOCKER_DIR}"
echo "Built: ${IMAGE}"