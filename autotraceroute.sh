#!/bin/bash

LBLU='\033[1;34m'
YEL='\033[1;33m'
NC='\033[0m'

declare -a colors=("aqua", "blue", "crimson", "chartreuse", "darkgoldenrod1", "darkorchid1", "deeppink", "gray1", "gray24")

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
mkdir $2/.tmp
touch $2/dotFile
echo "digraph {" >> $2/dotFile

if [[ -n $1 ]]
then
    if [[ -n $2 ]]
    then
        for i in {"-n -I","-n -T -p 80","-n -T -p 443","-n -U -p 53","-n -U -p 123"}
        do
            let "j = j+1"
            traceroute $i $1 | cut -c5-20 | cut -d'.' -f 1,2,3,4 | cut -d" " -f 1 | sed -e "s/eroute/\r/g" >> $2/$j.rte
            touch $2/$j.csv
            touch $2/.tmp/$j
            sed  's/.*/&"->/' $2/$j.rte > $2/.tmp/$j
            sed  's/^/"/' $2/.tmp/$j > $2/.tmp/$j.dot
            sed -i '1d' $2/.tmp/$j.dot
            cat $2/.tmp/$j.dot | sed s/\*//g | sed s/\"\"\-\>//g >> $2/.tmp/$j.aled
            
            cat $2/.tmp/$j.aled | tr -d '\n' >> $2/$j.dot

        done
        dot=$(cat $2/$j.dot)
        echo "${dot::-2}[color=red];" >> $2/dotFile
        echo -e "${YEL}Traceroute finished: ${NC}"
        cat $2/*.rte
        echo "}" >> $2/dotFile
        xdot $2/dotFile
    else
        echo "You have to precise the host as the first argument and the file name in which you will save as a second argument"
    fi
else
    echo "You have to precise the host as the first argument and the file name in which you will save as a second argument"
fi
