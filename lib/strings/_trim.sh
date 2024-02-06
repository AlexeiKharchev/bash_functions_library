#!/usr/bin/env bash

[[ "$BASH_SOURCE" =~ "${BASH_FUNCTIONS_LIBRARY%/*}" ]] && _bfl_temporary_var="$(bfl::transform_bfl_script_name ${BASH_SOURCE})" || return 0
[[ ${!_bfl_temporary_var} -eq 1 ]] && return 0 || readonly "${_bfl_temporary_var}"=1
#------------------------------------------------------------------------------
# ------------- https://github.com/jmooring/bash-function-library -------------
#
# Library of functions related to Bash Strings
#
# @author  Joe Mooring
#
# @file
# Defines function: bfl::trim().
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# @function
#   Removes leading and trailing whitespace, including blank lines, from string.
#
# The string can either be single or multi-line. In a multi-line string,
# leading and trailing whitespace is removed from every line.
#
# @param String $str
#   The string to be trimmed.
#
# @return String $Rslt
#   The trimmed string.
#
# @example
#   bfl::trim " foo "
#------------------------------------------------------------------------------
bfl::trim() {
  # Verify arguments count.
  [[ $# -eq 1 ]] || { bfl::error "arguments count $# ≠ 1."; return ${BFL_ErrCode_Not_verified_args_count}; }

  # Explanation of sed commands:
  # - Remove leading whitespace from every line: s/^[[:space:]]+//
  # - Remove trailing whitespace from every line: s/[[:space:]]+$//
  # - Remove leading and trailing blank lines: /./,$ !d
  #
  # See https://tinyurl.com/yav7zw9k and https://tinyurl.com/3z8eh

  local Rslt
  local -i iErr
  Rslt=$(printf "%b" "$1" | sed -E 's/^[[:space:]]+// ; s/[[:space:]]+$// ; /./,$ !d') ||
    { iErr=$?; bfl::error "Unable to trim whitespace."; return ${iErr}; }

  printf "%s\\n" "${Rslt}"
  }