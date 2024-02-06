#!/usr/bin/env bash

[[ "$BASH_SOURCE" =~ "${BASH_FUNCTIONS_LIBRARY%/*}" ]] && _bfl_temporary_var="$(bfl::transform_bfl_script_name ${BASH_SOURCE})" || return 0
[[ ${!_bfl_temporary_var} -eq 1 ]] && return 0 || readonly "${_bfl_temporary_var}"=1
#------------------------------------------------------------------------------
# ----------- https://github.com/jmooring/bash-function-library.git -----------
#
# Library of number operating functions
#
# @author  Joe Mooring
#
# @file
# Defines function: bfl::is_positive_integer().
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# @function
#   Determines if the argument is a positive integer.
#
# @param String $value_to_test
#   The value to be tested.
#
# @example
#   bfl::is_positive_integer "8675309"
#------------------------------------------------------------------------------
bfl::is_positive_integer() {
  # Verify arguments count.
  [[ $# -eq 1 ]] || { bfl::error "arguments count $# ≠ 1."; return ${BFL_ErrCode_Not_verified_args_count}; }

  [[ "$1" =~ ^[1-9][0-9]*$ ]] # || return 1
  }