#!/usr/bin/env bash
# Rebuild Evan's CV PDF (assets/pdf/Yarnall_CV.pdf).
# The CV is generated from _data/cv.yml and _bibliography/papers.bib by _includes/cv_body.liquid,
# the same template the website's CV page uses. This script builds the site, serves the printable
# page (/cv/print/) locally, and prints it to PDF with headless Google Chrome.
# Usage (from the site folder):  bash _cv/build.sh
#
# GitHub also runs this on every deploy (.github/workflows/deploy.yml), so the live PDF is always
# current. It sets these to print from the site it already built:
#   SITE_DIR      a built site to print from (skips the Jekyll build)
#   OUT           where to write the PDF
#   CHROME        the Chrome executable
#   CHROME_FLAGS  extra Chrome flags
set -euo pipefail
cd "$(dirname "$0")/.."
export LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8

CHROME="${CHROME:-/Applications/Google Chrome.app/Contents/MacOS/Google Chrome}"
OUT="${OUT:-assets/pdf/Yarnall_CV.pdf}"
PORT=4917

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

# shellcheck disable=SC2086 # CHROME_FLAGS may hold several flags
"$CHROME" --headless=new --disable-gpu --no-pdf-header-footer --virtual-time-budget=10000 ${CHROME_FLAGS:-} \
  --print-to-pdf="$NEW/cv.pdf" "http://127.0.0.1:$PORT/cv/print/" 2>/dev/null

# Replace the old PDF only once the new one exists.
if [ ! -s "$NEW/cv.pdf" ]; then
  echo "Chrome did not print the CV; $OUT was left as it was." >&2
  exit 1
fi
mkdir -p "$(dirname "$OUT")"
mv "$NEW/cv.pdf" "$OUT"

# The CV is designed to fit on two pages.
PAGES="$(grep -a -o '/Count [0-9]*' "$OUT" | head -n 1 | cut -d ' ' -f 2 || true)"
if [ "${PAGES:-0}" -gt 2 ]; then
  MSG="The CV PDF is now $PAGES pages (it was designed for 2). Check it, or tighten _data/cv.yml."
  if [ -n "${GITHUB_ACTIONS:-}" ]; then echo "::warning title=CV length::$MSG"; else echo "Note: $MSG"; fi
fi

echo "Wrote $OUT (${PAGES:-?} pages)"
