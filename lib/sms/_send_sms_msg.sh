#!/usr/bin/env bash

[[ "$BASH_SOURCE" =~ "${BASH_FUNCTIONS_LIBRARY%/*}" ]] && _bfl_temporary_var="$(bfl::transform_bfl_script_name ${BASH_SOURCE})" || return 0
[[ ${!_bfl_temporary_var} -eq 1 ]] && return 0 || readonly "${_bfl_temporary_var}"=1
#------------------------------------------------------------------------------
# ------------- https://github.com/jmooring/bash-function-library -------------
#
# Library of functions related to sms
#
# @author  Joe Mooring
#
# @file
# Defines function: bfl::send_sms_msg().
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# @function
#   Sends an SMS message via Amazon Simple Notification Service (SNS).
#
# @param String $phone_number
#   Recipient's phone number, including country code.
#
# @param String $message
#   Example: "This is line one.\\nThis is line two.\\n"
#
# @example
#   bfl::send_sms_msg "+12065550100" "Line 1.\\nLine 2."
#------------------------------------------------------------------------------
bfl::send_sms_msg() {
  # Verify arguments count.
  [[ $# -eq 2 ]] || { bfl::error "arguments count $# ≠ 2."; return ${BFL_ErrCode_Not_verified_args_count}; }

  # Verify arguments' values.
  bfl::is_blank "$1" && { bfl::error "The recipient's phone number is required."; return ${BFL_ErrCode_Not_verified_arg_values}; }
  bfl::is_blank "$2" && { bfl::error "The message is required."; return ${BFL_ErrCode_Not_verified_arg_values}; }

  # Verify dependencies.
  bfl::verify_dependencies 'aws' || return $?

  local -r phone_number="$1"
  local -r message="$2"
  local -r phone_number_regex="^\\+[0-9]{6,}$"

  # Make sure phone number is properly formatted.
  if ! [[ "${phone_number}" =~ ${phone_number_regex} ]]; then
      local error_msg
      error_msg="The recipient's phone number is improperly formatted.\\n"
      error_msg+="Phone number '${phone_number}' expected +XXXXXX... (at least six digits)."
      bfl::error "${error_msg}"
      return 1
  fi

  # Backslash escapes such as \n (newline) in the message string must be
  # interpreted before sending the message.
  interpreted_message=$(printf "%b" "${message}") || { bfl::error "printf '%b' ${message}"; return 1; }

  local -i iErr
  # Send the message.
  aws sns publish --phone-number "${phone_number}" --message "${interpreted_message}" ||
      { iErr=$?; bfl::error "aws sns publish --phone-number '${phone_number}' --message '${interpreted_message}'"; return ${iErr}; }
  }