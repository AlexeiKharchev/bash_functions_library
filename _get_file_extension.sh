#!/usr/bin/env bash

#------------------------------------------------------------------------------
# @file
# Defines function: lib::get_file_extension().
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# @function
# Gets the file extension.
#
# @param string $path
#   A relative path, absolute path, or symlink.
#
# @return string $file_extension
#   The file extension, excluding the preceding period.
#------------------------------------------------------------------------------
lib::get_file_extension() {
  lib::validate_arg_count "$#" 1 1 || return 1
  declare -r path="$1"
  declare file_name
  declare file_extension

  if lib::is_empty "${path}"; then
    lib::err "Error: the path was not specified."
    return 1
  fi

  file_name="$(lib::get_file_name "$1")" || return 1
  file_extension="${file_name##*.}"

  printf "%s" "${file_extension}"
}