#!/bin/bash
YEL='\033[1;33m'
RED='\033[0;31m'
BLU='\033[0;34m'
NC='\033[0m'

if [ "$EUID" -ne 0 ]
then
    echo -e "${RED}You have to run this script as root${NC}"
    exit
fi

echo -e "${BLU}Noice${NC}"
