#!/bin/sh

tmp="$(mktemp -d /tmp/thunderstore-build.XXXXXX)"
function cleanup() { rm -rf "${tmp}"; exit; }
trap cleanup exit

magick "assets/1x/Icon.png" -filter point -resize 753% "$tmp/icon.png"

cp -r assets "$tmp/"
rm "$tmp/assets/upscale.bat"
rm "$tmp/assets/upscale.sh"
cp -r localization "$tmp/"
cp -r lovely "$tmp/"
cp -r src "$tmp/"
cp LICENSE "$tmp/"
cp manifest.json "$tmp/smods.json"
cp README.md "$tmp/"
cp PHILOSOPHY.md "$tmp/"
jq -r '{ "name": .name, "description": .description, "version_number": .version, "website_url": "https://github.com/BakersDozenBagels/BalatroBakery/", "dependencies": .ts_dependencies }' manifest.json > "$tmp/manifest.json"

if [ -f package.zip ]; then
    rm package.zip
fi

wd="$(pwd)"
cd "$tmp"

zip -r "$wd/package.zip" *
