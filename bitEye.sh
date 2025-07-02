#!/bin/bash
set -e

FALLBACK="Appearance/Themes/_fallback";         SCRIPTS="$FALLBACK/Scripts"

MODULES="Modules";          BGANIMATIONS="$FALLBACK/BGAnimations"


# Check modules folder.

if [ -d "$FALLBACK/$MODULES" ]; then MODULES="$FALLBACK/$MODULES"; fi


# Clone repository.

REPOSITORY="https://github.com/EngineMachiner/bitEye.git"

git clone "$REPOSITORY" "$MODULES/bitEye"


# Add to init script.

echo "Checking initialization script...";           TAPLUA="$SCRIPTS/tapLua.lua"

echo "LoadModule(\"bitEye/bitEye.lua\")" | { grep -xFv -f "$TAPLUA" >> "$TAPLUA" || true; }

echo "Done."


# Open editor to add actors.

cat << EOF

Add the actors to each screen layer so they are loaded:

bitEye.actor("OptionRow") -- ScreenMiniMenuBackgroundChange
bitEye.actor("EditNoteField") -- ScreenEdit

EOF

read -p "Nano will open. Press any key to continue."

sudo nano "$BGANIMATIONS/ScreenMiniMenuBackgroundChange overlay.lua"
sudo nano "$BGANIMATIONS/ScreenEdit overlay.lua"
