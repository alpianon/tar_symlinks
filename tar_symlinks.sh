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

# 1) setting English language in order to be able to grep relevant error messages, regardless of system locale settings
# 2) redirecting STDERR to STDOUT, and STDOUT to /dev/null, in order to put error messages in variable $o
cyclic=$(LANG=en_US.UTF-8 find $1 -follow 2>&1 >/dev/null | egrep "File system loop detected|Too many levels of symbolic links")
broken=$(find $1 -xtype l 2>&1)

if [ -z "$cyclic" ] && [ -z "$broken" ]; then
  echo "no cyclic nor broken symlink detected, calling tar normally, with -h option"
  sleep 1
  eval "tar -chvf \"$2\" \"$1\""
  exit 0
fi

excl=""
upd=""

echo "creating tar archive with -h option, excluding the following cyclic or broken symlynks"

#https://stackoverflow.com/questions/918886/how-do-i-split-a-string-on-a-delimiter-in-bash
if [ "$cyclic" ]; then
  IFS=$'\n'; lines=($cyclic); unset IFS;
  if [ "$lines" ]; then
    for line in "${lines[@]}"; do
      IFS="'"; items=($line); unset IFS;
      excl=$excl" --exclude \"${items[1]}\""
      upd=$upd" \"${items[1]}\""
      echo "${items[1]}"
    done
  fi
fi

if [ "$broken" ]; then
  IFS=$'\n'; lines=($broken); unset IFS;
  if [ "$lines" ]; then
    for line in "${lines[@]}"; do
      excl=$excl" --exclude \"$line\""
      upd=$upd" \"$line\""
      echo "$line"
    done
  fi
fi


sleep 1
eval "tar$excl -chvf \"$2\" \"$1\""

echo
echo "adding previously excluded cyclic/broken symlynks to tar archive"
sleep 1
eval "tar -uvf \"$2\"$upd"


