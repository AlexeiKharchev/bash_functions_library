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
# Defines function: bfl::get_file_path().
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# @function
#   Gets the canonical path to a file.
#
# @param String $path
#   A relative path, absolute path, or symbolic link.
#
# @return String $canonical_file_path
#   The canonical path to the file.
#
# @example
#   bfl::get_file_path "./foo/bar.text"
#------------------------------------------------------------------------------
bfl::get_file_path() {
  # Verify arguments count.
  [[ $# -eq 1 ]] || { bfl::error "arguments count $# ≠ 1"; return ${BFL_ErrCode_Not_verified_args_count}; }

  # Verify arguments' values.
  bfl::is_blank "$1" && { bfl::error "The path is required."; return ${BFL_ErrCode_Not_verified_arg_values}; }

  local -i iErr
  # Verify that the path exists.
  local canonical_file_path
  canonical_file_path="$(readlink -e "$1")" || { iErr=$?; bfl::error "readlink -e '$1'"; return ${iErr}; }

  # Verify that the path points to a file, not a directory.
  [[ -f "${canonical_file_path}" ]] || { bfl::error "'${canonical_file_path}' is not a file."; return 1; }

  printf "%s\\n" "${canonical_file_path}"
  }