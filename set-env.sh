#!/bin/bash

declare __DIR__="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

###
# Description:
#   Initializes variables for the application.  This file depends on the
#     `$ENV_FILE` file to exist.  If not, it will fail and prompt the user to do
#     so.
#
# Notes:
#   The `ENV_FILE` is a configurable variable that by default will use
#     `.env.local`.  The `/.env.*` file glob is ignored to allow multiple
#     environments to be configured without worry of git noticing a change.
#
# Usage:
#   To import this file, add
#       `source "$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"/$RELATIVE_PATH/set-env.sh`
#     where `RELATIVE_PATH` is the relative path to this file from the file importing it
##

EXAMPLE_FILE=env
ENV_FILE=${ENV_FILE:-.env.local}

if [ ! -f "$__DIR__"/"$ENV_FILE" ]; then
  echo "No env file present.  Please fix this issue by: " 1>&2
  echo "  1 ) Copying the $EXAMPLE_FILE to $ENV_FILE" 1>&2
  echo " OR" 1>&2
  echo "  2 ) Set the ENV_FILE environment variable to a suitable env file" 1>&2
  exit 2
fi

source "$__DIR__"/"$ENV_FILE"
