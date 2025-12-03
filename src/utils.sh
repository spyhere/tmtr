get_elapsed_seconds() {
  local paused_time=${TIME_TRACK_PAUSED:-0}
  local start_sec=${TIME_TRACK_START:-$(date "+%s")}
  local curr_sec=$(date "+%s")
  echo $((curr_sec - start_sec + paused_time))
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

