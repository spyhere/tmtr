#!/bin/sh

set -e
touch .env

REPO_DIR=$(cd $(dirname "${BASH_SOURCE[0]}") && pwd)
ORIGINAL_SCRIPT="$REPO_DIR/tmtr.sh"
WRAPPER_LINKED="$HOME/.local/bin/tmtr"

cat > $WRAPPER_LINKED << EOF
#!/bin/sh
ENV_FILE="$REPO_DIR/.env"
export ENV_FILE
source "\$ENV_FILE"
bash "$ORIGINAL_SCRIPT" "\$@"
EOF

chmod +x "$WRAPPER_LINKED"

echo "Successfuly created symlink for tmtr at $WRAPPER_LINKED"
echo "It points to $ORIGINAL_SCRIPT"

