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

# TODO: Make it support labels (Ex.: tmtr ls, tmtr ir990 start)

if [[ "$#" -eq 0 ]]; then
  init_command
fi

case "$1" in
  stop|s)
    stop_command
    ;;
  restart|rst)
    restart_command
    ;;
  pause|p)
    pause_command
    ;;
  resume|r)
    resume_command
    ;;
  status|stat)
    status_command
    ;;
  log|l)
    log_command
    ;;
  *)
    echo -e "${RED} unknown command $1${NC}"
    ;;
esac

