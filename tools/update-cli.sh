#!/bin/sh
# SPDX-FileCopyrightText: 2026 Denis Robel
# SPDX-License-Identifier: GPL-3.0-or-later
# Downloads the openscq30 CLI (Linux arm64) from the official OpenSCQ30
# GitHub releases, verifies its GPG signature and installs it to bin/aarch64/.
#
#   tools/update-cli.sh            # latest release
#   tools/update-cli.sh v2.12.0    # specific release
#
# Needs: curl, gpg. Does not use the GitHub API (no rate limit).
set -eu

REPO="Oppzippy/OpenSCQ30"
ASSET="openscq30-cli-linux-arm64"
# Release signing key of the OpenSCQ30 developer (Kyle Scheuing), as shown
# on the release pages ("GPG key ID: 72CE2DDCDA12B906").
FINGERPRINT="58A1B3E704817B8778CBB86B72CE2DDCDA12B906"
DIR="$(cd "$(dirname "$0")/.." && pwd)/bin/aarch64"

TAG="${1:-latest}"
if [ "$TAG" = "latest" ]; then
    # https://github.com/<repo>/releases/latest redirects to .../releases/tag/<tag>
    TAG="$(curl -fsSI "https://github.com/$REPO/releases/latest" \
           | tr -d '\r' | sed -n 's|^[Ll]ocation: .*/releases/tag/||p' | tail -n 1)"
    [ -n "$TAG" ] || { echo "Could not determine the latest release" >&2; exit 1; }
fi

TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT
BASE="https://github.com/$REPO/releases/download/$TAG"

echo "Downloading $ASSET $TAG"
curl -fsSL "$BASE/$ASSET" -o "$TMP/openscq30"
curl -fsSL "$BASE/$ASSET.sig" -o "$TMP/openscq30.sig"

echo "Verifying GPG signature"
export GNUPGHOME="$TMP/gnupg"
mkdir -m 700 "$GNUPGHOME"
curl -fsSL "https://github.com/Oppzippy.gpg" -o "$TMP/key.asc"
gpg --batch --quiet --import "$TMP/key.asc" 2>/dev/null
if ! gpg --batch --status-fd 1 --verify "$TMP/openscq30.sig" "$TMP/openscq30" 2>/dev/null \
        | grep -q "VALIDSIG $FINGERPRINT"; then
    echo "ERROR: signature is not valid or not made by $FINGERPRINT" >&2
    exit 1
fi
echo "Good signature from $FINGERPRINT"

mkdir -p "$DIR"
install -m 755 "$TMP/openscq30" "$DIR/openscq30"
echo "$TAG" > "$DIR/VERSION"
echo "Installed openscq30 $TAG to $DIR/openscq30"
echo "Now bump Version in rpm/harbour-sailscq.spec and run: sfdk build"
