#!/bin/bash
i=0
for(($1;$i<$2;i++))
do
    tilix -e "traceroute --protocol=$i 194.199.227.239"
done
