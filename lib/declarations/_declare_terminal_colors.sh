#!/usr/bin/env bash

[[ "$BASH_SOURCE" =~ "${BASH_FUNCTIONS_LIBRARY%/*}" ]] && _bfl_temporary_var="$(bfl::transform_bfl_script_name ${BASH_SOURCE})" || return 0
[[ ${!_bfl_temporary_var} -eq 1 ]] && return 0 || readonly "${_bfl_temporary_var}"=1
#[[ -n $FMT_UNDERLINE ]] && return 0
#------------------------------------------------------------------------------
# https://unix.stackexchange.com/questions/269077/tput-setaf-color-table-how-to-determine-color-codes
# ------------ https://github.com/Jarodiv/bash-function-libraries -------------
#----------- https://github.com/natelandau/shell-scripting-templates ----------
#
# Library of functions related to constants declarations
#
# @authors  Michael Strache, Nathaniel Landau
#
# @file
# Defines and calls function: bfl::declare_terminal_colors().
#------------------------------------------------------------------------------

# Clean up before setting anything
unset CLR_GOOD CLR_INFORM CLR_WARN CLR_BAD CLR_HILITE CLR_BRACKET CLR_NORMAL  # Reset all colors
unset FMT_BOLD FMT_UNDERLINE                                                  # Reset all formatting options
#------------------------------------------------------------------------------
# @function
#   Setup the colors depending on what the terminal supports.
#
# -----------------------------------------------------------------------------
# @return global value  $TPUT_COLOR
#   color value
#
# @example:
#   bfl::declare_terminal_colors
#------------------------------------------------------------------------------
# shellcheck disable=SC2154
bfl::declare_terminal_colors() {
#  DANGER! Circular dependency
#  bfl::verify_dependencies 'tput' || return $?

  local clr="${BASH_COLOURED:-true}"
  [[ "${clr,,}" =~ ^yes|true$ ]] && local -r bEnabled=true || local -r bEnabled=false
  local use256=false

  if ( command -v tput ) >/dev/null 2>&1; then
      local -r has_tput=true
  else
      local -r has_tput=false
  fi

  if $has_tput; then  # If tput is present, prefer it over the escape sequence based formatting
      [[ $( tput colors ) -ge 256 ]] >/dev/null 2>&1 && use256=true

      # tput color table   => http://www.calmar.ws/vim/256-xterm-24bit-rgb-color-chart.html
      declare -g DarkGreen="$(tput setaf 2)"    # Вот как достигается яркость!
      $use256 && declare -g Green="$(tput setaf 82)"                || declare -g Green="$(tput bold)$DarkGreen"       # Bright Green

      declare -g DarkYellow="$(tput setaf 3)"
      $use256 && declare -g Yellow="$(tput bold)$(tput setaf 190)"  || declare -g Yellow="$(tput bold)$DarkYellow"     # Bright Yellow

      declare -g DarkRed="$(tput bold)$(tput setaf 1)"
      declare -g PaleRed=$(tput setaf 9)
      $use256 && declare -g Red="$(tput bold)$(tput setaf 196)"     || declare -g Red="$DarkRed"                       # Bright Red

      declare -g DarkCyan="$(tput bold)$(tput setaf 6)"
      $use256 && declare -g Cyan="$(tput bold)$(tput setaf 14)"     || declare -g Cyan="$DarkCyan"                     # Bright Cyan

      declare -g DarkBlue="$(tput bold)$(tput setaf 4)"
      $use256 && declare -g PaleBlue="$(tput bold)$(tput setaf 12)" || declare -g PaleBlue="$DarkBlue"
      $use256 && declare -g Blue="$(tput bold)$(tput setaf 27)"     || declare -g Blue="$DarkBlue"                     # Bright Blue

      declare -g DarkPurple="$(tput bold)$(tput setaf 13)"
      $use256 && declare -g Purple="$(tput setaf 171)"              || declare -g Purple="$DarkPurple"

      declare -g DarkOrange="$(tput bold)$(tput setaf 178)"
      declare -g Orange="$(tput bold)$(tput setaf 220)"

      $use256 && declare -g White="$(tput setaf 231)"               || declare -g White="$(tput setaf 7)"
      $use256 && declare -g Gray="$(tput setaf 250)"                || declare -g Gray="$(tput setaf 7)"

      readonly NC=$(tput sgr0) # No color

      # Enable additional formatting for 256 color terminals (on 8 color terminals the formatting likely is implemented as a brighter color rather than a different font)
      readonly FMT_BOLD="$(tput bold)"
      readonly FMT_UNDERLINE="$(tput smul)"
      readonly FMT_REVERSE="$(tput rev)"
  else
      [[ "$TERM" =~ 256color ]] && use256=true
      # Enable additional formatting for 256 color terminals (on 8 color terminals the formatting likely is implemented as a brighter color rather than a different font)
      $use256 && readonly FMT_BOLD="$(printf '\033[01m')"      # "\033[4;37m"
      $use256 && readonly FMT_UNDERLINE="$(printf '\033[04m')" # "\033[4;37m"
      readonly FMT_REVERSE=""
  fi

  if $bEnabled; then
      if $has_tput; then
          # ---------------------- Logging colors ----------------------
          declare -g CLR_GOOD="$Green"             # Bright Green
          declare -g CLR_INFORM="$Gray"            # Gray
          declare -g CLR_DESCRIPT="$DarkOrange"    # Orange
          declare -g CLR_WARN="$Yellow"            # Bright Yellow
          declare -g CLR_DEBUG="$Purple"           # Bright Purple
          declare -g CLR_BAD="$Red"                # Bright Red
          declare -g CLR_HILITE="$Cyan"            # Bright Cyan
          declare -g CLR_BRACKET="$Blue"           # Bright Blue
          declare -g CLR_NORMAL="$NC"              # no color
      else
          # Escape sequence color table
          # -> https://en.wikipedia.org/wiki/ANSI_escape_code#Colors

          [[ "$TERM" =~ 256color ]] && use256=true || use256=false
          $use256 && declare -g CLR_GOOD="$(     printf '\033[38;5;10m')" || declare -g CLR_GOOD="$(     printf '\033[32;01m')"
          $use256 && declare -g CLR_INFORM="$(   printf '\033[38;5;2m')"  || declare -g CLR_INFORM="$(   printf '\033[37;01m')"  # change to Gray
          $use256 && declare -g CLR_DESCRIPT="$( printf '\033[38;5;11m')" || declare -g CLR_DESCRIPT="$( printf '\033[33;01m')"
          $use256 && declare -g CLR_DEBUG="$(    printf '\033[38;5;11m')" || declare -g CLR_DEBUG="$(    printf '\033[35;01m')"  # change to Purple
          $use256 && declare -g CLR_WARN="$(     printf '\033[38;5;11m')" || declare -g CLR_WARN="$(     printf '\033[33;01m')"
          $use256 && declare -g CLR_BAD="$(      printf '\033[38;5;9m')"  || declare -g CLR_BAD="$(      printf '\033[31;01m')"
          $use256 && declare -g CLR_HILITE="$(   printf '\033[38;5;14m')" || declare -g CLR_HILITE="$(   printf '\033[36;01m')"
          $use256 && declare -g CLR_BRACKET="$(  printf '\033[38;5;12m')" || declare -g CLR_BRACKET="$(  printf '\033[34;01m')"

          readonly CLR_NORMAL="$(printf '\033[0m')"
      fi
  fi
  }

bfl::declare_terminal_colors