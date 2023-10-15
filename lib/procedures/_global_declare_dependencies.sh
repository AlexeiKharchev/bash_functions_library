#!/usr/bin/env bash

[[ "$BASH_SOURCE" =~ "${BASH_FUNCTIONS_LIBRARY%/*}" ]] && _bfl_temporary_var="$(bfl::transform_bfl_script_name ${BASH_SOURCE})" || return 0
[[ ${!_bfl_temporary_var} -eq 1 ]] && return 0 || readonly "${_bfl_temporary_var}"=1
#------------------------------------------------------------------------------
# --------- https://github.com/AlexeiKharchev/bash_functions_library ----------
#
# Library of internal library functions
#
# @author  Alexei Kharchev
#
# @file
# Defines function: bfl::global_declare_dependencies().
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# @function
#   Declare whole list dependencies
#
# @example
#   bfl::global_declare_dependencies 'sed' 'grep' 'head' ...
#------------------------------------------------------------------------------
bfl::global_declare_dependencies() {
  # Verify arguments count.
  (( $#>= 1 && $#<= 999 )) || bfl::die "arguments count $# ∉ [1..999]" ${BFL_ErrCode_Not_verified_args_count}

  # grep -rnw lib/* -e 'bfl::verify_dependencies' | sed -n '/^[^:]*_verify_dependencies.sh:/!p' | sed 's/#.*$//' | sed 's/#.*$//' | sed 's/^.*bfl::verify_dependencies \([^|]*\) ||.*$/\1/' | sed 's/^.*bfl::verify_dependencies \([^\&]*\) \&\&.*$/\1/' | sed 's/^"\(.*\)"[ ]*$/\1/' | sort | uniq

  local f h
  for f in "$@"; do
      h="${f/-/_}"
      h="_BFL_HAS_${h^^}"
      [[ ${!h} -eq 1 ]] && continue

      bfl::command_exists "$f" && declare -gr "$h"=1 # || declare -gr "$h"=0
  done
  }
