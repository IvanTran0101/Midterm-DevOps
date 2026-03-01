#!/usr/bin/env bash
set -euo pipefail

APP_NAME="${APP_NAME:-myapp}"
CONF_SRC="${CONF_SRC:-../config/nginx/myapp.conf}"
CONF_DST="/etc/nginx/conf.d/${APP_NAME}.conf"

echo "==> Apply Nginx config for ${APP_NAME}"
echo "Source: ${CONF_SRC}"
echo "Dest:   ${CONF_DST}"

if [[ ! -f "${CONF_SRC}" ]]; then
  echo "ERROR: Nginx config not found: ${CONF_SRC}"
  exit 1
fi

sudo cp "${CONF_SRC}" "${CONF_DST}"

echo "==> nginx -t"
sudo nginx -t

echo "==> reload nginx"
sudo systemctl reload nginx

echo "==> Done. Nginx is reloaded."