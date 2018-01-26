#!/bin/bash

tar -xvzf $1
for file in *
do
  filename=$(basename "$file")
  extension="${filename##*.}"
  filename="${filename%.*}"
  mkdir "$extension"
  if [ $extension == "gz" ]; then
    newname=$filename.$extension
  fi
  for i in *.$extension
  do
    mv $i $extension/
  done
done
for file in *
do
  if [ $file == "gz" ]; then
	   rm -r $file
  fi
done
begining=`echo $newname | awk -F. '{print $1}'`
tar czvf ${begining}_clean.tar.gz *
