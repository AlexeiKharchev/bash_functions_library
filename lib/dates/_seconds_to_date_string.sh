#!/usr/bin/env bash

[[ "$BASH_SOURCE" =~ "${BASH_FUNCTIONS_LIBRARY%/*}" ]] && _bfl_temporary_var="$(bfl::transform_bfl_script_name ${BASH_SOURCE})" || return 0
[[ ${!_bfl_temporary_var} -eq 1 ]] && return 0 || readonly "${_bfl_temporary_var}"=1
#------------------------------------------------------------------------------
#
# Library of functions to help work with dates and time
#
# @author
#
# @file
# Defines function: bfl::seconds_to_date_string().
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# @function
#   Synonim bfl::time_convert_s_to_hhmmss()
#
# @param Integer $seconds
#   The number of seconds to convert.
#
# @return String $hhmmss
#   The number of seconds in hh:mm:ss format.
#------------------------------------------------------------------------------
bfl::seconds_to_date_string() {
  local hhmmss
  hhmmss=$(bfl::time_convert_s_to_hhmmss "$@") || return $?
  printf "%s\\n" "$hhmmss"
  }