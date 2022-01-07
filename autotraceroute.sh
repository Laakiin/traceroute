#!/bin/bash

LBLU='\033[1;34m'
YEL='\033[1;33m'
NC='\033[0m'

j=0

FILE="/tmp/out.$$"
GREP="/bin/grep"
if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

if [ -e $2 ]; then
    sudo rm -r $2
fi

mkdir $2

if [[ -n $1 ]]
then
    if [[ -n $2 ]]
    then
        for i in {"-n -I","-n -T -p 80","-n -T -p 443","-n -U -p 53","-n -U -p 123"}
        do
            let "j = j+1"
            echo -e "${LBLU}########## Options: $i ##########${NC}" >> .addrTmp_$j
            traceroute $i $1 | cut -c5-20 | cut -d'.' -f 1,2,3,4 | cut -d" " -f 1 | sed -e "s/eroute/\r/g" >> $2/$j.rte
            done
        echo -e "${YEL}Traceroute finished: ${NC}"
        cat $2/*.rte
        rm .addrTmp*
    else
        echo "You have to precise the host as the first argument and the file name in which you will save as a second argument"
    fi
else
    echo "You have to precise the host as the first argument and the file name in which you will save as a second argument"
fi

