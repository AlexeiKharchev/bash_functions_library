#!/usr/bin/env bash

[[ "$BASH_SOURCE" =~ "${BASH_FUNCTIONS_LIBRARY%/*}" ]] && _bfl_temporary_var="$(bfl::transform_bfl_script_name ${BASH_SOURCE})" || return 0
[[ ${!_bfl_temporary_var} -eq 1 ]] && return 0 || readonly "${_bfl_temporary_var}"=1
#------------------------------------------------------------------------------
# ------------- https://github.com/jmooring/bash-function-library -------------
#
# Library of functions related to Apache
#
# @author  Joe Mooring
#
# @file
# Defines function: bfl::is_apache_vhost().
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# @function
#   Checks if the given path is the root of an Apache virtual host.
#
# @param String $path
#   A relative path, absolute path, or symbolic link.
#
# @param String $sites_enabled [optional]
#   Absolute path to Apache's "sites-enabled" directory.
#   Defaults value is /etc/apache2/sites-enabled.
#
# @return Boolean $result
#     0 / 1   ( true / false )
#
# @example
#   bfl::is_apache_vhost "./foo"
#   bfl::is_apache_vhost "./foo" "/etc/apache2/sites-enabled"
#------------------------------------------------------------------------------
bfl::is_apache_vhost() {
  # Verify arguments count.
  (( $# > 0 && $# < 3 )) || { bfl::error "arguments count $# ∉ [1..2]."; return ${BFL_ErrCode_Not_verified_args_count}; }

  # Verify arguments' values.
  bfl::is_blank "$1" && { bfl::error "path is required."; return ${BFL_ErrCode_Not_verified_arg_values}; }
  [[ $# -gt 1 ]] && bfl::is_blank "$2" && { bfl::error "path_sites_enabled argument is empty."; return ${BFL_ErrCode_Not_verified_arg_values}; }

  # Verify dependencies.
  bfl::verify_dependencies 'grep' || return $?

  # Declare positional arguments (readonly, sorted by position).
  local -r sites_enabled="${2:-"/etc/apache2/sites-enabled"}"

  # Declare all other variables (sorted by name).
  local canonical_sites_enabled
  local -i iErr

  # Get canonical paths.
  canonical_path=$(bfl::get_directory_path "$1") ||
    { iErr=$?; bfl::error "Unable to determine canonical path to '$1'."; return ${iErr}; }
  canonical_sites_enabled=$(bfl::get_directory_path "${sites_enabled}") ||
      { iErr=$?; bfl::error "Unable to determine canonical path to '${sites_enabled}'."; return ${iErr}; }

  grep -q -P -R -m1 "DocumentRoot\\s+${canonical_path}$" "${canonical_sites_enabled}" ||
      { iErr=$?; bfl::error "Failed grep -q -P -R -m1 'DocumentRoot\\s+${canonical_path}$' '${canonical_sites_enabled}'"; return ${iErr}; }
  }
