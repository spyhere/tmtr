#!/usr/bin/env bash

touch .env

read -n 1 -r -p "Do you want colors in outputs? y/n" ANSWER
echo

COLORS=false
if [[ $ANSWER == "y" || $ANSWER == "Y" ]]; then
  COLORS=true
fi

REPO_DIR=$(cd $(dirname "${BASH_SOURCE[0]}") && pwd)
ORIGINAL_SCRIPT="$REPO_DIR/src/main.sh"
WRAPPER_LINKED="$HOME/.local/bin/tmtr"

mkdir -p "$HOME/.local/bin"

# Create a wrapper script
cat > "$WRAPPER_LINKED" << EOF
#!/bin/sh
export ENV="$REPO_DIR"
export COLORS="$COLORS"
exec bash "$ORIGINAL_SCRIPT" "\$@"
EOF

chmod +x "$WRAPPER_LINKED"

echo "Successfuly created wrapper for tmtr at $WRAPPER_LINKED"
echo "It points to $ORIGINAL_SCRIPT"

