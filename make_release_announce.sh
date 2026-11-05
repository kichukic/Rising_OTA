#!/usr/bin/env bash
# make_release_announce.sh — Generate Telegram announcement from haydn.json + changelog
# Usage: ./make_release_announce.sh [--changelog PATH] [--json PATH] [--out FILE]
# Reads your latest build from haydn.json and formats like Axion AOSP Telegram post.
set -euo pipefail

JSON="haydn.json"
CHANGELOG="changelogs/haydn.txt"
OUT=""

# Optional overrides via args
while [[ $# -gt 0 ]]; do
  case "$1" in
    --json) JSON="$2"; shift 2;;
    --changelog) CHANGELOG="$2"; shift 2;;
    --out) OUT="$2"; shift 2;;
    *) echo "Unknown arg: $1" >&2; exit 1;;
  esac
done

# Resolve paths relative to script dir / cwd
# Try cwd first, then script dir
if [[ ! -f "$JSON" ]]; then
  SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
  [[ -f "$SCRIPT_DIR/$JSON" ]] && JSON="$SCRIPT_DIR/$JSON"
fi
if [[ ! -f "$CHANGELOG" ]]; then
  SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
  [[ -f "$SCRIPT_DIR/$CHANGELOG" ]] && CHANGELOG="$SCRIPT_DIR/$CHANGELOG"
fi

[[ -f "$JSON" ]] || { echo "❌ haydn.json not found (looked in cwd and script dir)" >&2; exit 1; }
[[ -f "$CHANGELOG" ]] || { echo "⚠️  changelog not found: $CHANGELOG — Notes section will be empty" >&2; CHANGELOG=""; }

# --- Parse JSON (python3 preferred, jq fallback) ---
if command -v python3 >/dev/null 2>&1; then
  eval "$(python3 - <<PY
import json, os, datetime, shlex
try:
    data = json.load(open("$JSON"))
    r = data["response"][0] if "response" in data else data
except Exception as e:
    print("ERR", e)
    import sys; sys.exit(1)

def s(k, d=""):
    v = r.get(k, d)
    return str(v)

def fmt_size(b):
    try:
        b = int(b)
        for u in ["B","KB","MB","GB"]:
            if b < 1024: return f"{b} {u}"
            b /= 1024
        return f"{b:.2f} TB"
    except: return str(b)

ts = r.get("timestamp") or r.get("datetime") or 0
try:
    date_str = datetime.datetime.utcfromtimestamp(int(ts)).strftime("%d/%m/%y")
    human = datetime.datetime.utcfromtimestamp(int(ts)).strftime("%Y-%m-%d %H:%M UTC")
except:
    date_str = s("filename").split("-")[2] if "-" in s("filename") else "N/A"
    human = date_str

print(f"F_FILENAME={shlex.quote(s('filename'))}")
print(f"F_DOWNLOAD={shlex.quote(s('download') or s('url'))}")
print(f"F_VERSION={shlex.quote(s('version','9.0'))}")
print(f"F_BUILDTYPE={shlex.quote(s('buildtype','COMMUNITY'))}")
print(f"F_DEVICE={shlex.quote(s('device','haydn'))}")
print(f"F_MAINTAINER={shlex.quote(s('maintainer','Kishor TH'))}")
print(f"F_TELEGRAM={shlex.quote(s('telegram','https://t.me/HI_JACK_U'))}")
print(f"F_DATE={shlex.quote(date_str)}")
print(f"F_DATE_HUMAN={shlex.quote(human)}")
print(f"F_SIZE={shlex.quote(fmt_size(s('size')))}")
print(f"F_MD5={shlex.quote(s('md5'))}")
print(f"F_SHA256={shlex.quote(s('sha256'))}")
PY
)"
elif command -v jq >/dev/null 2>&1; then
  F_FILENAME=$(jq -r '.response[0].filename' "$JSON")
  F_DOWNLOAD=$(jq -r '.response[0].download // .response[0].url' "$JSON")
  F_VERSION=$(jq -r '.response[0].version // "9.0"' "$JSON")
  F_BUILDTYPE=$(jq -r '.response[0].buildtype // "COMMUNITY"' "$JSON")
  F_DEVICE=$(jq -r '.response[0].device // "haydn"' "$JSON")
  F_MAINTAINER=$(jq -r '.response[0].maintainer // "Kishor TH"' "$JSON")
  F_TELEGRAM=$(jq -r '.response[0].telegram // "https://t.me/HI_JACK_U"' "$JSON")
  TS=$(jq -r '.response[0].timestamp // .response[0].datetime' "$JSON")
  F_DATE=$(date -d "@$TS" +"%d/%m/%y" 2>/dev/null || echo "?")
  F_DATE_HUMAN=$(date -d "@$TS" +"%Y-%m-%d %H:%M UTC" 2>/dev/null || echo "$F_DATE")
  SZ=$(jq -r '.response[0].size' "$JSON")
  F_SIZE=$(awk "BEGIN {print $SZ/1024/1024/1024 \" GB\"}")
  F_MD5=$(jq -r '.response[0].md5' "$JSON")
  F_SHA256=$(jq -r '.response[0].sha256' "$JSON")
else
  echo "❌ Need python3 or jq" >&2; exit 1
fi

# Convert Telegram URL to @handle
TG_HANDLE=$(echo "$F_TELEGRAM" | sed -E 's|https://t\.me/||; s|http://t\.me/||; s|.*@|@|')
[[ "$TG_HANDLE" != @* ]] && TG_HANDLE="@$TG_HANDLE"

# --- Build changelog bullets ---
# Extract lines after "Changelog:" until end, convert "- " / "* " to "• "
NOTES=""
if [[ -n "$CHANGELOG" && -f "$CHANGELOG" ]]; then
  NOTES=$(awk '/^Changelog:/{flag=1;next} flag' "$CHANGELOG" | sed -E 's/^[-*] /• /; s/^\* /  • /; s/^-/•/' | sed 's/[[:space:]]*$//' | grep -v '^$' || true)
  # If awk found nothing, fallback to whole file body
  if [[ -z "$NOTES" ]]; then
    NOTES=$(sed -E 's/^[-*] /• /' "$CHANGELOG" | grep -v '^====' | grep -v '^RisingOS' | grep -v '^Maintainer' | grep -v '^Build Date' | grep -v '^$')
  fi
fi

# --- Placeholders you can edit per-build ---
# Edit these links once, reuse every time:
CHANGELOG_URL="https://github.com/kichukic/Rising_OTA/blob/main/changelogs/haydn.txt"
FLASHING_URL="https://github.com/kichukic/Rising_OTA/blob/main/FLASHING.md"
SUPPORT_URL="https://t.me/HI_JACK_U"             # TODO: replace with your support group, e.g. https://t.me/Mi11XProOfficial
SUPPORT_LABEL="Support Group"                    # or "Join: @YourChannel"

# Optional manual notes (appended before changelog if you set them):
# MANUAL_NOTES="• October Security Patch\n• Basic Integrity by default"
MANUAL_NOTES=""

# --- Output template (mirrors your reference image) ---
OUTPUT=$(cat <<EOF
#risingos #haydn #a17
RisingOS-v$F_VERSION [$F_BUILDTYPE] | $F_DEVICE | Unofficial
Updated: $F_DATE'
Build: $F_FILENAME
Size: $F_SIZE

▪️ Download
$F_DOWNLOAD

▪️ Changelogs
$CHANGELOG_URL

▪️ Flashing Instructions
$FLASHING_URL

▪️ $SUPPORT_LABEL
$SUPPORT_URL

Notes:
${MANUAL_NOTES:+$MANUAL_NOTES
}$NOTES

What's different:
• See changelogs above — latest build $F_FILENAME

Credits:
• Thanks to all developers.

Bugs:
• Tell me if any :)

By: $TG_HANDLE
Follow: $SUPPORT_URL
Join: $SUPPORT_URL

MD5: $F_MD5
SHA256: $F_SHA256
EOF
)

if [[ -n "$OUT" ]]; then
  echo "$OUTPUT" > "$OUT"
  echo "✅ Written to $OUT"
else
  echo "$OUTPUT"
  echo
  echo "---" >&2
  echo "💡 Tip: ./make_release_announce.sh --out post.txt  to save, or pipe to clipboard: ./make_release_announce.sh | xclip -selection clipboard" >&2
fi
