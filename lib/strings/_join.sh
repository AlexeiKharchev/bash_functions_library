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
# Defines function: bfl::join().
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# @function
#   Joins multiple strings into a single string, separated by another string.
#
# This function will accept an unlimited number of arguments.
# Example: bfl::join "," "foo" "bar" "baz"
#
# @param String $glue
#   The character or characters that will be used to glue the strings together.
#
# @param list $pieces
#   The list of strings to be combined.
#
# @return String $Rslt
#   The joined string.
#
# @example
#   bfl::join "," "foo" "bar" "baz"
#-----------------------------------------------------------------------------
bfl::join() {
  # Verify arguments count.
  (( $# > 1 && $# < 1000 )) || { bfl::error "arguments count $# ∉ [2..999]"; return ${BFL_ErrCode_Not_verified_args_count}; }

  local -r glue="$1"
  shift   # Delete the first positional parameter.

  # Create the pieces array from the remaining positional parameters.
  local -a pieces=("$@")
  local Rslt=''

  while (( "${#pieces[@]}" )); do
      if [[ "${#pieces[@]}" -eq "1" ]]; then
          Rslt+=$(printf "%s\\n" "${pieces[0]}") || { bfl::error "printf '%s\\n' '${pieces[0]}'"; return 1; }
      else
          Rslt+=$(printf "%s%s" "${pieces[0]}" "${glue}") || { bfl::error "printf '%s%s' '${pieces[0]}' '${glue}'"; return 1; }
      fi
      pieces=("${pieces[@]:1}")   # Shift the first element off of the array.
  done

  printf "%s\\n" "$Rslt"
  }