#!/usr/bin/env bash

[[ "$BASH_SOURCE" =~ "${BASH_FUNCTIONS_LIBRARY%/*}" ]] && _bfl_temporary_var="$(bfl::transform_bfl_script_name ${BASH_SOURCE})" || return 0
[[ ${!_bfl_temporary_var} -eq 1 ]] && return 0 || readonly "${_bfl_temporary_var}"=1
#------------------------------------------------------------------------------
# ------------- https://github.com/jmooring/bash-function-library -------------
#
# Library of internal library functions
#
# @author  Joe Mooring
#
# @file
# Defines function: bfl::inform().
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# @function
#   Prints an informational message to stdout.
#
# @param String $msg (optional)
#   The message. A blank line will be printed if no message is provided.
#
# @example
#   bfl::inform "The foo is bar."
#------------------------------------------------------------------------------
bfl::inform() {
  local writelog=false
  [[ ${BASH_LOG_LEVEL} -lt ${_BFL_LOG_LEVEL_INFORM} ]] ||
      { [[ -n "$BASH_FUNCTIONS_LOG" ]] && [[ -f "$BASH_FUNCTIONS_LOG" ]] && writelog=true; }

  # Сама функция возвращает 0 - смысла нет оперировать кодом ошибки, из-за замены  exit 1 => return 1
  [[ $BASH_INTERACTIVE == true ]] || [[ $writelog == true ]] || return 0

  # Verify arguments count.
  [[ $# -eq 1 ]] || { bfl::error "arguments count $# ≠ 1."; return ${BFL_ErrCode_Not_verified_args_count}; }

  # Declare positional argument (readonly).
  local -r msg="$1"

  [[ $writelog == true ]] && printf "Inform: %b\\n" "${msg}" >> "${BASH_FUNCTIONS_LOG}"

  [[ $BASH_INTERACTIVE == true ]] || return 0
  [[ -n "$PS1" ]] || return 0

#  Only if running interactively
  case $- in
      *i*)  # Prints message and stack.
          printf "%b\\n" "${CLR_INFORM}${msg}${NC}" 1>&2
          ;;
      *)      # do nothing
          ;;  # non-interactive
  esac
  }