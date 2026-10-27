#!/bin/bash
set -euo pipefail

_CI_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" && pwd)"
[ -f "$_CI_DIR/ci.env" ] && . "$_CI_DIR/ci.env"

PROJECT_DIR="${CI_PROJECT_DIR:-$PWD}"
cd "$PROJECT_DIR"

# Regenerate repos/altstore.json from the release we just synced so the
# AltStore source always points at the newest .ipa asset.
TAG="${RELEASE_TAG:-}"
IPA="vidlatte-ios-arm64-unsigned.ipa"
ASSET="release-assets/$IPA"
[ -f "$ASSET" ] || { echo "no ipa asset for $TAG, skipping altstore update"; exit 0; }

VERSION="${TAG#v}"
SIZE=$(stat -c%s "$ASSET")
SHA=$(sha256sum "$ASSET" | awk '{print $1}')
DATE=$(date -u +%Y-%m-%dT%H:%M:%SZ)
DL="https://gitlab.com/${GITLAB_PROJECT}/-/releases/${TAG}/downloads/${IPA}"
PAGES="https://$(echo "${GITLAB_PROJECT%%/*}" | tr '[:upper:]' '[:lower:]').gitlab.io/${GITLAB_PROJECT##*/}"

python3 - "$VERSION" "$DATE" "$SIZE" "$SHA" "$DL" "$PAGES" <<'PY'
import json, sys
version, date, size, sha, dl, pages = sys.argv[1:7]
src = {
    "name": "Vidlatte",
    "identifier": "gitlab.httpanimations.vidlatte",
    "sourceURL": "https://gitlab.com/HttpAnimations/vidlatte-flutter/-/raw/main/repos/altstore.json",
    "apps": [{
        "name": "Vidlatte",
        "bundleIdentifier": "gitlab.httpanimations.vidlatte",
        "developerName": "HttpAnimations",
        "iconURL": f"{pages}/repos/icon.png",
        "tintColor": "B5663D",
        "subtitle": "AI image generation powered by ComfyUI",
        "localizedDescription": "Generate images with your own ComfyUI servers.",
        "versions": [{
            "version": version,
            "date": date,
            "localizedDescription": "See the release notes on GitLab.",
            "downloadURL": dl,
            "size": int(size),
            "sha256": sha,
            "minOSVersion": "14.0"
        }]
    }]
}
with open('repos/altstore.json', 'w') as f:
    json.dump(src, f, indent=2)
    f.write('\n')
PY

# Commit the refreshed source back to main (skipped pipeline) so its raw URL
# always serves the newest release.
if [ -n "${GITLAB_TOKEN:-}" ]; then
  git config user.name "GitLab CI"
  git config user.email "ci@gitlab.com"
  git remote set-url origin "https://oauth2:${GITLAB_TOKEN}@${CI_SERVER_HOST}/${CI_PROJECT_PATH}.git"
  if ! git diff --quiet -- repos/altstore.json; then
    git add repos/altstore.json
    git commit -m "misc: update altstore source [skip ci]"
    git push -o ci.skip origin HEAD:main || true
  fi
fi
