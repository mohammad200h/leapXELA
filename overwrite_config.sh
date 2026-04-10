#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
PARENT_DIR="$(basename -- "$(dirname -- "$SCRIPT_DIR")")"
GRANDPARENT_DIR="$(basename -- "$(dirname -- "$(dirname -- "$SCRIPT_DIR")")")"

# Check this script lives at .../_src/manipulation/leapXELA/
if [ "$PARENT_DIR" != "manipulation" ] || [ "$GRANDPARENT_DIR" != "_src" ]; then
    echo "Error: overwrite_config.sh must be located at mujoco_playground/_src/manipulation/leapXELA/"
    exit 1
fi

if [ ! -d "$SCRIPT_DIR/setup_files" ]; then
    echo "Error: missing setup_files/ next to overwrite_config.sh"
    exit 1
fi

SRC_PARAMS="$SCRIPT_DIR/setup_files/manipulation_params.py"
SRC_INIT="$SCRIPT_DIR/setup_files/__init__.py"
DEST_PARAMS="$SCRIPT_DIR/../../../config/manipulation_params.py"
DEST_INIT="$SCRIPT_DIR/../__init__.py"

if [ ! -f "$SRC_PARAMS" ] || [ ! -f "$SRC_INIT" ]; then
    echo "Error: expected files not found under $SCRIPT_DIR/setup_files/"
    exit 1
fi

if [ ! -d "$(dirname -- "$DEST_PARAMS")" ]; then
    echo "Error: destination directory missing: $(dirname -- "$DEST_PARAMS")"
    exit 1
fi

FORCE=0
if [ "${1:-}" = "--force" ]; then
    FORCE=1
fi

echo "About to overwrite:"
echo "  - $DEST_PARAMS"
echo "    from $SRC_PARAMS"
echo "  - $DEST_INIT"
echo "    from $SRC_INIT"
echo

if [ "$FORCE" -ne 1 ]; then
    read -r -p "Type 'yes' to continue: " CONFIRM
    if [ "$CONFIRM" != "yes" ]; then
        echo "Aborted."
        exit 1
    fi
fi

cp "$SRC_PARAMS" "$DEST_PARAMS"
cp "$SRC_INIT" "$DEST_INIT"
echo "Done."