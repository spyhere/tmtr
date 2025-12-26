get_elapsed_seconds() {
  local start_time=$1
  local paused_time=${!2:-$(date "+%s")}
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

remove_key() {
  local key=$1
  if grep -q "^$key=" "$ENV_FILE"; then
      perl -pi -e "s/^$key=.*//" "$ENV_FILE"
  fi
  return 0
}

label_exist() {
  if grep -q "^$1=" "$ENV_FILE"; then
    return 0;
  fi
  return 1;
}

list_labels() {
  while IFS= read -r label; do
    echo "${label} $(status_command $label)"
  done < <(perl -ne 'print "$1\n" if /(^[a-zA-Z]+)=/' "$ENV_FILE")
  return 0
}

