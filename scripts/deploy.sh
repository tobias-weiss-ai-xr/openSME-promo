#!/usr/bin/env bash
#
# Deploy the openSME promo website to production.
#
# Syncs the web files of this repository to /opt/opensme-promo on the
# production host (openedusuite.org, 195.90.216.140), served by the
# `opensme-promo` nginx container behind Traefik
# (Host(opensme.graphwiz.ai) -> opensme-promo@file).
#
# Run from WSL (mandatory infra convention — key lives in WSL ~/.ssh):
#   wsl bash scripts/deploy.sh
#
set -euo pipefail

cd "$(dirname "$0")/.."

HOST="${HOST:-weiss@195.90.216.140}"
DEST="/opt/opensme-promo"
KEY="${DEPLOY_KEY:-$HOME/.ssh/id_ed25519_ansible}"
TMP="/tmp/opensme-promo-deploy-$$"
FILES=(index.html robots.txt sitemap.xml imprint privacy ai-statement)
REV="$(git rev-parse --short HEAD)"

for f in "${FILES[@]}"; do
  [ -e "$f" ] || { echo "FEHLER: $f nicht gefunden (Repo nicht vollständig?)" >&2; exit 1; }
done

echo "==> ${REV} → ${HOST}:${DEST}"
ssh -i "$KEY" -o IdentitiesOnly=yes -o ConnectTimeout=15 "$HOST" "rm -rf $TMP && mkdir -p $TMP"
for f in "${FILES[@]}"; do
  scp -i "$KEY" -o IdentitiesOnly=yes -r "$f" "$HOST:$TMP/"
done
ssh -i "$KEY" -o IdentitiesOnly=yes "$HOST" "
  set -e
  sudo cp -r $TMP/* $DEST/
  sudo chown -R root:root $DEST
  rm -rf $TMP
  echo 'deployed $REV to $DEST'
"
echo "==> LIVE: $(git rev-parse --short HEAD) auf opensme.graphwiz.ai"
