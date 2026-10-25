cask "azimuth" do
  version "2.0.1"
  sha256 "3c7e5193e68c4e77a7fa7af62891c006b817535c97a3b7baf72f8ab7fc7b8192"

  url "https://github.com/ai-screams/Azimuth/releases/download/v#{version}/Azimuth-#{version}.dmg",
      verified: "github.com/ai-screams/Azimuth/"
  name "Azimuth"
  desc "Keyboard-driven window manager for macOS"
  homepage "https://ai-scream.ai/Azimuth/"

  # Azimuth updates itself via Sparkle — let it, so brew doesn't fight the in-app updater.
  auto_updates true
  depends_on macos: :sonoma # safe floor; the app's real minimum (macOS 14 / Sonoma) is enforced at launch

  app "Azimuth.app"

  zap trash: [
    "~/Library/Preferences/com.aiscream.Azimuth.plist",
    "~/Library/Caches/com.aiscream.Azimuth",
    "~/Library/HTTPStorages/com.aiscream.Azimuth",
  ]
end
