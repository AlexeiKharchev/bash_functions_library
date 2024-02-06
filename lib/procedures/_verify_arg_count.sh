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
# Defines function: bfl::verify_arg_count().
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# @function
#   Verifies the number of arguments received against expected values.
#
# Other functions in this library call this function to verify the number of
# arguments received. To prevent infinite loops, this function must not call
# any other function in this library, other than bfl::error, bfl::warn,
# bfl::inform (or bfl::die.
#
# That is why we are essentially recreating:
# - bfl::verify_arg_count()
# - bfl::is_integer()
#
# @param Integer $actual_arg_count
#   Actual number of arguments received.
#
# @param Integer $expected_arg_count_min
#   Minimum number of arguments expected.
#
# @param Integer $expected_arg_count_max
#   Maximum number of arguments expected.
#
# @example
#   bfl::verify_arg_count "$#" 2 3
#------------------------------------------------------------------------------
bfl::verify_arg_count() {
  # Verify argument count.
  [[ "$#" -eq "3" ]] || { bfl::error "arguments count $# ≠ 3."; return ${BFL_ErrCode_Not_verified_args_count}; }

  local arg # Verify arguments' values. Make sure all of the arguments are integers.
  for arg in "$1" "$2" "$3"; do
    bfl::is_positive_integer "$arg" || { bfl::error "'$arg' expected to be an integer."; return ${BFL_ErrCode_Not_verified_arg_values}; }
  done

  local -r arg_count="$1"
  local -r expected_min="$2"
  local -r expected_max="$3"

  # Test.
  if [[ "${arg_count}" -lt "${expected_min}" ||
        "${arg_count}" -gt "${expected_max}" ]]; then
      if [[ ${BASH_INTERACTIVE} == true ]]; then
          local error_msg
          if [[ "${expected_min}" -eq "${expected_max}" ]]; then
              error_msg=" Expected '${expected_min}', received '${arg_count}'."
          else
              error_msg="Expected arguments count ${arg_count}∈[${expected_min}..${expected_max}]."
          fi
          printf "%b\\n" "${bfl_aes_red}Invalid number of arguments. ${error_msg}${bfl_aes_reset}" 1>&2
      fi
      return 1
  fi
  }