#!/bin/bash

LBLU='\033[1;34m'
YEL='\033[1;33m'
NC='\033[0m'
RED='\033[0;31m'

declare -a colors=("aqua", "blue", "crimson", "chartreuse", "darkgoldenrod1", "darkorchid1", "deeppink", "gray1", "gray24")

nbElem=$(grep -o , $1 | wc -l)   
let nbElem=nbElem+1

echo -e "${LBLU}$nbElem elements in $1 ${NC}"

j=0

FILE="/tmp/out.$$"
GREP="/bin/grep"
if [ "$(id -u)" != "0" ]; then
   echo -e  "${RED}This script must be run as root${NC}" 1>&2
   exit 1
fi

if [ -e $2 ]; then
    sudo rm -r $2
fi

mkdir $2
mkdir $2/.tmp
touch $2/dotFile
echo "digraph {" >> $2/dotFile

color=0

if [[ -n $1 ]]
then
    if [[ -n $2 ]]
    then
        for (( f=1 ; f<=nbElem ; f++ ))
        do
            site=$(cut -d',' -f $f)
            
            for i in {"-n -I","-n -T -p 80","-n -T -p 443","-n -U -p 53","-n -U -p 123"}
            do
                echo -e "${LBLU} Beggining the route of $site with this options; $i ${NC}"
                let "j = j+1"
                traceroute $i $site | cut -c5-20 | cut -d'.' -f 1,2,3,4 | cut -d" " -f 1 | sed -e "s/eroute/\r/g" >> $2/$j.rte
                touch $2/$site/$j.csv
                touch $2/.tmp/$j
                sed  's/.*/&"->/' $2/$site/$j.rte > $2/.tmp/$site/$j
                sed  's/^/"/' $2/.tmp/$site/$j > $2/.tmp/$site/$j.dot
                sed -i '1d' $2/.tmp/$site/$j.dot
                cat $2/.tmp/$site/$j.dot | sed s/\*//g | sed s/\"\"\-\>//g >> $2/.tmp/$site/$j.aled
            
                cat $2/.tmp/$site/$j.aled | tr -d '\n' >> $2/$site/$j.dot

            done
        dot=$(cat $2/$site/$j.dot)
        echo "${dot::-2}[color=${colors[$color]};" >> $2/dotFile
        let "color = color+1"
    done
    echo -e "${YEL}Traceroute finished: ${NC}"
    cat $2/*.rte
    echo "}" >> $2/dotFile
    xdot $2/dotFile
    else
        echo -e "${RED}You have to precise the host list(csv file) as the first argument and the file name in which you will save as a second argument${NC}"
    fi
else
    echo -e "${RED}You have to precise the host list(csv file) as the first argument and the file name in which you will save as a second argument${NC}"
fi
