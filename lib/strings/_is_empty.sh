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
# Defines function: bfl::is_empty().
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# @function
#   Checks if a string is empty ("") or null.
#
# @param String $str
#   The string to check.
#
# @example
#   bfl::is_empty "foo"
#------------------------------------------------------------------------------
bfl::is_empty() {
  # Verify argument count.
  [[ $# -eq 1 ]] || { bfl::error "arguments count $# ≠ 1"; return ${BFL_ErrCode_Not_verified_args_count}; }

  [[ -z "$1" ]] # || return 1
  }
