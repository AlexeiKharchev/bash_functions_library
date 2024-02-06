#!/usr/bin/env bash

[[ "$BASH_SOURCE" =~ "${BASH_FUNCTIONS_LIBRARY%/*}" ]] && _bfl_temporary_var="$(bfl::transform_bfl_script_name ${BASH_SOURCE})" || return 0
[[ ${!_bfl_temporary_var} -eq 1 ]] && return 0 || readonly "${_bfl_temporary_var}"=1
#------------------------------------------------------------------------------
# ----------- https://github.com/jmooring/bash-function-library.git -----------
#
# Library of functions related to password abd cache generating, files encrypting
#
# @author  Joe Mooring
#
# @file
# Defines function: bfl::generate_password().
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# @function
#   Generates a random password.
#
# Password characteristics:
# - At least one lowercase letter
# - At least one uppercase letter
# - At least one digit
# - One underscore placed randomly in the middle.
# - Minimum length of 8
#
# The underscore placed randomly in the middle ensures that the password will
# have at least one special character. The underscore is probably the most
# benign special character (i.e., it won't break quoted strings, doesn't
# contain escape sequences, etc.).
#
# @param Integer $pswd_length
#   The length of the desired password.
#
# @return String $password
#   A random password
#
# @example
#   bfl::generate_password "16"
#------------------------------------------------------------------------------
bfl::generate_password() {
  # Verify arguments count.
  [[ $# -eq 1 ]] || { bfl::error "arguments count $# ≠ 1."; return ${BFL_ErrCode_Not_verified_args_count}; }

  # Verify argument values.
  bfl::is_positive_integer "$1" ||
    { bfl::error "'${pswd_length}' expected to be positive integer."; return ${BFL_ErrCode_Not_verified_arg_values}; }

  local -r min_pswd_length=8
  [[ "$1" -lt "${min_pswd_length}" ]] &&
    { bfl::error "'${pswd_length}' expected >= '${min_pswd_length}'."; return ${BFL_ErrCode_Not_verified_arg_values}; }

  # Verify dependencies.
  bfl::verify_dependencies 'pwgen' 'shuf' || return $?

  # Declare positional argument (readonly).
  local -r pswd_length="$1"

  # Declare all other variables (sorted by name).
  local length_one,length_two,password

  local -i iErr
  length_one=$(shuf -i 1-$((pswd_length-2)) -n 1) || { iErr=$?; bfl::error "shuf -i 1-\$((pswd_length-2)) -n 1"; return ${iErr}; }
  length_two=$((pswd_length-length_one-1)) || { iErr=$?; bfl::error "length_two=\$((pswd_length-length_one-1))"; return ${iErr}; }
  password=$(pwgen -cns "$length_one" 1)_$(pwgen -cns "$length_two" 1) ||
    { iErr=$?; bfl::error "pwgen -cns '\$length_one' 1)_\$(pwgen -cns '$length_two' 1"; return ${iErr}; }

  printf "%s\\n" "${password}"
  }