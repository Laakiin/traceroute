#!/bin/bash

LBLU='\033[1;34m'
YEL='\033[1;33m'
NC='\033[0m'
RED='\033[1;31m'
GRE='\033[1;32m'
BOLD=$(tput bold)

declare -a colors=("aqua" "blue" "crimson" "chartreuse" "darkgoldenrod1" "darkorchid1" "deeppink" "gray1" "gray24" "aquamarine3" "chocolate4" "fuchsia" "darkgreen" "darkorange" "cyan4")

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
echo "digraph routes {" >> $2/dotFile
color=0
if [[ -n $1 ]]
then
    if [[ -n $2 ]]
    then
        for (( f=1 ; f<=nbElem ; f++ ))
        do
            site=$(cut -d',' -f $f $1)
            mkdir $2/$site
            mkdir $2/.tmp/$site
            echo -e "${YEL}     Site: $site  ${NC}"
            for i in {"-n -I","-n -T -p 80","-n -T -p 443","-n -U -p 53","-n -U -p 123","-n -T -p 20","-n -T -p 25","-n -T -p 37","-n -U -p 37","-n -T -p 992"}
            do
                echo -e "${LBLU}        Beggining the route of $site with these options: $i ${NC} ..."
                let "j = j+1"
                traceroute $i $site | cut -c5-20 | cut -d'.' -f 1,2,3,4 | cut -d" " -f 1 | sed -e "s/eroute/\r/g" >> $2/$site/$j.rte
                touch $2/$site/$j.csv
                touch $2/.tmp/$j
                sed  's/.*/&"->/' $2/$site/$j.rte > $2/.tmp/$site/$j
                sed  's/^/"/' $2/.tmp/$site/$j > $2/.tmp/$site/$j.dot
                sed -i '1d' $2/.tmp/$site/$j.dot
                cat $2/.tmp/$site/$j.dot | sed s/\*//g | sed s/\"\"\-\>//g >> $2/.tmp/$site/$j.aled
                cat $2/.tmp/$site/$j.aled | tr -d '\n' >> $2/$site/$j.dot
                echo -e "${GRE}             Done. ${NC}"

            done
        dot=$(cat $2/$site/$j.dot)
        echo "${dot::-2}[color=${colors[$color]}];" >> $2/dotFile
        echo -e  "${YEL} Color of $site is ${NC}${BOLD} ${colors[$color]}  ${NC} "
        let "color = color+1"
    done
    echo -e "${YEL}Traceroute finished ${NC}"
    #echo "}" >> $2/dotFile
    sudo rm -r $2/.tmp/
    let "color = 0"
    #echo "digraph legende {" >> $2/dotFile

    for (( f=1 ; f<=nbElem ; f++ ))
    do
        site=$(cut -d',' -f $f $1)
        echo " \"Caption\" -> \"$site\" -> \"${colors[$color]}\" [color=${colors[$color]} bgcolor=${colors[$color]}];" >> $2/dotFile
        let "color = color+1"
    done

    echo "}" >> $2/dotFile
    dot -Tpng dotFile > routeMap.png
    xdot $2/dotFile
    else
        echo -e "${RED}You have to precise the host list(csv file) as the first argument and the file name in which you will save as a second argument${NC}"
    fi
else
    echo -e "${RED}You have to precise the host list(csv file) as the first argument and the file name in which you will save as a second argument${NC}"
fi
