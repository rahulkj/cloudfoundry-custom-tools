#!/bin/bash

set -e

source "$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"/.set-env.sh

###
# Gets the real directory for a script
##
__DIR__() {
  echo "$( cd "$( dirname "${BASH_SOURCE[${#BASH_SOURCE[@]}-1]}" )" && pwd )"
}

###
# Description:
#   Initializes common setup for the clean-up-pipelines-json module.
#
# Usage:
#   To import this file, add
#       `source "$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"/$RELATIVE_PATH/.init.sh`
#     where `RELATIVE_PATH` is the relative path to this file from the file importing it
##

LOGFILE=${LOGFILE:-/dev/null}
JQ_CMD=${JQ_CMD:-jq}

DEPENDENCIES=(JQ_CMD)

###
# Collects the arguments
##
collect_args() {
  while getopts 'l:o:vx' param; do
    case $param in
      l ) # logfile
        LOGFILE="$OPTARG"
        ;;
      o ) # output directory
        OUTPUT="$OPTARG"
        ;;
      v ) # verbose
        LOGFILE=/dev/stdout
        ;;
      x ) # Print variables
        set -x
        ;;
    esac
  done

  shift $(($OPTIND - 1))
}

###
# Simply logs output to the $LOGFILE
#
# @param {*} args Information to log to the logfile
##
log() {
  echo $@ >> "$LOGFILE"
}

###
# Sends the message to stderr and exits the script with a status of `ERR_CODE` defaulted to 255
#
# @param {*} args Information to log to stderr
#
# @env int ERR_CODE The error code to exit with
##
error() {
  echo $@ 1>&2
  exit ${ERR_CODE:-255}
}

collect_args $@

## Validation

if [ -z "$OUTPUT_DIR" ]; then
  ERR_CODE=2 error "Missing needed OUTPUT_DIR"
fi

# Create the OUTPUT directory if not present
if [ ! -d "$OUTPUT_DIR" ]; then
  log "Creating directory $OUTPUT_DIR"
  mkdir -p "$OUTPUT_DIR"
fi

#

log "Checking dependencies"
for dep in ${DEPENDENCIES[@]}; do
  log "Variable $dep was set to command ${!dep}"
  if ! hash "${!dep}"; then
    ERR_CODE=3 error "Missing required dependency: ${!dep}.  You can set the $dep environment variable to change the location of this executable"
  fi
done


unset DEPENDENCIES

export -f log \
  error \
  __DIR__

# .init.sh
