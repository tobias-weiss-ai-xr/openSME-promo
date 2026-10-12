# openSME Promo Website

Landing page for [opensme.graphwiz.ai](https://opensme.graphwiz.ai) — the
self-hosted software suite for small and medium business
([openSME-compose](https://github.com/tobias-weiss-ai-xr/openSME-compose)).

- Single-file static page (`index.html`) — no build step
- English landing, dark theme (openSME palette)
- Legal pages: `/imprint/` · `/privacy/` · `/ai-statement/` (bilingual DE/EN)
- `robots.txt` + `sitemap.xml` for the four pages

## Deploy

Production is served from `/opt/opensme-promo` on the openedusuite.org host
(195.90.216.140) by the `opensme-promo` nginx container behind Traefik
(`Host(opensme.graphwiz.ai)` → `opensme-promo@file`, see
`/root/git/docker-traefik/dynamic/routers.yml`). Files are copied there via
`sudo`; the repo mirrors that state.

`docker-compose.yml` reproduces the same nginx + Traefik setup for fresh
installs.

### Deploy from this repo (production)

```bash
# from WSL (key: ~/.ssh/id_ed25519_ansible on 195.90.216.140)
wsl bash scripts/deploy.sh
```

Syncs `index.html`, `robots.txt`, `sitemap.xml` and the legal pages to
`/opt/opensme-promo` on the production host (idempotent; updates the live
site immediately — the bind-mounted nginx container picks the files up
directly).
