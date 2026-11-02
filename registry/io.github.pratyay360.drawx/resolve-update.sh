#!/bin/sh
set -euo pipefail

# DrawX uses Tauri's auto-update with a feed endpoint
# Read version from latest release feed
repo="Pratyay360/drawx"
rel="$(curl -fsSL ${GITHUB_TOKEN:+-H "Authorization: Bearer $GITHUB_TOKEN"} \
        "https://api.github.com/repos/$repo/releases/latest")"

version="$(jq -r '.tag_name | ltrimstr("v")' <<<"$rel")"
url="$(jq -r '.assets[] | select(.name | test("amd64\\.deb$")) | .browser_download_url' <<<"$rel" | head -n1)"
date="$(jq -r '.published_at' <<<"$rel" | cut -c1-10)"

[ -n "$version" ] && [ -n "$url" ] || { echo "failed to resolve release" >&2; exit 1; }

jq -n --arg v "$version" --arg d "$date" --arg u "$url" \
  '{version:$v, releaseDate:$d, sources:[{filename:"drawx.deb", url:$u}]}'