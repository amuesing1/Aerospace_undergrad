#!/bin/bash

total=$((cut -d';' -f2 $1 | tr "\012" "+" ; echo "0") | bc)
lines=$(cat $1 | wc -l)
# The files in this assignment don't have a new line after
# the final score, must add 1 as result.
lines=$(($lines+1))
echo "scale=1 ; $total / $lines" | bc
