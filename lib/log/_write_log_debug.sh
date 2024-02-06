#!/usr/bin/env bash

[[ "$BASH_SOURCE" =~ "${BASH_FUNCTIONS_LIBRARY%/*}" ]] && _bfl_temporary_var="$(bfl::transform_bfl_script_name ${BASH_SOURCE})" || return 0
[[ ${!_bfl_temporary_var} -eq 1 ]] && return 0 || readonly "${_bfl_temporary_var}"=1
#------------------------------------------------------------------------------
# ------------ https://github.com/Jarodiv/bash-function-libraries -------------
#
# Library of functions related to terminal and file logging
#
# @author  Michael Strache
#
# @file
# Defines function: bfl::write_log_debug().
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# @function
#   Prints passed Message on Log-Level debug to stdout.
#
# @param String $msg
#   Message to log.
#
# @param String $BASH_LINENO aray (optional)
#   Array.
#
# @param String $logfile (optional)
#   Log file.
#
# @example
#   bfl::write_log_debug "Some string ...."
#------------------------------------------------------------------------------
bfl::write_log_debug() {
  # Verify arguments count.
  (( $# > 0 && $# < 4 )) || { bfl::error "arguments count $# ∉ [1..3]."; return ${BFL_ErrCode_Not_verified_args_count}; }

  # Verify arguments' values.
  bfl::is_blank "$1" && { bfl::error "Message is required."; return ${BFL_ErrCode_Not_verified_arg_values}; }

  local -r msg="$1"
  local -r logfile="${3:-$BASH_FUNCTIONS_LOG}"

  local -i iErr
  bfl::write_log ${_BFL_LOG_LEVEL_DEBUG} "$msg" "${2:-Warn}" "$logfile" ||
    { iErr=$?; bfl::error "${FUNCNAME[0]}: error $*\n."; return ${iErr}; }

#                           msg
#  bfl::write_log $LOG_LVL_ERROR "$1" "${CLR_BRACKET}[${CLR_DEBUG} fail ${CLR_BRACKET}]${CLR_NORMAL}" && return 0 || return 1

#  printf "${CLR_DEBUG}Written log message to $logfile${NC}\n" > /dev/tty
  }