if [[ ! -o interactive ]]; then
    return
fi

compctl -K _setup setup

_setup() {
  local word words completions
  read -cA words
  word="${words[2]}"

  if [ "${#words}" -eq 2 ]; then
    completions="$(setup commands)"
  else
    completions="$(setup completions "${word}")"
  fi

  reply=("${(ps:\n:)completions}")
}
