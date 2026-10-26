# Azimuth Homebrew Tap

Install [Azimuth](https://github.com/ai-screams/Azimuth) — a keyboard-driven window manager for macOS — via Homebrew.

```sh
brew install --cask ai-screams/tap/azimuth
```

or:

```sh
brew tap ai-screams/tap
brew install --cask azimuth
```

The DMG is Developer ID–signed and Apple-notarized. After install, enable Azimuth in
**System Settings → Privacy & Security → Accessibility**.

Updates are handled in-app by [Sparkle](https://sparkle-project.org) (`auto_updates true`), so
`brew upgrade` won't fight the built-in updater — Azimuth keeps itself current.

- App & releases: https://github.com/ai-screams/Azimuth
- Homepage: https://ai-scream.ai/Azimuth/

## Maintenance

`.github/workflows/bump-casks.yml` checks each app's latest GitHub release every six hours (or on
demand from the Actions tab) and opens a PR that updates the cask's `version` and `sha256`. The
hash is taken from the release's `.dmg.sha256` file and checked against the downloaded DMG. To
add a cask, add a `matrix.include` entry.
