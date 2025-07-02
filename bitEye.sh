#!/bin/bash
set -e

FALLBACK="Themes/_fallback";         MODULES="Modules"

if [ -d "Appearance" ]; then

    FALLBACK="Appearance/$FALLBACK";        MODULES="$FALLBACK/$MODULES"

fi

SCRIPTS="$FALLBACK/Scripts";        BGANIMATIONS="$FALLBACK/BGAnimations"


# Clone repository.

REPOSITORY="https://github.com/EngineMachiner/bitEye.git"

git clone "$REPOSITORY" "$MODULES/bitEye"


# Add to init script.

echo "Checking initialization script...";           TAPLUA="$SCRIPTS/tapLua.lua"

echo "LoadModule(\"bitEye/bitEye.lua\")" | { grep -xFv -f "$TAPLUA" >> "$TAPLUA" || true; }

echo "Done."


# Open editor to add actors.

cat << EOF

Add the actors to each screen layer:

bitEye.actor("OptionRow") -- ScreenMiniMenuBackgroundChange
bitEye.actor("EditNoteField") -- ScreenEdit

EOF

read -p "Nano will open. Press any key to continue."

sudo nano "$BGANIMATIONS/ScreenMiniMenuBackgroundChange overlay.lua"
sudo nano "$BGANIMATIONS/ScreenEdit overlay.lua"
