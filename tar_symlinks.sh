#!/bin/bash

if [ -z "$1" ] || [ -z "$2" ] || [ "$1" == "-h" ]
  then
    echo "usage: ${0##*/} [DIR TO ARCHIVE] [TAR FILE NAME]"
    exit 1
fi

# 1) setting English language in order to be able to grep relevant error messages
# 2) redirecting STDERR to STDOUT, and STDOUT to /dev/null
o=$(LANG=en_US.UTF-8 find $1 -follow 2>&1 >/dev/null | grep "find: File system loop detected")

#https://stackoverflow.com/questions/918886/how-do-i-split-a-string-on-a-delimiter-in-bash
if [ "$o" ]; then 
  IFS=$'\n'; lines=($o); unset IFS; 
fi

excl=""

if [ "$lines" ]; then
  for line in "${lines[@]}"; do
    IFS="'"; items=($line); unset IFS;
    excl=$excl" --exclude \"${items[1]}\""
    echo "Excluding filesystem loop \"${items[1]}\""
  done
fi
sleep 2 
echo "Creating tar archive..."
eval "tar$excl -chvf \"$2\" \"$1\""

