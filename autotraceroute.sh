#!/bin/bash

arg=("-n -I" "-n -T" "-n U" "-n -UL")

if [[ -n $1 ]]
then
    echo '#############################"'
    for i in "${arg[@]}"
    do
        traceroute -n -I 8.8.8.8 | cut -c5-20 | cut -d'.' -f 1,2,3,4 | cut -d" " -f 1 > .addrTmp
        cat .addrTmp
    done
else
    echo "You have to precise the host as an argument"
fi

