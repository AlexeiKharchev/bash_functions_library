#!/usr/bin/env bash

[[ "$BASH_SOURCE" =~ "${BASH_FUNCTIONS_LIBRARY%/*}" ]] && _bfl_temporary_var="$(bfl::transform_bfl_script_name ${BASH_SOURCE})" || return 0
[[ ${!_bfl_temporary_var} -eq 1 ]] && return 0 || readonly "${_bfl_temporary_var}"=1
#------------------------------------------------------------------------------
# ------------- https://github.com/jmooring/bash-function-library -------------
#
# Library of functions related to manipulations with files
#
# @author
#
# @file
# Defines function: bfl::get_file_basename().
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# @function
#   Synonim bfl::get_file_name_without_extension(). Don't mix with  basename !
#
# @param String $_path
#   A relative path, absolute path, or symbolic link.
#
# @return String $file_name_without_extension
#   The file name, excluding extension.
#------------------------------------------------------------------------------
bfl::get_file_basename() {
  local _path
  _path=$(bfl::get_file_name_without_extension "$@") || return $?
  printf "%s\\n" "${_path}"
  }