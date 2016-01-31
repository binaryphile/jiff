#!/usr/bin/env bash

package_is_installed () {
  yum list installed "${1}" >/dev/null
}

yum_install () {
  sudo yum install -y "${1}"
}
