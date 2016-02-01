if [[ ! -o interactive ]]; then
    return
fi

compctl -K _jiff jiff

_jiff() {
  local word words completions
  read -cA words
  word="${words[2]}"

  if [ "${#words}" -eq 2 ]; then
    completions="$(jiff commands)"
  else
    completions="$(jiff completions "${word}")"
  fi

  reply=("${(ps:\n:)completions}")
}
