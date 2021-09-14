#! /bin/bash

brickpath=$1

ls -lrt $brickpath | awk '{print $9}' | grep "CHANGELOG\.[0..9]*" > ~/tmp_chaneglog
while read line
    echo "$brickpath"
do < ~/tmp_changelog

