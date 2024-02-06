#!/usr/bin/env bash

[[ "$BASH_SOURCE" =~ "${BASH_FUNCTIONS_LIBRARY%/*}" ]] && _bfl_temporary_var="$(bfl::transform_bfl_script_name ${BASH_SOURCE})" || return 0
[[ ${!_bfl_temporary_var} -eq 1 ]] && return 0 || readonly "${_bfl_temporary_var}"=1
#------------------------------------------------------------------------------
#
# Library of functions related to Bash Strings
#
# @author
#
# @file
# Defines function: bfl::string_of_char().
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# @function
#   Synonim bfl::repeat().
#
# @param String $str
#   The string to be repeated.
#
# @param Integer $n
#   Number of times the string will be repeated.
#
# @return String $Rslt
#   The repeated string.
#------------------------------------------------------------------------------
bfl::string_of_char() {
  local Rslt
  Rslt=$(bfl::repeat "$@") || return $?
  printf "%s\\n" "$Rslt"
  }