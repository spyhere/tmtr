NOW=$(date "+%s")

init_command() {
  if [[ "${TIME_TRACK_START:-0}" -gt 0 ]]; then
    echo -e "${RED}Error: Timetrack is already tracking! Use 'restart' to restart it.${CYAN} $(format_time_from_seconds $(get_elapsed_seconds))${NC}"
    exit 1
  fi
  update_value "TIME_TRACK_START" $NOW
  echo -e "${GREEN}Timetrack started${NC}"
  exit 0
}

stop_command() {
  if [[ "${TIME_TRACK_START:-0}" -eq 0 ]]; then
    echo -e "${RED}Error: Cannot stop when no tracking has been started.${NC}"
    exit 1
  fi
  echo -e "${RED}⏹${CYAN} $(format_time_from_seconds $(get_elapsed_seconds))${NC}"
  update_value "TIME_TRACK_START" ""
  update_value "TIME_TRACK_PAUSED" ""
  exit 0
}

restart_command() {
  update_value "TIME_TRACK_START" $NOW
  update_value "TIME_TRACK_PAUSED" ""
  echo -e "${GREEN}↺${NC}"
  exit 0
}

pause_command() {
  if [[ "${TIME_TRACK_START:-0}" -eq 0 || "${TIME_TRACK_PAUSED:-0}" -gt 0 ]]; then
    echo -e "${RED}Error: Cannot pause when no tracking has been started or it's already paused!${NC}"
    exit 1
  fi
  update_value "TIME_TRACK_PAUSED" $NOW
  echo -e "${YELLOW}⏸${CYAN} $(format_time_from_seconds $(get_elapsed_seconds))${NC}"
  exit 0
}

resume_command() {
  if [[ "${TIME_TRACK_PAUSED:-0}" -gt 0 ]]; then
    update_value "TIME_TRACK_START" $((TIME_TRACK_START + NOW - TIME_TRACK_PAUSED))
    update_value "TIME_TRACK_PAUSED" ""
    echo -e "${GREEN}▶${CYAN} $(format_time_from_seconds $(get_elapsed_seconds)) ${NC}"
    exit 0
  else
    echo -e "${RED}Error: Cannot resume when no tracking has been paused.${NC}"
    exit 1
  fi
}

status_command() {
  if [[ "${TIME_TRACK_PAUSED:-0}" -gt 0 ]]; then
    echo -e "${YELLOW}⏸${CYAN} $(format_time_from_seconds $(get_elapsed_seconds))${NC}"
  elif [[ "${TIME_TRACK_START:-0}" -gt 0 ]]; then
    echo -e "${GREEN}▶${CYAN} $(format_time_from_seconds $(get_elapsed_seconds))${NC}"
  else
    echo -e "${RED}Not tracking${NC}"
  fi
  exit 0
}

log_command() {
  if [[ "${TIME_TRACK_START:-0}" -gt 0 ]]; then
    echo "$(format_time_from_seconds $(get_elapsed_seconds))"
  fi
  exit 0;
}

