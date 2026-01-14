#!/bin/bash

source "$ENV/src/utils.sh"
source "$ENV/src/commands.sh"

ENV_FILE="$ENV/.env"
source "$ENV_FILE"

RED=''
GREEN=''
YELLOW=''
CYAN=''
NC=''
if [[ $COLORS == true ]]; then
  RED='\033[0;31m'
  GREEN='\033[0;32m'
  YELLOW='\033[0;33m'
  CYAN='\033[0;36m'
  NC='\033[0m' # No Color (reset)
fi

if [[ "$#" -eq 0 ]]; then
  init_command default
elif [[ "$#" -gt 2 ]]; then
  echo -e "${RED}Too many arguments! Usage: tmtr [label] [command]${NC}"
elif [[ "$#" -eq 2 ]]; then
  if ! label_exist $1; then
    echo -e "${RED}Such label doesn't exist!${NC}"
  else
    if ! parse_command $2 $1; then
      echo -e "${RED}Unknown command $2${NC}"
    fi
  fi
else
  if ! parse_command $1; then
    if [[ "$1" == *_PAUSED ]]; then
      echo -e "${RED}You cannot end your label with '_PAUSED' since this is reserved ending!"
    elif [[ "$1" == *-* ]]; then
      echo -e "${RED}Currently '-' is not supported in label names!"
    else 
      init_command $1
    fi
  fi
fi

