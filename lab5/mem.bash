#!/bin/bash

array=()
cnt=0

echo "" > report.log

while true
do
    array+=(1 2 3 4 5 6 7 8 9 10)
    if [[ $(($cnt % 100000)) -eq 0 ]]
    then
        echo ${#array[@]} >> report.log
    fi
    cnt=$(($cnt+1))
done