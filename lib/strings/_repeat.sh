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
# Defines function: bfl::repeat().
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# @function
#   Repeats a string.
#
# @param String $str
#   The string to be repeated.
#
# @param Integer $n
#   Number of times the string will be repeated.
#
# @return String $Rslt
#   The repeated string.
#
# @example
#   bfl::repeat "=" "10"
#------------------------------------------------------------------------------
bfl::repeat() {
  # Verify arguments count.
  [[ $# -eq 2 ]] || { bfl::error "arguments count $# ≠ 2."; return ${BFL_ErrCode_Not_verified_args_count}; }

  # Verify arguments' values.
  [[ -z "$1" ]] && { bfl::error "char is required!"; return ${BFL_ErrCode_Not_verified_arg_values}; }
  bfl::is_positive_integer "$2" ||
    { bfl::error "'$2' expected to be a positive integer."; return ${BFL_ErrCode_Not_verified_arg_values}; }

  local -r str="$1"
  local -r n="$2"
  local -i iErr

  if bfl::verify_dependencies 'perl'; then
      perl -e "print '$str' x $n"       || { iErr=$?; bfl::error "perl -e \"print '$str' x '$n'\""; return ${iErr}; }
  elif bfl::verify_dependencies 'seq'; then
      printf "%0.s${str}" $(seq 1 "$n") || { iErr=$?; bfl::error "printf '%0.s${str}' \$(seq 1 '$n')"; return ${iErr}; }
#     printf "%0.s-" {1..$y}     не работает
  else
      local Rslt  # Create a string of spaces that is $i long.
      Rslt=$(printf "%${n}s") || { iErr=$?; bfl::error "printf '%${n}s'"; return ${iErr}; }
      # Replace each space with the $str.
      [[ "$str" == ' ' ]] || Rslt=${Rslt// /"${str}"}
      printf "%s\\n" "${Rslt}"
  fi
  }