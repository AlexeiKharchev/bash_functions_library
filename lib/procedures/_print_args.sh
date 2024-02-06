#!/usr/bin/env bash

[[ "$BASH_SOURCE" =~ "${BASH_FUNCTIONS_LIBRARY%/*}" ]] && _bfl_temporary_var="$(bfl::transform_bfl_script_name ${BASH_SOURCE})" || return 0
[[ ${!_bfl_temporary_var} -eq 1 ]] && return 0 || readonly "${_bfl_temporary_var}"=1
#------------------------------------------------------------------------------
# ------------- https://github.com/jmooring/bash-function-library -------------
#
# Library of internal library functions
#
# @author  Joe Mooring
#
# @file
# Defines function: bfl::print_args().
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# @function
#   Prints the arguments passed to this function.
#
# A debugging tool. Accepts between 1 and 999 arguments.
#
# @param list $arguments
#   One or more arguments.
#
# @example
# bfl::print_args "foo" "bar" "baz"
#------------------------------------------------------------------------------
bfl::print_args() {
  # Verify arguments count.
  (( $# > 0 && $# < 1000 )) || { bfl::error "arguments count $# ∉ [1..999]"; return ${BFL_ErrCode_Not_verified_args_count}; }

  local -ar args=("$@")

  # Declare all other variables (sorted by name).
  local arg
  local -i counter=0

  printf "===== Begin output from %s =====\\n" "${FUNCNAME[0]}"
  for arg in "${args[@]}"; do
      ((counter++)) || true
      printf "$%s = %s\\n" "${counter}" "${arg}"
  done

  printf "===== End output from %s =====\\n" "${FUNCNAME[0]}"
  }