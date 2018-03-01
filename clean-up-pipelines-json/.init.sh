#!/bin/bash

set -e

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
#
# Parameters:
#   {string} INPUT        The JSON file to cleanup
#   {string} PRODUCT_NAME The name of the product whose JSON is being cleaned up
##

declare INPUT=
declare OUTPUT=${OUTPUT_DIR:-manifests}
declare PRODUCT_NAME=
declare LOGFILE=${LOGFILE:-/dev/null}
declare JQ_CMD=${JQ_CMD:-jq}

declare -a DEPENDENCIES=(JQ_CMD)

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

  INPUT="$1"
  PRODUCT_NAME="$2"

  if [ -z "$PRODUCT_NAME" ]; then
    PRODUCT_NAME="$(basename "$INPUT" .json)"
  fi
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

# Require input
if [ -z "$INPUT" ]; then
  ERR_CODE=2 error "Missing required input"
fi

# Create the OUTPUT directory if not present
if [ ! -d "$OUTPUT" ]; then
  log "Creating directory $OUTPUT"
  mkdir -p "$OUTPUT"
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

export INPUT \
  OUTPUT \
  PRODUCT_NAME \
  LOGFILE
export -f log \
  error \
  __DIR__

# .init.sh
