#!/usr/bin/env bash

#------------------------------------------------------------------------------
# @file
# Defines function: bfl::die().
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# @function
# Prints an error message to stderr and exits with status code 1.
#
# The message provided will be prepended with "Error. "
#
# @param string $msg (optional)
#   The error message.
#
# @example
#   bfl::error "The foo is bar."
#
# shellcheck disable=SC2154
#------------------------------------------------------------------------------
bfl::die() {
  # Verify argument count.
  bfl::verify_arg_count "$#" 0 1 || exit 1

  # Declare positional arguments (readonly, sorted by position).
  declare -r msg="${1:-"Unknown error."}"

  # Declare all other variables (sorted by name).
  declare stack

  # Build a string showing the "stack" of functions that got us here.
  stack="${FUNCNAME[*]}"
  stack="${stack// / <- }"

  # Print the message.
  printf "%b\\n" "${red}Error. ${msg}${reset}" 1>&2

  # Print the stack.
  printf "%b\\n" "${yellow}[${stack}]${reset}" 1>&2

  exit 1
}
