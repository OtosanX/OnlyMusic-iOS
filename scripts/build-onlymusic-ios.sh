#!/usr/bin/env bash
set -euo pipefail
root="$(cd "$(dirname "$0")/.." && pwd)"
cd "$root"
if [[ "$(uname -s)" != Darwin ]]; then
  echo 'OnlyMusic iOS needs a macOS build runner with Xcode. Use the Build OnlyMusic iPhone workflow.' >&2
  exit 1
fi
for tool in xcodebuild xcodegen java cargo cmake python3; do
  command -v "$tool" >/dev/null || { echo "Missing build tool: $tool" >&2; exit 1; }
done
mkdir -p build/checks build/release
xcrun swiftc -parse-as-library AppleApp/Sources/App/OnlyMusicDefaults.swift \
  scripts/onlymusic-defaults-check.swift -o build/checks/onlymusic-defaults
build/checks/onlymusic-defaults
bash scripts/check-pages.sh
CONFIG=release bash scripts/build-shared-framework.sh
NATIVE_TARGETS="aarch64-apple-darwin aarch64-apple-ios" bash scripts/build-native-core.sh
xcodegen generate --spec AppleApp/project.yml
version="$(sed -n 's/.*MARKETING_VERSION: "\([^"]*\)".*/\1/p' AppleApp/project.yml | head -1)"
bash scripts/package-ios-ipa.sh "$version" --output-dir build/release --overwrite
python3 scripts/check-onlymusic-package.py build/release/*-ios-unsigned.ipa
cp build/release/*-ios-unsigned.ipa build/OnlyMusic.ipa
shasum -a 256 build/OnlyMusic.ipa > build/OnlyMusic.ipa.sha256
echo 'Created build/OnlyMusic.ipa. Sign it locally with your own Apple ID to install.'
