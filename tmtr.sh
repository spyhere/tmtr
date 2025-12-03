#!/bin/bash

source "$ENV/utils.sh"
source "$ENV/commands.sh"

ENV_FILE="$ENV/.env"
source "$ENV_FILE"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color (reset)

# Time track utility
# TODO: Make it support labels (Ex.: tmtr ls, tmtr ir990 start)

if [[ "$#" -eq 0 ]]; then
  init_command
fi

case "$1" in
  stop)
    stop_command
    ;;
  restart)
    restart_command
    ;;
  pause)
    pause_command
    ;;
  resume)
    resume_command
    ;;
  status)
    status_command
    ;;
  log)
    log_command
    ;;
  *)
    echo -e "${RED} unknown command $1${NC}"
    ;;
esac

