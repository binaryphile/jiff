#!/usr/bin/env bash

source basics

exit_if_package_is_installed () {
  ! package_is_installed "${1}" || exit
}

install_backports () {
  jiff slash-git
  ! grep -q backports /etc/apt/sources.list || exit
  push_dir "/etc/apt"
  echo "deb http://ubuntu.wikimedia.org/ubuntu trusty-backports main restricted universe multiverse" | sudo tee -a sources.list >/dev/null
  git add --force sources.list
  git commit --message "backports"
  sudo apt-get update -qq
  ! is_file "preferences" || git add --force preferences && git commit --message "add preferences"
  cat <<PREFS | sudo tee -a preferences >/dev/null
Package: *
Pin: release a=trusty-backports
Pin-Priority: 100
PREFS
  git add --force preferences
  git commit --message "pin to backports"
  pop_dir
}

install_package () {
  sudo apt-get install -y "${@}"
}

package_is_installed () {
  dpkg --get-selections "${1}" | grep -q "^${1}\\(:amd64\\)\\?[[:space:]]\\+install\$"
}

update_apt () {
  local apt_date
  local now_date
  local last_update
  local update_interval

  apt_date="$(stat -c %Y '/var/cache/apt/pkgcache.bin')"
  now_date="$(date +'%s')"
  last_update="$((${now_date} - ${apt_date}))"
  update_interval="$((24 * 60 * 60))"
  [[ "${last_update}" -lt "${update_interval}" ]] || sudo apt-get update -qq
}
