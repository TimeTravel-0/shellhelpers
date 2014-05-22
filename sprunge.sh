#!/bin/bash

let maxsize=48*1024 # bytes

for i in ${*:1};
do

    file=$i
    if [[ -z "$file" ]]; then
        echo "$0 <some file name>"
    else
        if [[ ! -f "$file" ]]; then
            echo "not found"
        else

            size=$(wc -c "$file" | cut -f 1 -d ' ')
            if [ $maxsize -ge $size ]; then
                cat $file | curl -F 'sprunge=<-' http://sprunge.us
            else
                let size_kb=$size/1024
                let maxsize_kb=$maxsize/1024
                echo "size is over $maxsize_kb KB ($size_kb KB)"
            fi
        fi
    fi
done


