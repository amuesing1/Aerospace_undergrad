#!/bin/bash

i=1
for file in *."$2"
do
  if [ $i <"9" ]; then
    name="$10$i.$2"
  else
    name="$100$i.$2"
  fi
  mv "$file" "$name"
  i=$(($i+1))
done
