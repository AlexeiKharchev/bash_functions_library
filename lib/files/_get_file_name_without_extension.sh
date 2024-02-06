#!/usr/bin/env bash

[[ "$BASH_SOURCE" =~ "${BASH_FUNCTIONS_LIBRARY%/*}" ]] && _bfl_temporary_var="$(bfl::transform_bfl_script_name ${BASH_SOURCE})" || return 0
[[ ${!_bfl_temporary_var} -eq 1 ]] && return 0 || readonly "${_bfl_temporary_var}"=1
#------------------------------------------------------------------------------
# ------------- https://github.com/jmooring/bash-function-library -------------
#
# Library of functions related to manipulations with files
#
# @author  Joe Mooring
#
# @file
# Defines function: bfl::get_file_name_without_extension().
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# @function
#   Gets the file name, excluding extension. Don't mix with  basename !
#
# @param String $path
#   A relative path, absolute path, or symbolic link.
#
# @return String $file_name_without_extension
#   The file name, excluding extension.
#
# @example
#   bfl::get_file_name_without_extension "./foo/bar.txt" --> "bar"
#------------------------------------------------------------------------------
bfl::get_file_name_without_extension() {
  # Verify arguments count.
  [[ $# -eq 1 ]] || { bfl::error "arguments count $# ≠ 1"; return ${BFL_ErrCode_Not_verified_args_count}; }

  # Verify arguments' values.
  bfl::is_blank "$1" && { bfl::error "The path is required."; return ${BFL_ErrCode_Not_verified_arg_values}; }

  local -i iErr
  #local file_name=${1##*/}
  local {file_name,ext}=
  file_name="$(bfl::get_file_name "$1")" || { iErr=$?; bfl::error "bfl::get_file_name '$1'"; return ${iErr}; }
  ext=$(bfl::get_file_extension "${file_name}") ||
    { iErr=$?; bfl::error "${FUNCNAME[0]}: ext=\$(bfl::get_file_extension '${file_name}')"; return ${iErr}; }

  local file_name_without_extension="${file_name:0:-${#ext}-1}"   # "${file_name%.*}"

  printf "%s\\n" "${file_name_without_extension}"
  }