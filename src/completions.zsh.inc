# Make bash completions work in zsh
autoload -U +X bashcompinit && bashcompinit
zmodload -i zsh/parameter

ENV="/Users/spyhere/Projects/tmtr"
ENV_FILE="$ENV/.env"
source "$ENV/src/utils.sh"

if [[ -f "$ENV_FILE" ]]; then
  set -a
  source "$ENV_FILE"
  set +a
fi

tmtr_commands=(stop s restart rst pause p resume r status stat log l ls remove rm remove_all rma)
local commands_sorted=($(printf "%s\n" "${tmtr_commands[@]}" | sort -fu))

_tmtr_completion() {
    local cur=${COMP_WORDS[COMP_CWORD]}

    local labels_sorted=()
    if [[ $COMP_CWORD -eq 1 ]]; then
      local labels=($(get_labels))
      labels_sorted=($(printf "%s\n" "${labels[@]}" | sort -fu))
    fi

    local commands_list=("${commands_sorted[@]}")
    if [[ ${#labels_sorted[@]} -gt 0 ]]; then
      commands_list=()
    fi

    local suggestions=("${labels_sorted[@]}" "${commands_list[@]}")

    # Build a space-separated string for compgen
    local suggestion_str="${suggestions[*]}"

    # Generate completions
    COMPREPLY=( $(compgen -W "$suggestion_str" -- "$cur") )
}

complete -F _tmtr_completion tmtr

