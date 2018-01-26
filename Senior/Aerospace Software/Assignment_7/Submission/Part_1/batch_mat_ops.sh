#!/bin/bash

dir=$(pwd)
cd $1
a=$(ls)

for file1 in $a
do
  for file2 in $a
  do
    for file3 in $a
    do
      ${dir}/mat_ops $file1 $file2 $file3
    done
  done
done
