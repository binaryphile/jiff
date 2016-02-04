#!/usr/bin/env bash

source basics

is_jiff_command () {
  is_file "${_JIFF_ROOT}/libexec/jiff-${1}"
}

run_and_exit_if_is_jiff_command () {
  ! run_if_is_jiff_command "${1}" || exit 0
}

run_if_is_jiff_command () {
  local command

  command="${1}"
  ! is_jiff_command "${command}" || jiff "${command}"
}
