#!/usr/bin/env bash

[[ "$BASH_SOURCE" =~ /bash_functions_library ]] && _bfl_temporary_var="$(bfl::transform_bfl_script_name ${BASH_SOURCE})" || return 0
[[ ${!_bfl_temporary_var} -eq 1 ]] && return 0 || readonly "${_bfl_temporary_var}"=1
#------------------------------------------------------------------------------
# --------- https://github.com/AlexeiKharchev/bash_functions_library ----------
#
# Library of functions ......
#
# @author  ...........
#
# @file
# Defines function: bfl::library_function(). # TODO
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# @function
#   Does something. # TODO
#
# Detailed description. Use multiple lines if needed. # TODO
#
# @param type $foo # TODO
#   Description. # TODO
#
# @param type $bar # TODO
#   Description. # TODO
#
# @return type $baz # TODO
#   Description. # TODO
#
# @example
#   bfl::library_function "Fred" "George" # TODO
#------------------------------------------------------------------------------
bfl::library_function() {
  # Verify arguments count.
  (( $# > 0 && $# < 3 )) || { bfl::error "arguments count $# ∉ [1..2]."; return ${BFL_ErrCode_Not_verified_args_count}; }

  # Verify dependencies.
  bfl::verify_dependencies "printf" # TODO

  # Declare positional arguments (readonly, sorted by position).
  local -r foo="$1" # TODO
  local -r bar="$2" # TODO

  # Declare return value.
  local baz # TODO

  # Declare readonly variables (sorted by name).
  local -r wibble="Harry" # TODO
  local -r wobble="Ron" # TODO

  # Declare all other variables (sorted by name).
  local eggs="Dean" # TODO
  local ham="Seamus" # TODO

  # Verify argument values.
  bfl::is_blank "${foo}" && { bfl::error "Foo is required."; return 1; } # TODO
  bfl::is_blank "${bar}" && { bfl::error "Bar is required."; return 1; } # TODO

  # Build the return value.
  baz="${foo}, ${bar}, ${wibble}, ${wobble}, ${eggs}, and ${ham}." # TODO

  # Print the return value.
  printf "%s\\n" "${baz}" # TODO
  }