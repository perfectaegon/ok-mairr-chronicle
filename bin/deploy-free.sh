#!/usr/bin/env bash
# Build and start the free self-host stack (app + HTTPS via Caddy).
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

if [[ ! -f .env ]]; then
  cp .env.example .env
  echo "Created .env from .env.example"
  echo "Edit .env now:"
  echo "  - DOMAIN / DUCKDNS_SUBDOMAIN / DUCKDNS_TOKEN"
  echo "  - ADMIN_PASSWORD"
  echo "Then re-run: bin/deploy-free.sh"
  exit 1
fi

# shellcheck disable=SC1091
set -a
source .env
set +a

if [[ -z "${ADMIN_PASSWORD:-}" || "$ADMIN_PASSWORD" == "change-this-password" ]]; then
  echo "Set a real ADMIN_PASSWORD in .env before deploying."
  exit 1
fi

if [[ -z "${DOMAIN:-}" ]]; then
  echo "Set DOMAIN in .env (e.g. okmairr.duckdns.org)."
  exit 1
fi

if [[ -n "${DUCKDNS_TOKEN:-}" && -n "${DUCKDNS_SUBDOMAIN:-}" ]]; then
  bin/update-duckdns.sh
fi

echo "Building and starting containers..."
docker compose up -d --build

echo ""
echo "Chronicle is starting."
echo "  Public site:  https://${DOMAIN}"
echo "  Editor desk:  https://${DOMAIN}/admin"
echo ""
echo "Useful commands:"
echo "  docker compose logs -f"
echo "  docker compose ps"
echo "  docker compose down"
