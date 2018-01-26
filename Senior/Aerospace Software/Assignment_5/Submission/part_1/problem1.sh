#!/bin/bash

read -p "Enter First Number: "  a
read -p "Enter Second Number: "  b
range=$(($b-$a+1))
for number in $(seq 1 $range)
do
	answer=$(($a+$number-1))
	echo $answer
done
