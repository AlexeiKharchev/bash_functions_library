#!/usr/bin/env bash

[[ "$BASH_SOURCE" =~ "${BASH_FUNCTIONS_LIBRARY%/*}" ]] && _bfl_temporary_var="$(bfl::transform_bfl_script_name ${BASH_SOURCE})" || return 0
[[ ${!_bfl_temporary_var} -eq 1 ]] && return 0 || readonly "${_bfl_temporary_var}"=1
#------------------------------------------------------------------------------
# ------------ https://github.com/Jarodiv/bash-function-libraries -------------
#
# Library of functions related to file logging
#
# @author  Michael Strache
#
# @file
# Defines function: bfl::write_log().
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# @function
#   Prints the passed message depending on its log-level to stdout.
#
# @param Integer $LEVEL
#   Log level of the message.
#
# @param String $MESSAGE
#   Message to log.
#
# @param String $STATUS
#   Short status string, that will be displayed right aligned in the log line.
#
# @param String logfile (optional)
#   Log file.
#
# @example
#   bfl::write_log 0 "Compiling source" "Start operation" "$HOME/.faults"
#------------------------------------------------------------------------------
bfl::write_log() {
  local str

  # Verify arguments count.
  (( $# > 2 && $# < 5 )) || { # Нельзя bfl::die
      str="arguments count $# ∉ [3..4]."
      if [[ ${BASH_LOG_LEVEL} -gt ${_BFL_LOG_LEVEL_INFORM} ]]; then
          bfl::inform "$str"
        else
          [[ $BASH_INTERACTIVE == true ]] && printf "%s: %s\n" "${FUNCNAME[0]}" "$str" 2>&1
      fi
      return ${BFL_ErrCode_Not_verified_args_count}
      }

  # Verify arguments' values.
  bfl::is_blank "$2" && { # Нельзя bfl::die
      str="Argument 2 is blank!"
      if [[ ${BASH_LOG_LEVEL} -gt ${_BFL_LOG_LEVEL_INFORM} ]]; then
          bfl::inform "$str"
        else
          [[ ${BASH_INTERACTIVE} == true ]] && printf "%s: %s\n" "${FUNCNAME[0]}" "$str" 2>&1
      fi
      return ${BFL_ErrCode_Not_verified_arg_values}
      }

  # Verify dependencies.
  bfl::verify_dependencies 'sed' || { # Нельзя bfl::die
      str="dependency 'sed' not found!"
      if [[ ${BASH_LOG_LEVEL} -gt ${_BFL_LOG_LEVEL_INFORM} ]]; then
          bfl::inform "$str"
        else
          [[ ${BASH_INTERACTIVE} == true ]] && printf "%s: %s\n" "${FUNCNAME[0]}" "$str" 2>&1
      fi
      return ${BFL_ErrCode_Not_verified_dependency}
      }

  # Check logfile.
  local -r logfile="${4:-$BASH_FUNCTIONS_LOG}"   # LOGFILE="$(pwd)/${0##*/}.log"   # $(basename "$0")
  if ! [[ -f $logfile ]]; then
    local d="${logfile%/*}"  #  $(dirname "$logfile")
    str="cannot create directory '$d'!"
    [[ -d "$d" ]] || mkdir -p "$d" || {
        # Нельзя bfl::die
        if [[ ${BASH_LOG_LEVEL} -gt ${_BFL_LOG_LEVEL_INFORM} ]]; then
            bfl::inform "$str"
          else
            [[ ${BASH_INTERACTIVE} == true ]] && printf "%s: %s\n" "${FUNCNAME[0]}" "$str" 2>&1
        fi
        return ${BFL_ErrCode_Not_verified_arg_values}
        }

    str="cannot create logfile '$logfile'!"
    [[ -f "$logfile" ]] || touch "$logfile" || { # Нельзя bfl::die
        if [[ ${BASH_LOG_LEVEL} -gt ${_BFL_LOG_LEVEL_INFORM} ]]; then
            bfl::inform "$str"
          else
            [[ ${BASH_INTERACTIVE} == true ]] && printf "%s: %s\n" "${FUNCNAME[0]}" "$str" 2>&1
        fi
        return ${BFL_ErrCode_Not_verified_arg_values}
        }

    str="'$logfile' doesn't exists, no rights to create it!"
    [[ -f "$logfile" ]] || { # Нельзя bfl::die
        if [[ ${BASH_LOG_LEVEL} -gt ${_BFL_LOG_LEVEL_INFORM} ]]; then
            bfl::inform "$str"
          else
            [[ ${BASH_INTERACTIVE} == true ]] && printf "%s: %s\n" "${FUNCNAME[0]}" "$str" 2>&1
        fi
        return 1
        }
  fi

  local -r LEVEL=${1:-$BASH_LOG_LEVEL_ERROR}
#  ! [[ "$LOG_LEVEL" -ge "$LEVEL" ]] && { # Нельзя bfl::die Verify argument count.
#      [[ $BASH_INTERACTIVE == true ]] && printf "${FUNCNAME[0]}: error $*\n" > /dev/tty
#      return 1
#      }

  local msg="${2:-}"
  local -r STATUS=${3:-}
#  [[ -z "$STATUS" ]] && echo "$msg" && return 0   # To display a right aligned status we have to take some extra efforts

# Don't use colors in logs https://stackoverflow.com/a/52781213/10495078

# or: local -r msg_="$(printf "%s" "${_message}" | sed -E 's/(\x1b)?\[(([0-9]{1,2})(;[0-9]{1,3}){0,2})?[mGK]//g')"
  local -r msg_="$( sed -E -e "s/\x1B(\[[0-9;]*[JKmsu]|\(B)//g" <<< "$msg" )"
  local -r STATUS_="$( sed -E -e "s/\x1B(\[[0-9;]*[JKmsu]|\(B)//g" <<< "$STATUS" )"
  local msg_width
  msg_width=$(tput cols)
  (( msg_width=msg_width-${#STATUS_} ))

  [[ ${BASH_LOG_SHOW_TIMESTAMP} == true ]] && msg_="$(date '+%Y-%m-%d %H:%M:%S') $msg_"
  printf "\r%-*s%s\n" $msg_width "$msg_" "$STATUS_" >> "$logfile"
  }