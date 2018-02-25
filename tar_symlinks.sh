#!/bin/bash

#    Copyright (C) 2018 Alberto Pianon
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.


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

