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

# Add PATH ~/.local/bin to .zshrc if it is not there already
BIN_DIR="$HOME/.local/bin"
if ! grep -qF "\$HOME/.local/bin" "$HOME/.zshrc"; then
  cat >> "$HOME/.zshrc" << EOF
# Now scripts from ~/.local/bin are accessible
export PATH="\$HOME/.local/bin:\$PATH"
EOF
  echo "Added ~/.local/bin to PATH. Restart your shell or run: source ~/.zshrc"
fi

# Completions
COMPLETIONS="$REPO_DIR/src/completions.zsh.inc"
grep -q "tmtr completions" "$HOME/.zshrc" || cat >> "$HOME/.zshrc" << EOF

# >>> tmtr completions >>>
if [ -f "$COMPLETIONS" ]; then . "$COMPLETIONS"; fi
# <<< tmtr completions <<<

EOF
perl -i -pe 's{\@ENV\@}{'"$REPO_DIR"'}g' src/completions.zsh.inc
echo "Added completions to .zshrc"
echo "You should restart your terminal to make it work"

