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
# Defines function: bfl::get_file_name().
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# @function
#   Gets the file name, including extension.
#
# @param String $path
#   A relative path, absolute path, or symbolic link.
#
# @return String $file_name
#   The file name, including extension.
#
# @example
#   bfl::get_file_name "./foo/bar.text"
#------------------------------------------------------------------------------
bfl::get_file_name() {
  # Verify arguments count.
  [[ $# -eq 1 ]] || { bfl::error "arguments count $# ≠ 1"; return ${BFL_ErrCode_Not_verified_args_count}; }

  # Verify arguments' values.
  bfl::is_blank "$1" && { bfl::error "The path is required."; return ${BFL_ErrCode_Not_verified_arg_values}; }

  local -i iErr
  local {canonical_file_path,file_name}
  canonical_file_path=$(bfl::get_file_path "$1") || { iErr=$?; bfl::error "bfl::get_file_path '$1'"; return ${iErr}; }
  file_name=$(basename "${canonical_file_path}") || { iErr=$?; bfl::error "basename '${canonical_file_path}'"; return ${iErr}; }
  # file_name="${1##*/}"

  printf "%s\\n" "${file_name}"
  }