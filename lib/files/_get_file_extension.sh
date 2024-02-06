#!/usr/bin/env bash

[[ "$BASH_SOURCE" =~ /bash_functions_library ]] && _bfl_temporary_var="$(bfl::transform_bfl_script_name ${BASH_SOURCE})" || return 0
[[ ${!_bfl_temporary_var} -eq 1 ]] && return 0 || readonly "${_bfl_temporary_var}"=1
#------------------------------------------------------------------------------
# ------------- https://github.com/jmooring/bash-function-library -------------
#
# Library of functions related to manipulations with files
#
# @author  Joe Mooring
#
# @file
# Defines function: bfl::get_file_extension().
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# @function
#   Gets the file extension.
#
# @param String $path
#   A relative path, absolute path, or symbolic link.
#
# @return String $file_extension
#   The file extension, excluding the preceding period.
#
# @example
#   bfl::get_file_extension "./foo/bar.txt"
#------------------------------------------------------------------------------
bfl::get_file_extension() {
  # Verify arguments count.
  [[ $# -eq 1 ]] || { bfl::error "arguments count $# ≠ 1."; return ${BFL_ErrCode_Not_verified_args_count}; }

  # Verify arguments' values.
  bfl::is_blank "$1" && { bfl::error "The path is required."; return ${BFL_ErrCode_Not_verified_arg_values}; }

  local file_name="$1"
#  J.Mooring
#  file_name="$(bfl::get_file_name "$1")" || { bfl::error "bfl::get_file_name '$1'"; return $?; }
#  printf "%s" "${file_name##*.}"

  # Detect some common multi-extensions
  [[ "$file_name" =~ \.tar\.[gx]z$ ]]   && { echo "${file_name:0 -6}"; return 0; }
  [[ "$file_name" =~ \.tar\.bz2$ ]]     && { echo "${file_name:0 -7}"; return 0; }

  local file_extension="${file_name##*.}"
  [[ "$file_name" =~ \.log\.[0-9]+$ ]]  && { echo "${file_name:0 -4-${#file_extension}}"; return 0; }

  [[ ${#file_name} -eq ${#file_extension} ]] && file_extension=""
  printf "%s\\n" "${file_extension}"
  }

#  bfl::verify_dependencies 'sed' || return $?
#  echo "$s" | sed 's/^.*\.\([^.]*\)$/\1/'