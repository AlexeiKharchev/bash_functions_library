#!/usr/bin/env bash

#------------------------------------------------------------------------------
# @file
# Sources files adjacent to (in the same directory as) this script.
#
# This is the required directory structure:
#
# └── library (directory name and location are irrelevant)
#     ├── autoload.sh
#     ├── _file_1.sh
#     ├── _file_2.sh
#     └── _file_3.sh
#
# This script defines and then calls the autoload function.
#
# The autoload function loops through the files in the library directory, and
# sources file names that begin with an underscore.
#
# An "underscore" file should contain one and only one function. To improve
# readability, the file name should be equal to the function name, preceded by
# an underscore.
#
# So here's the scenario...
#
# You are creating a script ($HOME/foo.sh) to parse a text file. You need to
# trim (remove leading and trailing spaces) some strings. Trimming is a common
# task, a capability you are likely to need within other scripts.
#
# Instead of writing a trim function within foo.sh, write the function within
# a new file named _trim.sh in the library directory.
#
# Finally, source path/to/autoload.sh at the beginning of foo.sh. All of the
# functions in the library are now available to foo.sh.
#
# The relative path from foo.sh to autoload.sh is irrelevant.
#
# There is no need to set the executable bit on any of the files in the
# library directory. In fact, Google's "Shell Style Guide" specifically forbids
# this:
#
#   "Libraries must have a .sh extension and should not be executable."
#
# See https://google.github.io/styleguide/shell.xml#File_Extensions.
#
# Logical functions in this library, such as lib::is_integer() or
# lib::is_empty(), should not output any messages. They should only return 0
# if true or return 1 if false.
#
# To simplify usage, place this line at the top of $HOME/.bashrc:
#
#   export BASH_FUNCTION_LIBRARY="$HOME/path/to/autoloader.sh"
#
# Then, at the top of each new script add:
#
#   source "${BASH_FUNCTION_LIBRARY}"
#
# shellcheck disable=SC1090
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# @function
# Sources files adjacent to (in the same directory as) this script.
#
# This will only source file names that begin with an underscore.
#------------------------------------------------------------------------------
autoload() {
  declare this_script_dir
  declare file_path
  this_script_dir=$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")

  for file_path in "${this_script_dir}"/_*; do
    source "${file_path}"
  done
}

autoload