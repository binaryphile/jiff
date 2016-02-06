#!/usr/bin/env bash

# Functions specific to jiff but not platform-specific

source basics

is_jiff_command () {
  is_file "${_JIFF_ROOT}/libexec/jiff-${1}"
}

run_and_exit_if_is_jiff_command () {
  local command

  command="${1}"
  ! is_jiff_command "${command}" || exec jiff "${command}"
}

run_if_is_jiff_command () {
  local command

  command="${1}"
  if is_jiff_command "${command}"; then
    jiff "${command}"
  else
     return 1
  fi
}
