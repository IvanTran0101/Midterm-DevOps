#!/usr/bin/env bash
set -euo pipefail

# Phase 1: local bootstrap script (no server provisioning)
# Usage:
#   cd phase1
#   ./scripts/setup.sh
#   ./scripts/run.sh   (optional)

PHASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
APP_DIR="${PHASE_DIR}/app"

echo "==> Phase 1 setup"
echo "Phase dir: ${PHASE_DIR}"
echo "App dir:   ${APP_DIR}"

if [[ ! -d "${APP_DIR}" ]]; then
  echo "ERROR: app directory not found at: ${APP_DIR}"
  exit 1
fi

if [[ ! -f "${APP_DIR}/package.json" ]]; then
  echo "ERROR: package.json not found in: ${APP_DIR}"
  exit 1
fi

echo "==> [1/4] Check Node/NPM..."
if ! command -v node >/dev/null 2>&1; then
  echo "ERROR: Node.js is not installed."
  echo "Install Node.js (recommended: Node 20+) then re-run."
  exit 1
fi
if ! command -v npm >/dev/null 2>&1; then
  echo "ERROR: npm is not installed."
  exit 1
fi

node -v
npm -v

echo "==> [2/4] Install dependencies (npm ci preferred)..."
cd "${APP_DIR}"
if [[ -f package-lock.json ]]; then
  npm ci
else
  npm install
fi

echo "==> [3/4] Prepare environment file..."
if [[ -f .env.example && ! -f .env ]]; then
  cp .env.example .env
  echo "Created .env from .env.example"
  echo "NOTE: Fill in required values in ${APP_DIR}/.env before running."
else
  echo ".env already exists or .env.example not found — skipping copy."
fi

echo "==> [4/4] Quick sanity check..."
# If you have a test/lint script, enable these:
if npm run | grep -qE ' test|lint'; then
  echo "Detected npm scripts. (Not running automatically to avoid surprises.)"
fi

echo
echo "==> Done."
echo "Next steps:"
echo "  1) Edit: ${APP_DIR}/.env"
echo "  2) Run:  cd ${APP_DIR} && npm start"
echo "  (or)     ./scripts/run.sh  (if you create it)"