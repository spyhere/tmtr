#!/bin/sh

set -e
read -n 1 -r -p "Are you sure you want to uninstall tmtr? y/n " ANSWER
echo

if [[ $ANSWER == "y" || $ANSWER == "Y" ]]; then
  echo "Uninstalling..."
  REPO_DIR="$(cd "$(dirname ${BASH_SOURCE[0]})" && pwd)"
  REPO_NAME="$(basename "$REPO_DIR")"
  WRAPPER_LINK="$HOME/.local/bin/tmtr"

  cd "$REPO_DIR/.."
  rm -rf "$REPO_DIR"

  if [[ -f "$WRAPPER_LINK" ]]; then
    rm "$WRAPPER_LINK"
    echo "Removed wrapper $WRAPPER_LINK"
  else
    echo "No wrapper has been found"
  fi

  echo "tmtr has been uninstalled from your machine"
  echo "You are now in the non-existent directory. Use cd ~ to get to home"
else
  echo "Aborting."
fi

# Remove completions from .zshrc
perl -0777 -i.bak -pe '
  s{
    \n?
    \#\ >>>\ tmtr\ completions\ >>>.*?
    \#\ <<<\ tmtr\ completions\ <<<
    \n?
  }{}gsx
' "$HOME/.zshrc"


