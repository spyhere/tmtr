get_elapsed_seconds() {
  local paused_time=${TIME_TRACK_PAUSED:-$(date "+%s")}
  local start_time=$TIME_TRACK_START
  echo $((paused_time - start_time))
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

update_value() {
  local key=$1
  local value=$2
  if grep -q "^$key=" "$ENV_FILE"; then
      perl -pi -e "s/^$key=.*/$key=$value/" "$ENV_FILE"
  else
      echo "$key=$value" >> "$ENV_FILE"
  fi

}

