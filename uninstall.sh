#!/bin/sh

set -e
read -n 1 -r -p "Are you sure you want to uninstall tmtr? y/n" ANSWER
echo

if [[ $ANSWER == "y" || $ANSWER == "Y" ]]; then
  echo "Uninstalling..."
  rm "$HOME/.local/bin/tmtr"
  cd .. && rm -rf tmtr
  echo "tmtr has been uninstalled from your machine."
else
  echo "Aborting."
fi


