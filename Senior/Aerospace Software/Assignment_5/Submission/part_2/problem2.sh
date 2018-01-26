#!/bin/bash

if [[ -d $1 ]]; then
    echo "$1 is a directory with permissions:"
elif [[ -f $1 ]]; then
    echo "$1 is a file with permissions:"
else
    echo "$1 is not valid"
    exit 1
fi
permission=$(stat -c "%a" $1 | grep -o '.\{1\}$')
if [ $permission -eq "0" ]; then
	echo "Can't do shit"
elif [ $permission -eq "1" ]; then
	echo "Execute"
elif [ $permission -eq "2" ]; then
        echo "Write"
elif [ $permission -eq "3" ]; then
        echo "Write and Execute"
elif [ $permission -eq "4" ]; then
        echo "Read"
elif [ $permission -eq "5" ]; then
        echo "Read and Execute"
elif [ $permission -eq "6" ]; then
        echo "Read and Write"
elif [ $permission -eq "7" ]; then
        echo "Read, Write, and Execute"
fi
