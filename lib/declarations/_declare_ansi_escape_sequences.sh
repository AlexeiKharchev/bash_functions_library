#!/usr/bin/env bash

[[ "$BASH_SOURCE" =~ "${BASH_FUNCTIONS_LIBRARY%/*}" ]] && _bfl_temporary_var="$(bfl::transform_bfl_script_name ${BASH_SOURCE})" || return 0
[[ ${!_bfl_temporary_var} -eq 1 ]] && return 0 || readonly "${_bfl_temporary_var}"=1
#------------------------------------------------------------------------------
# ------------- https://github.com/jmooring/bash-function-library -------------
#
# Library of functions related to constants declarations
#
# @author  Joe Mooring
#
# @file
# Defines and calls function: bfl::declare_ansi_escape_sequences().
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# @function
#   Declares ANSI escape sequences.
#
# These are ANSI escape sequences for controlling a VT100 terminal. Examples
# for using these constants within a script:
#
#   echo -e "${bfl_aes_yellow}foo${bfl_aes_reset}"
#   printf "${bfl_aes_yellow}%s${bfl_aes_reset}\\n" "foo"
#   printf "%b\\n" "${bfl_aes_yellow}foo${bfl_aes_reset}"
#
# In some cases it may be desirable to disable color output. For example, let's
# say you've written a script leveraging this library. When you run the script
# in a terminal, you'd like to see the error messages in color. However, when
# run as a cron job, you don't want to see the ANSI escape sequences
# surrounding error messages when viewing logs or emails sent by cron.
#
# To disable color output, set the BASH_FUNCTIONS_LIBRARY_COLOR_OUTPUT
# environment variable to "disabled" before sourcing the autoloader. For
# example:
#
#   export BASH_FUNCTIONS_LIBRARY_COLOR_OUTPUT=disabled
#   source "${BASH_FUNCTIONS_LIBRARY}" || {
#     printf "Error. Unable to source BASH_FUNCTIONS_LIBRARY.\\n" 1>&2
#     exit 1
#     }
#
# FOR 'black' 'red' 'green' 'yellow' 'blue' 'magenta' 'cyan' 'white'
#
# @return global string $bfl_aes_color
#   ANSI escape sequence for color.
#
# @return global string $bfl_aes_color_bold
#   ANSI escape sequence for color + bold.
#
# @return global string $bfl_aes_color_faint
#   ANSI escape sequence for color + faint.
#
# @return global string $bfl_aes_color_underline
#   ANSI escape sequence for color + underline.
#
# @return global string $bfl_aes_color_blink
#   ANSI escape sequence for color + blink.
#
# @return global string $bfl_aes_color_reverse
#   ANSI escape sequence for color + reverse.
#
# -----------------------------------------------------------------------------
# @return global string $bfl_aes_reset
#   ANSI escape sequence for WITHOUT_COLOR
#
# @example:
#   bfl::declare_ansi_escape_sequences
#------------------------------------------------------------------------------
bfl::declare_ansi_escape_sequences() {
  [[ "${BASH_COLOURED:=true}" =~ ^1|yes|true$ ]] && local -r bEnabled=true || local -r bEnabled=false
#  [[ "$TERM" =~ 256color ]] && local use256=true || local use256=false
#                                                       magenta = purple
  local ar_clrs=('black' 'red' 'green' 'yellow' 'blue' 'magenta' 'purple' 'cyan' 'white')
  local ar_nmbrs=(30 31 32 33 34 35 35 36 37)
  local bkgrnd=(0 103 0 0 0 0 0 0)

  local max=${#ar_clrs[@]}
  local -i {i,iNumbr,iBackgrnd}=0
  local {s,sb,sColor}=

  for ((i = 0; i < max; i++)); do
      sColor=${ar_clrs[$i]}
      iNumbr=${ar_nmbrs[$i]}
      iBackgrnd=${bkgrnd[$i]}; [[ $iBackgrnd -eq 0 ]] && sb="" || sb=";${iBackgrnd}"
      s="bfl_aes_${sColor}";              $bEnabled && readonly "$s"="\\033[0;${iNumbr}m"       || readonly "$s"=""
      s="bfl_aes_${sColor}_bold";         $bEnabled && readonly "$s"="\\033[1;${iNumbr}m"       || readonly "$s"=""
      s="bfl_aes_${sColor}_faint";        $bEnabled && readonly "$s"="\\033[2;${iNumbr}m"       || readonly "$s"=""
      s="bfl_aes_${sColor}_underline";    $bEnabled && readonly "$s"="\\033[4;${iNumbr}m"       || readonly "$s"=""
      s="bfl_aes_${sColor}_blink";        $bEnabled && readonly "$s"="\\033[5;${iNumbr}${sb}m"  || readonly "$s"=""
      s="bfl_aes_${sColor}_reverse";      $bEnabled && readonly "$s"="\\033[7;${iNumbr}m"       || readonly "$s"=""
      s="bfl_aes_${sColor}_highlighted";  $bEnabled && readonly "$s"="\\033[7;${iNumbr}${sb}m"  || readonly "$s"=""
  done

#                                       \[\033[00m\]
  $bEnabled && readonly bfl_aes_reset="\\033[0m"  || readonly bfl_aes_reset=""
  $bEnabled && readonly bfl_aes_gray="\033[0;37m" || readonly bfl_aes_gray=""
  }

bfl::declare_ansi_escape_sequences

# ------------------------------- VT100 colors --------------------------------

# readonly RED_E='\[\e[0;31m\]'
# readonly PALERED_E=''                #                '\033[38;5;9m'
# readonly LIGHTRED_E='\[\e[1;31m\]'
# readonly GREEN_E='\[\e[0;32m\]'      # '\033[0;32m'   '\033[38;5;2m'
# readonly LIGHTGREEN_E='\[\e[1;32m\]' # '\033[1;32m'   '\033[38;5;10m'
# readonly YELOW_E='\[\e[0;33m\]'
# readonly LIGHTYELOW_E='\[\e[1;33m\]' #                '\033[38;5;11m'
# readonly BLACK_E='\[\e[0;30m\]'
# readonly DARKGRAY_E='\[\e[1;30m\]'
# readonly ORANGE_E='\[\e[1;33m\]'
# readonly BLUE_E='\[\e[0;34m\]'
# readonly PALEBLUE_E=''               #                '\033[38;5;12m'
# readonly LIGHTBLUE_E='\[\e[1;34m\]'  # '\033[1;34m'
# readonly PURPLE_E='\[\e[0;35m\]'
# readonly LIGHTPURPLE_E='\[\e[1;35m\]'
# readonly CYAN_E='\[\e[0;36m\]'       #                 '\033[38;5;14m'
# readonly LIGHTCYAN_E='\[\e[1;36m\]'
# readonly LIGHTGRAY_E='\[\e[0;37m\]'
# readonly WHITE_E='\[\e[1;37m\]'
# readonly NORMAL_E='\[\e[0m\]' # '\033[0m' # No color
