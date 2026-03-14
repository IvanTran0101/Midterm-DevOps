#!/usr/bin/env bash
set -euo pipefail

PHASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
APP_DIR="${PHASE_DIR}/app"

cd "${APP_DIR}"
npm start