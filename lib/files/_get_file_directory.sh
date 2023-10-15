#!/usr/bin/env bash

[[ "$BASH_SOURCE" =~ "${BASH_FUNCTIONS_LIBRARY%/*}" ]] && _bfl_temporary_var="$(bfl::transform_bfl_script_name ${BASH_SOURCE})" || return 0
[[ ${!_bfl_temporary_var} -eq 1 ]] && return 0 || readonly "${_bfl_temporary_var}"=1
#------------------------------------------------------------------------------
# ----------- https://github.com/jmooring/bash-function-library.git -----------
#
# Library of functions related to manipulations with files
#
# @author  Joe Mooring
#
# @file
# Defines function: bfl::get_file_directory().
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# @function
# Gets the canonical path to the directory in which a file resides.
#
# @param string $path
#   A relative path, absolute path, or symbolic link.
#
# @return string $canonical_directory_path
#   The canonical path to the directory in which a file resides.
#
# @example
#   bfl::get_file_directory "./foo/bar.txt"
#------------------------------------------------------------------------------
bfl::get_file_directory() {
  # Verify arguments count.
  [[ $# -eq 1 ]] || bfl::die "arguments count $# ≠ 1." ${BFL_ErrCode_Not_verified_args_count}

  # Verify arguments' values.
  bfl::is_blank "$1" && bfl::die "The path is required." ${BFL_ErrCode_Not_verified_arg_values}

  local canonical_file_path
  canonical_file_path=$(bfl::get_file_path "$1") || bfl::die "bfl::get_file_path '$1'" $?
  local canonical_directory_path
  canonical_directory_path=$(dirname "${canonical_file_path}}") || bfl::die "dirname ${canonical_file_path}}" $?

  printf "%s" "${canonical_directory_path}"
  }
