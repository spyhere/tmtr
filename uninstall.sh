#!/bin/sh

set -e
read -n 1 -r -p "Are you sure you want to uninstall tmtr? y/n" ANSWER
echo

if [[ $ANSWER == "y" || $ANSWER == "Y" ]]; then
  echo "Uninstalling..."
  REPO_DIR="$(cd "$(dirname ${BASH_SOURCE[0]})" && pwd)"
  REPO_NAME="$(basename "$REPO_DIR")"
  WRAPPER_LINK="$HOME/.local/bin/tmtr"

  cd "$REPO_DIR/.."
  rm -rf "$REPO_DIR"

  if [[ -L "$WRAPPER_LINK" ]]; then
    rm "$WRAPPER_LINK"
    echo "Removed wrapper $WRAPPER_LINK"
  else
    echo "No wrapper has been found"
  fi

  cd "$HOME"
  echo "tmtr has been uninstalled from your machine"
  echo "You have been moved to home directory"
else
  echo "Aborting."
fi


