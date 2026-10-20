#!/usr/bin/env bash
# Point your free DuckDNS subdomain at this machine's public IP.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

if [[ -f .env ]]; then
  # shellcheck disable=SC1091
  set -a
  source .env
  set +a
fi

SUBDOMAIN="${DUCKDNS_SUBDOMAIN:-}"
TOKEN="${DUCKDNS_TOKEN:-}"

if [[ -z "$SUBDOMAIN" || -z "$TOKEN" ]]; then
  echo "Set DUCKDNS_SUBDOMAIN and DUCKDNS_TOKEN in .env first."
  echo "Create them free at https://www.duckdns.org"
  exit 1
fi

echo "Updating DuckDNS: ${SUBDOMAIN}.duckdns.org ..."
RESPONSE="$(curl -fsS "https://www.duckdns.org/update?domains=${SUBDOMAIN}&token=${TOKEN}&ip=")"
echo "DuckDNS response: ${RESPONSE}"

if [[ "$RESPONSE" != "OK" ]]; then
  echo "DuckDNS update failed."
  exit 1
fi

echo "Done. After DNS propagates, open: https://${SUBDOMAIN}.duckdns.org"
