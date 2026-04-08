#!/bin/bash

f_count=0
d_count=0

for item in *; do
    if [ -f "$item" ]; then
        ((f_count++))
    elif [ -d "$item" ]; then
        ((d_count++))
    fi
done

echo "파일 수 : $f_count"
echo "디렉토리 수 : $d_count"
