#!/usr/bin/env bash

source basics

exit_if_package_is_installed () {
  ! package_is_installed "${1}" || exit
}

install_package () {
  local package

  package="${1}"
  return_if_package_is_installed "${package}"
  update_apt
  sudo apt-get install -y "${package}"
}

package_is_installed () {
  dpkg --get-selections "${1}" | grep -q "^${1}\\(:amd64\\)\\?[[:space:]]\\+install\$"
}

return_if_package_is_installed () {
  ! package_is_installed "${1}" || return 0
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
