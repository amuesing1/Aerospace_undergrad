#!/bin/bash

for obj in 1 2
do
for num in 0 10 100 1000 5000 10000 50000 100000
do
  ./ThreeBody $obj $num 0.5
done
done
