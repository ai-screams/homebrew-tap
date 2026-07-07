cask "azimuth" do
  version "1.4.0"
  sha256 "a4a2bef49ac412f37b7bea83fabb1833c7271e1a7bfffe39c3274f724d47d53c"

  url "https://github.com/ai-screams/Azimuth/releases/download/v#{version}/Azimuth-#{version}.dmg",
      verified: "github.com/ai-screams/Azimuth/"
  name "Azimuth"
  desc "Keyboard-driven window manager for macOS"
  homepage "https://ai-screams.github.io/Azimuth/"

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
