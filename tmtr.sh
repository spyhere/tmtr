#!/bin/sh

ENV_FILE="$HOME/Projects/tmtr/tmtr.env"
source "$ENV_FILE"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color (reset)

# Time track utility
# TODO: Make it support labels (Ex.: tmtr ls, tmtr ir990 start)
# tmtr
# tmtr stop
# tmtr restart
# tmtr pause
# tmtr continue
# tmtr status

get_elapsed_seconds() {
  local paused_time=${TIME_TRACK_PAUSED:-0}
  local curr_sec=$(date "+%s")
  echo $((curr_sec - $TIME_TRACK_START + paused_time))
}

format_time_from_seconds() {
  local seconds=$1
  local minutes=$((seconds / 60))
  if [[ $seconds -lt 60 ]]; then
    echo "${seconds}s"
  elif [[ $minutes -lt 60 ]]; then
    echo "${minutes}m $((seconds % 60))s"
  else
    hours=$(( minutes / 60 ))
    minutes=$(( minutes % 60 ))
    seconds=$(( seconds % 60 ))
    echo "${hours}h ${minutes}m ${seconds}s"
  fi
}

if [[ "$#" -eq 0 ]]; then
  if [[ -n "${TIME_TRACK_START+x}" ]]; then
    echo "${RED}Error: Timetrack is already tracking! Use 'restart' to restart it.${NC}"
    exit 1
  fi
 echo "export TIME_TRACK_START=$(date "+%s")" > "$ENV_FILE"
  echo "${GREEN}Timetrack started tracking${NC}"
  exit 0
fi

if [[ "$1" = "stop" ]]; then
  if [[ -z "${TIME_TRACK_START+x}" && -z "${TIME_TRACK_PAUSED+x}" ]]; then
    echo "${RED}Error: cannot stop when no tracking has been started.${NC}"
    exit 1
  fi
  elapsed_sec=0
  if [[ -n "${TIME_TRACK_START+x}" ]]; then
    elapsed_sec=$(get_elapsed_seconds)
  fi
  elapsed_sec=$((${TIME_TRACK_PAUSED:-0} + $elapsed_sec))
  echo "" > "$ENV_FILE"
  echo "${GREEN}Timetrack stopped: ${CYAN}$(format_time_from_seconds $elapsed_sec)${NC}"
  exit 0
fi

if [ "$1" = "restart" ]; then
  echo "export TIME_TRACK_START=$(date "+%s")" > "$ENV_FILE"
  unset TIME_TRACK_PAUSED
  echo "${GREEN}Timetrack is beeing restarted.${NC}"
  exit 0
fi

if [ "$1" = "pause" ]; then
  if [[ -z "${TIME_TRACK_START+x}" ]]; then
    echo "${RED}Error: cannot pause when no tracking has been started or it's already paused!${NC}"
    exit 1
  fi
  curr_sec=$(date "+%s")
  paused_sec=${TIME_TRACK_PAUSED:-0}
  elapsed_sec=$((curr_sec - $TIME_TRACK_START + paused_sec))
  echo "export TIME_TRACK_PAUSED=$elapsed_sec" > "$ENV_FILE"
  echo "${GREEN}Timetrack is beeing paused:${CYAN} $(format_time_from_seconds $elapsed_sec)${NC}"
  exit 0
fi

if [[ "$1" = "continue" ]]; then
  if [[ -n "${TIME_TRACK_PAUSED+x}" ]]; then
    echo "export TIME_TRACK_START=$(date "+%s")" >> "$ENV_FILE"
    echo "${GREEN}Timetrack has continued tracking.${NC}"
    exit 0
  else
    echo "${RED}Error: Cannot continue when no tracking has been paused.${NC}"
    exit 1
  fi
fi

if [[ "$1" = "status" ]]; then
  if [[ -n "${TIME_TRACK_START+x}" ]]; then
    echo "${YELLOW}Timetrack is tracking:${CYAN} $(format_time_from_seconds $(get_elapsed_seconds))${NC}"
  elif [[ -n "${TIME_TRACK_PAUSED+x}" ]]; then
    echo "${YELLOW}Timetrack is paused:${CYAN} $(format_time_from_seconds $TIME_TRACK_PAUSED)${NC}"
  else
    echo "${YELLOW}Timetrack is not tracking.${NC}"
  fi
  exit 0
fi

echo "${RED} unknown command $1${NC}"

