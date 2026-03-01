#!/usr/bin/env bash
set -euo pipefail

APP_NAME="${APP_NAME:-myapp}"
APP_USER="${APP_USER:-appuser}"
APP_DIR="${APP_DIR:-/var/www/${APP_NAME}}"
NODE_MAJOR="${NODE_MAJOR:-20}"

echo "==> Setup EC2 (Amazon Linux 2023) for ${APP_NAME}"
echo "APP_DIR=${APP_DIR} | APP_USER=${APP_USER} | NODE_MAJOR=${NODE_MAJOR}"

echo "==> [1/6] Update system packages..."
sudo dnf -y update

echo "==> [2/6] Install base dependencies..."
sudo dnf -y install ca-certificates curl-minimal git unzip gcc-c++ make

echo "==> [3/6] Install Node.js v${NODE_MAJOR}..."
if ! node -v >/dev/null 2>&1; then
  curl -fsSL "https://rpm.nodesource.com/setup_${NODE_MAJOR}.x" | sudo bash -
  sudo dnf -y install nodejs
fi
node -v
npm -v

echo "==> [4/6] Install Nginx..."
sudo dnf -y install nginx
sudo systemctl enable nginx
sudo systemctl start nginx
nginx -v || true

echo "==> [5/6] Install PM2..."
sudo npm i -g pm2
pm2 -v

echo "==> [6/6] Create app user + directories..."
if ! id -u "${APP_USER}" >/dev/null 2>&1; then
  sudo useradd -m -s /bin/bash "${APP_USER}"
fi

sudo install -d -o "${APP_USER}" -g "${APP_USER}" "${APP_DIR}"
sudo install -d -o "${APP_USER}" -g "${APP_USER}" "${APP_DIR}/logs"
sudo install -d -o "${APP_USER}" -g "${APP_USER}" "${APP_DIR}/uploads"
sudo install -d -o "${APP_USER}" -g "${APP_USER}" "${APP_DIR}/data"

echo "==> Done."
echo "Nginx status (first lines):"
sudo systemctl --no-pager --full status nginx | sed -n '1,12p' || true

ENV_TEMPLATE="${ENV_TEMPLATE:-../config/env/.env.template}" # tuỳ bạn set đường dẫn khi chạy script

echo "==> Create .env from template (if missing)..."
if [[ -f "${ENV_TEMPLATE}" ]]; then
  if [[ ! -f "${APP_DIR}/.env" ]]; then
    sudo cp "${ENV_TEMPLATE}" "${APP_DIR}/.env"
    sudo chown "${APP_USER}:${APP_USER}" "${APP_DIR}/.env"
    echo "Created ${APP_DIR}/.env from ${ENV_TEMPLATE}"
    echo "NOTE: Edit ${APP_DIR}/.env with real values (do NOT commit)."
  else
    echo "${APP_DIR}/.env already exists. Skipping."
  fi
else
  echo "WARN: ENV_TEMPLATE not found at ${ENV_TEMPLATE} (skipping)."
fi