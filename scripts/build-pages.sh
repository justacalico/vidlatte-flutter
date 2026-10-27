#!/bin/bash
set -euo pipefail

_CI_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" && pwd)"
[ -f "$_CI_DIR/ci.env" ] && . "$_CI_DIR/ci.env"

PROJECT_DIR="${CI_PROJECT_DIR:-$PWD}"
BASE="${PAGES_BASE:-/vidlatte-flutter}"
cd "$PROJECT_DIR"

mkdir -p public

# Landing page -> /
flutter config --no-analytics >/dev/null
(cd landing && flutter pub get && flutter build web --release --base-href "$BASE/")
cp -r landing/build/web/. public/

# App -> /app/
flutter pub get
flutter build web --release --base-href "$BASE/app/"
mkdir -p public/app
cp -r build/web/. public/app/

# AltStore source
mkdir -p public/repos
cp repos/altstore.json public/repos/altstore.json
cp assets/icon-1024.png public/repos/icon.png

# Signed flatpak repo from release assets (x86_64 + aarch64 merged).
mkdir -p .gpg
chmod 700 .gpg
GPG_OK=""
if [ -n "${FLATPAK_GPG_KEY:-}" ]; then
  echo "$FLATPAK_GPG_KEY" | base64 -d | gpg --batch --homedir .gpg --import && GPG_OK=1
fi

mkdir -p /tmp/fp-repos
found_repo=""
for arch in x86_64 aarch64; do
  t="/tmp/fp-repos/flatpak-repo-$arch.tar.gz"
  rm -f "$t"
  glab release download -R "$GITLAB_PROJECT" --dir /tmp/fp-repos --asset-name "flatpak-repo-$arch.tar.gz" 2>/dev/null || true
  [ -f "$t" ] || continue
  mkdir -p "/tmp/fp-repos/$arch"
  tar -xzf "$t" -C "/tmp/fp-repos/$arch"
  found_repo=1
done

if [ -n "$found_repo" ]; then
  mkdir -p public/flatpak-repo
  ostree init --repo=public/flatpak-repo --mode=archive-z2 2>/dev/null || true
  for arch in x86_64 aarch64; do
    [ -d "/tmp/fp-repos/$arch" ] || continue
    ostree pull-local --repo=public/flatpak-repo "/tmp/fp-repos/$arch" || true
  done
  mv public/flatpak-repo public/flatpak
  if [ -n "$GPG_OK" ]; then
    KEYID=$(gpg --batch --homedir .gpg --with-colons -k | awk -F: '/^pub/{print $5; exit}')
    flatpak build-update-repo --gpg-sign="$KEYID" --gpg-homedir="$PROJECT_DIR/.gpg" public/flatpak
    gpg --homedir .gpg --export "$KEYID" > public/flatpak/key.gpg
  else
    flatpak build-update-repo public/flatpak
  fi
  if [ -f public/flatpak/key.gpg ]; then
    cat > "public/${APP_NAME,,}.flatpakref" <<REOF
[Flatpak Ref]
Name=${APP_ID}
Branch=stable
Url=https://$(echo "$GITLAB_PROJECT" | tr '[:upper:]' '[:lower:]' | sed 's|/.*||' | sed 's/$/.gitlab.io/')$BASE/flatpak
SuggestRemoteName=${APP_NAME,,}
GPGKey=$(base64 -w0 public/flatpak/key.gpg)
RuntimeRepo=https://dl.flathub.org/repo/flathub.flatpakrepo
REOF
  fi
fi

echo "Pages contents:"
find public -maxdepth 2 -type f | head -40
