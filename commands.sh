init_command() {
  if [[ -n "${TIME_TRACK_START+x}" || -n "${TIME_TRACK_PAUSED+x}" ]]; then
    echo -e "${RED}Error: Timetrack is already tracking! Use 'restart' to restart it.${CYAN} $(format_time_from_seconds $(get_elapsed_seconds))${NC}"
    exit 1
  fi
  echo "export TIME_TRACK_START=$(date "+%s")" > "$ENV_FILE"
  echo -e "${GREEN}Timetrack started tracking${NC}"
  exit 0
}

stop_command() {
  if [[ -z "${TIME_TRACK_START+x}" && -z "${TIME_TRACK_PAUSED+x}" ]]; then
    echo -e "${RED}Error: Cannot stop when no tracking has been started.${NC}"
    exit 1
  fi
  echo -e "${GREEN}Timetrack stopped: ${CYAN}$(format_time_from_seconds $(get_elapsed_seconds))${NC}"
  echo "" > "$ENV_FILE"
  exit 0
}

restart_command() {
  echo "export TIME_TRACK_START=$(date "+%s")" > "$ENV_FILE"
  echo -e "${GREEN}Timetrack is beeing restarted.${NC}"
  exit 0
}

pause_command() {
  if [[ -z "${TIME_TRACK_START+x}" ]]; then
    echo -e "${RED}Error: Cannot pause when no tracking has been started or it's already paused!${NC}"
    exit 1
  fi
  elapsed_sec=$(get_elapsed_seconds)
  echo "export TIME_TRACK_PAUSED=$elapsed_sec" > "$ENV_FILE"
  echo -e "${GREEN}Timetrack is beeing paused:${CYAN} $(format_time_from_seconds $elapsed_sec)${NC}"
  exit 0
}

resume_command() {
  if [[ -n "${TIME_TRACK_PAUSED+x}" ]]; then
    echo "export TIME_TRACK_START=$(date "+%s")" >> "$ENV_FILE"
    echo -e "${GREEN}Timetrack has resumed tracking:${CYAN} $(format_time_from_seconds $(get_elapsed_seconds)) ${NC}"
    exit 0
  else
    echo -e "${RED}Error: Cannot resume when no tracking has been paused.${NC}"
    exit 1
  fi
}

status_command() {
  if [[ -n "${TIME_TRACK_START+x}" ]]; then
    echo -e "${YELLOW}Timetrack is tracking:${CYAN} $(format_time_from_seconds $(get_elapsed_seconds))${NC}"
  elif [[ -n "${TIME_TRACK_PAUSED+x}" ]]; then
    echo -e "${YELLOW}Timetrack is paused:${CYAN} $(format_time_from_seconds $TIME_TRACK_PAUSED)${NC}"
  else
    echo -e "${YELLOW}Timetrack is not tracking.${NC}"
  fi
  exit 0
}

log_command() {
  if [[ -n "${TIME_TRACK_START+x}" || -n "${TIME_TRACK_PAUSED+x}" ]]; then
    echo "$(format_time_from_seconds $(get_elapsed_seconds))"
  fi
  exit 0;
}

