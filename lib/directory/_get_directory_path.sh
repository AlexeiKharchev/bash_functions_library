#!/usr/bin/env bash

[[ "$BASH_SOURCE" =~ "${BASH_FUNCTIONS_LIBRARY%/*}" ]] && _bfl_temporary_var="$(bfl::transform_bfl_script_name ${BASH_SOURCE})" || return 0
[[ ${!_bfl_temporary_var} -eq 1 ]] && return 0 || readonly "${_bfl_temporary_var}"=1
#------------------------------------------------------------------------------
# ------------- https://github.com/jmooring/bash-function-library -------------
#
# Library of directory functions
#
# @author  Joe Mooring
#
# @file
# Defines function: bfl::get_directory_path().
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# @function
#   Gets the canonical path to a directory.
#
# @param String $path
#   A relative path, absolute path, or symbolic link.
#
# @return String $canonical_directory_path
#   The canonical path to the directory.
#
# @example
#   bfl::get_directory_path "./foo"
#------------------------------------------------------------------------------
bfl::get_directory_path() {
  # Verify arguments count.
  [[ $# -eq 1 ]] || { bfl::error "arguments count $# ≠ 1."; return ${BFL_ErrCode_Not_verified_args_count}; }

  # Verify arguments' values.
  bfl::is_blank "$1" && { bfl::error "The path is required."; return ${BFL_ErrCode_Not_verified_arg_values}; }

  # Verify that the path exists.
  local canonical_directory_path
  if [[ ${BFL_HAS_READLINK} -eq 1 ]]; then
      canonical_directory_path=$(readlink -e "$1") || { bfl::error "readlink -e '$1'"; return ${BFL_ErrCode_Not_verified_arg_values}; }
  else
      [[ -e "$1" ]] || { bfl::error "path '$1' does not exist."; return ${BFL_ErrCode_Not_verified_arg_values}; }
      canonical_directory_path="$1"
      if [[ -L "$1" ]]; then
          local str
          local -i iErr
          str=$(ls -la "$1" | sed 's|^.* -> \(.*\)$|\1|') || { iErr=$?; bfl::error "ls -la '$1' | sed '^.* -> ...$|\1|'"; return ${iErr}; }
          [[ $str =~ ../* ]] || canonical_directory_path="$str"
      fi
  fi

  # Verify that the path points to a directory, not a file.
  [[ -d "${canonical_directory_path}" ]] ||
    { bfl::error "Canonical directory path '$canonical_directory_path' is not a directory."; return 1; }

  printf "%s\\n" "${canonical_directory_path}"
  }