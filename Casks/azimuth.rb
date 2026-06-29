cask "azimuth" do
  version "1.2.0"
  sha256 "cfaff66a740bb1d53b3a6236ad465b280112ccecd313a6181c273beefca428bd"

  url "https://github.com/ai-screams/Azimuth/releases/download/v#{version}/Azimuth-#{version}.dmg",
      verified: "github.com/ai-screams/Azimuth/"
  name "Azimuth"
  desc "Keyboard-driven window manager for macOS"
  homepage "https://ai-screams.github.io/Azimuth/"

  # Azimuth updates itself via Sparkle — let it, so brew doesn't fight the in-app updater.
  auto_updates true
  depends_on macos: :sequoia # safe floor; the app enforces its real minimum (macOS 26.3) at launch

  app "Azimuth.app"

  zap trash: [
    "~/Library/Preferences/com.aiscream.Azimuth.plist",
    "~/Library/Caches/com.aiscream.Azimuth",
    "~/Library/HTTPStorages/com.aiscream.Azimuth",
  ]
end
