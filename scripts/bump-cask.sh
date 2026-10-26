#!/usr/bin/env bash
# Update a cask's version and sha256 to the latest GitHub release of its app.
#
# Usage: scripts/bump-cask.sh <cask file> <owner/repo>
#
# The DMG URL comes from the cask's own `url` line with #{version} filled in, and the
# release must carry `<dmg>.sha256` next to the DMG. The script downloads the DMG and
# refuses to write a hash that does not match that file.
#
# Prints the new version and writes `version=` and `changed=` to $GITHUB_OUTPUT when set.
# Exits 0 without changes when the cask is current or ahead of the release.
set -euo pipefail

cask=$1
repo=$2

out() { [[ -n ${GITHUB_OUTPUT:-} ]] && echo "$1" >> "$GITHUB_OUTPUT"; return 0; }

tag=$(gh api "repos/$repo/releases/latest" --jq .tag_name)
latest=${tag#v}
if [[ ! $latest =~ ^[0-9]+(\.[0-9]+)*$ ]]; then
  echo "latest release tag '$tag' is not a plain version" >&2
  exit 1
fi

current=$(sed -n 's/^  version "\(.*\)"$/\1/p' "$cask")
if [[ -z $current ]]; then
  echo "no version line in $cask" >&2
  exit 1
fi

if [[ $current == "$latest" ]]; then
  echo "$cask is current ($current)"
  out changed=false
  exit 0
fi
if [[ $(printf '%s\n%s\n' "$current" "$latest" | sort -V | tail -1) == "$current" ]]; then
  echo "$cask ($current) is ahead of the latest release ($latest); leaving it" >&2
  out changed=false
  exit 0
fi

url_template=$(sed -n 's/^  url "\([^"]*\)".*/\1/p' "$cask")
url=${url_template//'#{version}'/$latest}
if [[ -z $url_template || $url == *'#{'* ]]; then
  echo "cannot build the download URL from '$url_template'" >&2
  exit 1
fi

tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT
curl -fsSL --retry 3 -o "$tmp/app.dmg" "$url"
curl -fsSL --retry 3 -o "$tmp/app.sha256" "$url.sha256"

published=$(awk '{print $1; exit}' "$tmp/app.sha256")
actual=$(shasum -a 256 "$tmp/app.dmg" | awk '{print $1}')
if [[ ! $published =~ ^[0-9a-f]{64}$ || $published != "$actual" ]]; then
  echo "sha256 mismatch for $url: published '$published', downloaded '$actual'" >&2
  exit 1
fi

perl -pi -e "s/^  version \"\Q$current\E\"\$/  version \"$latest\"/; s/^  sha256 \"[0-9a-f]{64}\"\$/  sha256 \"$actual\"/" "$cask"
if ! grep -qx "  version \"$latest\"" "$cask" || ! grep -qx "  sha256 \"$actual\"" "$cask"; then
  echo "failed to rewrite $cask" >&2
  exit 1
fi
ruby -c "$cask" > /dev/null

echo "$cask: $current -> $latest ($actual)"
out "version=$latest"
out changed=true
