#!/bin/bash
#echo "--------------------------Hackbench-------------------------------------"
echo "Hackbench"
find ./ -name 'hackbench.time' | xargs grep "Elap*" | awk '{print $1 "  " $9}' |awk -F/ '{print $3 " " $10;}' | awk '{ split($3, t, ":"); sec = t[1] * 60 + t[2]; print $1 ", " sec; }' | sort |awk '{print int($2 + 0.5)}'

#echo "----------------------------Ebizzy------------------------------------"
echo "ebizzy"

find ./ -name 'ebizzy.time' | xargs grep "Elap*" | awk '{split($NF, t, ":"); sec = (t[1] ~ /h/) ? t[1]*3600 + t[2]*60 + t[3] : t[1]*60 + t[2]; print $1 ", " sec;}'| awk '{print int($2 + 0.5)}'

#echo "--------------------------unixbench-------------------------------------"
echo "Unixbench"

find ./ -name 'unixbench.time' | xargs grep "Elap*" | awk '{print $1 "  " $9}' | awk -F/ '{print $3 " " $10;}' | awk '{ split($3, t, ":"); sec = t[1] * 60 + t[2]; print $1 ", " sec; }' | sort |awk '{print int($2 + 0.5)}'
