#!/usr/bin/env bash

[[ "$BASH_SOURCE" =~ "${BASH_FUNCTIONS_LIBRARY%/*}" ]] && _bfl_temporary_var="$(bfl::transform_bfl_script_name ${BASH_SOURCE})" || return 0
[[ ${!_bfl_temporary_var} -eq 1 ]] && return 0 || readonly "${_bfl_temporary_var}"=1
#------------------------------------------------------------------------------
# ----------- https://github.com/jmooring/bash-function-library.git -----------
#
# Library of email functions
#
# @author  Joe Mooring
#
# @file
# Defines function: bfl::send_mail_msg().
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# @function
#   Sends an email message via sendmail.
#
# @param String $to
#   Message recipient or recipients.
#   Examples:
#   - foo@example.com
#   - foo@example.com, bar@example.com
#   - Foo <foo@example.com>
#   - Foo <foo@example.com>, Bar <bar@example.com>
#
# @param String $from
#   Message sender.
#   Examples:
#   - foo@example.
#   - Foo <foo@example.com>
#
# @param String $envelope_from
#   Envelope sender address.
#   Example: foo@example.com
#
# @param String $subject
#   Message subject.
#
# @param String $body
#   Message body.
#   Example: "This is line one.\\nThis is line two.\\n"
#
# @example
#   bfl::send_mail_msg "a@b.com" "x@y.com" "x@y.com" "Test" "Line 1.\\nLine 2."
#------------------------------------------------------------------------------
bfl::send_mail_msg() {
  # Verify arguments count.
  [[ $# -eq 5 ]] || { bfl::error "arguments count $# ≠ 5"; return ${BFL_ErrCode_Not_verified_args_count}; }

  # Verify arguments
  bfl::is_blank "$1" && { bfl::error "The message recipient is required.";        return ${BFL_ErrCode_Not_verified_arg_values}; }
  bfl::is_blank "$2" && { bfl::error "The message sender is required.";           return ${BFL_ErrCode_Not_verified_arg_values}; }
  bfl::is_blank "$3" && { bfl::error "The envelope sender address is required.";  return ${BFL_ErrCode_Not_verified_arg_values}; }
  bfl::is_blank "$4" && { bfl::error "The message subject is required.";          return ${BFL_ErrCode_Not_verified_arg_values}; }
  bfl::is_blank "$5" && { bfl::error "The message body is required.";             return ${BFL_ErrCode_Not_verified_arg_values}; }

  # Verify dependencies.
  bfl::verify_dependencies 'sendmail' || return $?

  local -i iErr
  local message # Format the message.                       to  from subject body
  message=$(printf "To: %s\\nFrom: %s\\nSubject: %s\\n\\n%b" "$1" "$2"   "$4"  "$5") ||
    { iErr=$?; bfl::error "printf mail body"; return ${iErr}; }

  # Send the message   envelope_from  to
  echo "$message" | sendmail -f "$3" "$1" || { iErr=$?; bfl::error "cannot send mail from '$3' to '$1'."; return ${iErr}; }
  }