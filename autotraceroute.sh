#!/bin/bash

FILE="/tmp/out.$$"
GREP="/bin/grep"
if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

if [[ -n $1 ]]
then
    if [[ -n $2 ]]
    then
        for i in {"-n -I","-n -T","-n U","-n -UL"}
        do
            echo '############################# Options:' $i
            traceroute $i $1 | cut -c5-20 | cut -d'.' -f 1,2,3,4 | cut -d" " -f 1 | tail -n> .addrTmp
            cat .addrTmp
            cat .addrTmp > $2
        done
        rm .addrTmp
    else
        echo "You have to precise the host as the first argument and the file name in which you will save as a second argument"
    fi
else
    echo "You have to precise the host as the first argument and the file name in which you will save as a second argument"
fi

