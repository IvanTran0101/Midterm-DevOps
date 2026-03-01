#!/usr/bin/env bash
set -euo pipefail

APP_NAME="${APP_NAME:-myapp}"
APP_USER="${APP_USER:-appuser}"
APP_DIR="${APP_DIR:-/var/www/${APP_NAME}}"

# NEW: subdirectory where Node app lives inside repo
APP_SUBDIR="${APP_SUBDIR:-phase1/app}"

REPO_URL="${REPO_URL:-}"
BRANCH="${BRANCH:-main}"

START_MODE="${START_MODE:-npm}"       
NODE_ENTRY="${NODE_ENTRY:-main.js}"   
NPM_SCRIPT="${NPM_SCRIPT:-start}"     

ENV_TEMPLATE="${ENV_TEMPLATE:-../config/env/.env.template}"

echo "==> Deploy ${APP_NAME} to ${APP_DIR} (branch: ${BRANCH})"
echo "==> App subdir: ${APP_SUBDIR}"

if [[ -z "${REPO_URL}" ]]; then
  echo "ERROR: REPO_URL is empty."
  exit 1
fi

echo "==> [1/6] Fetch source code..."
sudo install -d -o "${APP_USER}" -g "${APP_USER}" "${APP_DIR}"

if [[ ! -d "${APP_DIR}/.git" ]]; then
  sudo -u "${APP_USER}" git clone --branch "${BRANCH}" "${REPO_URL}" "${APP_DIR}"
else
  sudo -u "${APP_USER}" bash -lc "cd '${APP_DIR}' && git fetch --all && git checkout '${BRANCH}' && git pull"
fi

APP_PATH="${APP_DIR}/${APP_SUBDIR}"

if [[ ! -f "${APP_PATH}/package.json" ]]; then
  echo "ERROR: package.json not found in ${APP_PATH}"
  exit 1
fi

echo "==> [2/6] Install dependencies..."
sudo -u "${APP_USER}" bash -lc "cd '${APP_PATH}' && if [ -f package-lock.json ]; then npm ci; else npm install; fi"

echo "==> [3/6] Prepare env..."
if [[ -f "${ENV_TEMPLATE}" ]]; then
  if [[ ! -f "${APP_PATH}/.env" ]]; then
    sudo cp "${ENV_TEMPLATE}" "${APP_PATH}/.env"
    sudo chown "${APP_USER}:${APP_USER}" "${APP_PATH}/.env"
    echo "Created ${APP_PATH}/.env from template."
  else
    echo ".env already exists. Skipping."
  fi
else
  echo "WARN: ENV template not found at ${ENV_TEMPLATE} (skipping copy)."
fi

echo "==> [4/6] Start/Restart with PM2..."
if [[ "${START_MODE}" == "node" ]]; then
  sudo -u "${APP_USER}" bash -lc "cd '${APP_PATH}' && pm2 start '${NODE_ENTRY}' --name '${APP_NAME}' --update-env || pm2 restart '${APP_NAME}' --update-env"
else
  sudo -u "${APP_USER}" bash -lc "cd '${APP_PATH}' && pm2 start npm --name '${APP_NAME}' -- run '${NPM_SCRIPT}' --update-env || pm2 restart '${APP_NAME}' --update-env"
fi

echo "==> [5/6] Enable PM2 on reboot..."
STARTUP_CMD="$(sudo -u "${APP_USER}" bash -lc "pm2 startup systemd -u '${APP_USER}' --hp '/home/${APP_USER}'" | tail -n 1 || true)"
if [[ "${STARTUP_CMD}" == sudo* ]]; then
  echo "Running: ${STARTUP_CMD}"
  eval "${STARTUP_CMD}"
fi

sudo -u "${APP_USER}" bash -lc "pm2 save"

echo "==> [6/6] Quick status..."
sudo -u "${APP_USER}" bash -lc "pm2 status"

echo "==> Done."