#!/usr/bin/env bash

[[ "$BASH_SOURCE" =~ "${BASH_FUNCTIONS_LIBRARY%/*}" ]] && _bfl_temporary_var="$(bfl::transform_bfl_script_name ${BASH_SOURCE})" || return 0
[[ ${!_bfl_temporary_var} -eq 1 ]] && return 0 || readonly "${_bfl_temporary_var}"=1
#------------------------------------------------------------------------------
# ------------- https://github.com/jmooring/bash-function-library -------------
# ---------- https://github.com/natelandau/shell-scripting-templates ----------
#
# Library of functions to help work with dates and time
#
# @author  Joe Mooring, Nathaniel Landau
#
# @file
# Defines function: bfl::time_convert_s_to_hhmmss().
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# @function
#   Converts seconds to the hh:mm:ss format.
#
# @param Integer $seconds
#   The number of seconds to convert.
#
# @return String $hhmmss
#   The number of seconds in hh:mm:ss format.
#
# @example
#   bfl::time_convert_s_to_hhmmss "3661"
#
#   To compute the time it takes a script to run:
#      STARTTIME=$(date +"%s")
#             ...
#      ENDTIME=$(date +"%s")
#      TOTALTIME=$(($ENDTIME-$STARTTIME)) # human readable time
#      bfl::time_convert_s_to_hhmmss "$TOTALTIME"
#------------------------------------------------------------------------------
bfl::time_convert_s_to_hhmmss() {
  # Verify arguments count.
  [[ $# -eq 1 ]] || { bfl::error "arguments count $# ≠ 1"; return ${BFL_ErrCode_Not_verified_args_count}; }

  # Verify arguments' values.
  bfl::is_positive_integer "$1" ||
      { bfl::error "'$1' expected to be a positive integer."; return ${BFL_ErrCode_Not_verified_arg_values}; }

  local -ri seconds="$1"
  local hhmmss
  local -i iErr

  hhmmss=$(printf '%02d:%02d:%02d\n' $((seconds/3600)) $((seconds%3600/60)) $((seconds%60))) ||
      { iErr=$?; bfl::error "Unable to convert '${seconds}' to hh:mm:ss format."; return ${iErr}; }

  printf "%s\\n" "${hhmmss}"
  }