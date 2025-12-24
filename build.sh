#!/bin/bash

# Build script for Rafaworld Mod
# Separates resource pack and behavior pack into proper structure

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
OUTPUT_DIR="$SCRIPT_DIR/output"
BP_DIR="$OUTPUT_DIR/rafaworld_mod_BP"
RP_DIR="$OUTPUT_DIR/rafaworld_mod_RP"

# UUIDs for the packs
BP_UUID="b1f2c3d4-e5f6-7890-abcd-ef1234567890"
BP_MODULE_UUID="c2d3e4f5-a6b7-8901-bcde-f12345678901"
BP_SCRIPT_UUID="e4f5a6b7-c8d9-0123-defa-234567890123"
RP_UUID="d3e4f5a6-b7c8-9012-cdef-123456789012"
RP_MODULE_UUID="f5a6b7c8-d9e0-1234-efab-345678901234"

# Read version from .version file
VERSION_FILE="$SCRIPT_DIR/.version"
if [ -f "$VERSION_FILE" ]; then
    VERSION=$(cat "$VERSION_FILE" | tr -d '[:space:]')
else
    echo "Warning: .version file not found, using default 1.0.0"
    VERSION="1.0.0"
fi

# Parse version into array format [major, minor, patch]
IFS='.' read -r VERSION_MAJOR VERSION_MINOR VERSION_PATCH <<< "$VERSION"
VERSION_ARRAY="$VERSION_MAJOR, $VERSION_MINOR, $VERSION_PATCH"

echo "Building Rafaworld Mod..."
echo "Version: $VERSION"
echo "========================="

# Clean and create output directories
rm -rf "$OUTPUT_DIR"
mkdir -p "$BP_DIR"
mkdir -p "$RP_DIR"

# === BEHAVIOR PACK ===
echo "Creating Behavior Pack..."

# Copy behavior pack files
cp -r "$SCRIPT_DIR/items" "$BP_DIR/" 2>/dev/null || true
cp -r "$SCRIPT_DIR/scripts" "$BP_DIR/" 2>/dev/null || true
cp -r "$SCRIPT_DIR/entities" "$BP_DIR/" 2>/dev/null || true

# Create behavior pack manifest
cat > "$BP_DIR/manifest.json" << EOF
{
	"format_version": 2,
	"header": {
		"name": "Rafaworld Mod",
		"description": "Custom items and features for Rafaworld",
		"uuid": "$BP_UUID",
		"version": [$VERSION_ARRAY],
		"min_engine_version": [1, 21, 40]
	},
	"modules": [
		{
			"type": "data",
			"uuid": "$BP_MODULE_UUID",
			"version": [1, 0, 0]
		},
		{
			"type": "script",
			"language": "javascript",
			"uuid": "$BP_SCRIPT_UUID",
			"version": [1, 0, 0],
			"entry": "scripts/main.js"
		}
	],
	"dependencies": [
		{
			"module_name": "@minecraft/server",
			"version": "2.4.0"
		},
		{
			"uuid": "$RP_UUID",
			"version": [$VERSION_ARRAY]
		}
	]
}
EOF

# === RESOURCE PACK ===
echo "Creating Resource Pack..."

# Copy resource pack files
cp -r "$SCRIPT_DIR/textures" "$RP_DIR/" 2>/dev/null || true
cp -r "$SCRIPT_DIR/models" "$RP_DIR/" 2>/dev/null || true
cp -r "$SCRIPT_DIR/attachables" "$RP_DIR/" 2>/dev/null || true
cp -r "$SCRIPT_DIR/animations" "$RP_DIR/" 2>/dev/null || true
cp -r "$SCRIPT_DIR/texts" "$RP_DIR/" 2>/dev/null || true
cp -r "$SCRIPT_DIR/entity" "$RP_DIR/" 2>/dev/null || true

# Create resource pack manifest
cat > "$RP_DIR/manifest.json" << EOF
{
	"format_version": 2,
	"header": {
		"name": "Rafaworld Mod Resources",
		"description": "Resources for Rafaworld Mod",
		"uuid": "$RP_UUID",
		"version": [$VERSION_ARRAY],
		"min_engine_version": [1, 21, 40]
	},
	"modules": [
		{
			"type": "resources",
			"uuid": "$RP_MODULE_UUID",
			"version": [1, 0, 0]
		}
	]
}
EOF

# Clean up .DS_Store files
find "$OUTPUT_DIR" -name ".DS_Store" -delete 2>/dev/null || true

echo ""
echo "Build complete!"
echo "==============="
echo "Output directory: $OUTPUT_DIR"
echo "  - Behavior Pack: rafaworld_mod_BP/"
echo "  - Resource Pack: rafaworld_mod_RP/"
echo ""
echo "To install:"
echo "  1. Copy rafaworld_mod_BP to: com.mojang/development_behavior_packs/"
echo "  2. Copy rafaworld_mod_RP to: com.mojang/development_resource_packs/"
echo ""
echo "Or create .mcpack files:"
echo "  cd $OUTPUT_DIR"
echo "  zip -r rafaworld_mod_BP.mcpack rafaworld_mod_BP"
echo "  zip -r rafaworld_mod_RP.mcpack rafaworld_mod_RP"
