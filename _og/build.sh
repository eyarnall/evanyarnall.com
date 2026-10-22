#!/usr/bin/env bash
# Rebuild the link-preview card (assets/img/og-card.png) by screenshotting the card page (/og-card/,
# made by _pages/og-card.html) with headless Google Chrome.
# Usage (from the site folder):  bash _og/build.sh
#
# GitHub also runs this on every deploy (.github/workflows/deploy.yml), so the live card is always
# current. It sets these to screenshot the site it already built:
#   SITE_DIR      a built site to use (skips the Jekyll build)
#   OUT           where to write the image
#   CHROME        the Chrome executable
#   CHROME_FLAGS  extra Chrome flags
set -euo pipefail
cd "$(dirname "$0")/.."
export LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8

CHROME="${CHROME:-/Applications/Google Chrome.app/Contents/MacOS/Google Chrome}"
OUT="${OUT:-assets/img/og-card.png}"
PORT=4918

if [ -n "${SITE_DIR:-}" ]; then
  DEST="$SITE_DIR"
  TEMP=""
else
  DEST="$(mktemp -d)"
  TEMP="$DEST"
  bundle exec jekyll build --quiet --destination "$DEST"
fi

python3 -m http.server "$PORT" --bind 127.0.0.1 --directory "$DEST" >/dev/null 2>&1 &
SERVER=$!
NEW="$(mktemp -d)"
cleanup() {
  kill "$SERVER" 2>/dev/null || true
  wait "$SERVER" 2>/dev/null || true
  rm -rf "$NEW"
  if [ -n "$TEMP" ]; then rm -rf "$TEMP"; fi
}
trap cleanup EXIT
sleep 1

# Laid out at 1200 x 630 and captured at 2x (2400 x 1260), so it stays crisp after sites downscale it.
# shellcheck disable=SC2086 # CHROME_FLAGS may hold several flags
"$CHROME" --headless=new --disable-gpu --hide-scrollbars --window-size=1200,630 --force-device-scale-factor=2 \
  --virtual-time-budget=8000 \
  ${CHROME_FLAGS:-} --screenshot="$NEW/card.png" "http://127.0.0.1:$PORT/og-card/" 2>/dev/null

# Replace the old image only once the new one exists.
if [ ! -s "$NEW/card.png" ]; then
  echo "Chrome did not capture the card; $OUT was left as it was." >&2
  exit 1
fi
mkdir -p "$(dirname "$OUT")"
mv "$NEW/card.png" "$OUT"

echo "Wrote $OUT"
