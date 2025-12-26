NOW=$(date "+%s")

init_command() {
  local label=$1
  local label_paused="${label}_PAUSED"
  if [[ "${label:-0}" -gt 0 ]]; then
    echo -e "${RED}Error: Timetrack is already tracking! Use 'restart' to restart it.${CYAN} $(format_time_from_seconds $(get_elapsed_seconds $label $label_paused))${NC}"
    exit 1
  fi
  update_value $label $NOW
  echo -e "${GREEN}Timetrack started${NC}"
  exit 0
}

stop_command() {
  local label=$1
  local label_paused="${label}_PAUSED"
  if [[ "${label:-0}" -eq 0 ]]; then
    echo -e "${RED}Error: Cannot stop when no tracking has been started.${NC}"
    exit 1
  fi
  echo -e "${RED}⏹${CYAN} $(format_time_from_seconds $(get_elapsed_seconds $label $label_paused))${NC}"
  remove_key $label
  remove_key $label_paused
  exit 0
}

restart_command() {
  local label=$1
  local label_paused="${label}_PAUSED"
  update_value $label $NOW
  update_value $label_paused ""
  echo -e "${GREEN}↺${NC}"
  exit 0
}

pause_command() {
  local label=$1
  local label_paused="${label}_PAUSED"
  if [[ "${label:-0}" -eq 0 || "${label_paused:-0}" -gt 0 ]]; then
    echo -e "${RED}Error: Cannot pause when no tracking has been started or it's already paused!${NC}"
    exit 1
  fi
  update_value $label_paused $NOW
  echo -e "${YELLOW}⏸${CYAN} $(format_time_from_seconds $(get_elapsed_seconds $label $label_paused))${NC}"
  exit 0
}

resume_command() {
  local label=$1
  local label_paused="${label}_PAUSED"
  if [[ "${label_paused:-0}" -gt 0 ]]; then
    update_value $label $((label + NOW - label_paused))
    update_value $label_paused ""
    echo -e "${GREEN}▶${CYAN} $(format_time_from_seconds $(get_elapsed_seconds $label $label_paused)) ${NC}"
    exit 0
  else
    echo -e "${RED}Error: Cannot resume when no tracking has been paused.${NC}"
    exit 1
  fi
}

status_command() {
  local label=$1
  local label_paused="${label}_PAUSED"
  if [[ "${label_paused:-0}" -gt 0 ]]; then
    echo -e "${YELLOW}⏸${CYAN} $(format_time_from_seconds $(get_elapsed_seconds $label $label_paused))${NC}"
  elif [[ "${label:-0}" -gt 0 ]]; then
    echo -e "${GREEN}▶${CYAN} $(format_time_from_seconds $(get_elapsed_seconds $label $label_paused))${NC}"
  else
    echo -e "${RED}Not tracking${NC}"
  fi
  exit 0
}

log_command() {
  local label=$1
  local label_paused="${label}_PAUSED"
  if [[ "${label:-0}" -gt 0 ]]; then
    echo "$(format_time_from_seconds $(get_elapsed_seconds $label $label_paused))"
  fi
  return 0;

remove_label() {
  local label=$1
  local label_paused="${label}_PAUSED"
  remove_key $label
  remove_key $label_paused
  return 0
}

remove_all_labels() {
  echo "" > "$ENV_FILE"
  return 0
}

