#!/usr/bin/env bash
set -euo pipefail

APP_NAME="${APP_NAME:-myapp}"
APP_USER="${APP_USER:-appuser}"
APP_DIR="${APP_DIR:-/var/www/${APP_NAME}}"

# REQUIRED: set your repo
REPO_URL="${REPO_URL:-}"
BRANCH="${BRANCH:-main}"

# Entry point: choose ONE of these:
START_MODE="${START_MODE:-npm}"        # "npm" or "node"
NODE_ENTRY="${NODE_ENTRY:-main.js}"    # if START_MODE=node
NPM_SCRIPT="${NPM_SCRIPT:-start}"      # if START_MODE=npm

ENV_TEMPLATE="${ENV_TEMPLATE:-../env/.env.template}"

echo "==> Deploy ${APP_NAME} to ${APP_DIR} (branch: ${BRANCH})"

if [[ -z "${REPO_URL}" ]]; then
  echo "ERROR: REPO_URL is empty."
  echo "Example:"
  echo "  REPO_URL='https://github.com/<user>/<repo>.git' ./deploy.sh"
  exit 1
fi

echo "==> [1/6] Fetch source code..."
sudo install -d -o "${APP_USER}" -g "${APP_USER}" "${APP_DIR}"

if [[ ! -d "${APP_DIR}/.git" ]]; then
  sudo -u "${APP_USER}" git clone --branch "${BRANCH}" "${REPO_URL}" "${APP_DIR}"
else
  sudo -u "${APP_USER}" bash -lc "cd '${APP_DIR}' && git fetch --all && git checkout '${BRANCH}' && git pull"
fi

echo "==> [2/6] Install dependencies..."
sudo -u "${APP_USER}" bash -lc "cd '${APP_DIR}' && if [ -f package-lock.json ]; then npm ci; else npm install; fi"

echo "==> [3/6] Prepare env..."
if [[ -f "${ENV_TEMPLATE}" ]]; then
  if [[ ! -f "${APP_DIR}/.env" ]]; then
    sudo cp "${ENV_TEMPLATE}" "${APP_DIR}/.env"
    sudo chown "${APP_USER}:${APP_USER}" "${APP_DIR}/.env"
    echo "Created ${APP_DIR}/.env from template. Fill it with real values."
  else
    echo ".env already exists. Skipping."
  fi
else
  echo "WARN: ENV template not found at ${ENV_TEMPLATE} (skipping copy)."
fi

echo "==> [4/6] Start/Restart with PM2..."
if [[ "${START_MODE}" == "node" ]]; then
  sudo -u "${APP_USER}" bash -lc "cd '${APP_DIR}' && pm2 start '${NODE_ENTRY}' --name '${APP_NAME}' --update-env || pm2 restart '${APP_NAME}' --update-env"
else
  sudo -u "${APP_USER}" bash -lc "cd '${APP_DIR}' && pm2 start npm --name '${APP_NAME}' -- run '${NPM_SCRIPT}' --update-env || pm2 restart '${APP_NAME}' --update-env"
fi

echo "==> [5/6] Enable PM2 on reboot..."
# pm2 startup prints a command that must be executed with sudo.
STARTUP_CMD="$(sudo -u "${APP_USER}" bash -lc "pm2 startup systemd -u '${APP_USER}' --hp '/home/${APP_USER}'" | tail -n 1 || true)"
if [[ "${STARTUP_CMD}" == sudo* ]]; then
  echo "Running: ${STARTUP_CMD}"
  eval "${STARTUP_CMD}"
fi

sudo -u "${APP_USER}" bash -lc "pm2 save"

echo "==> [6/6] Quick status..."
sudo -u "${APP_USER}" bash -lc "pm2 status"
echo "==> Done."