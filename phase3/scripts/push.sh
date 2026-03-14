#!/usr/bin/env bash
set -euo pipefail

IMAGE="youngmizh/midterm-devops:1.0.1"

docker push "${IMAGE}"
echo "Pushed: ${IMAGE}"