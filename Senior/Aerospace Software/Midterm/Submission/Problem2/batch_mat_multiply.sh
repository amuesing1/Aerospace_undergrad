#!/bin/bash

for file1 in $1*
do
  for file2 in $1*
  do
    ./mat_multiply $file1 $file2
  done
done
