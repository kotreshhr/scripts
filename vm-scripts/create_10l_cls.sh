#! /bin/bash

suf=1534223750
for i in {1..1000000}
do
    touch CHANGELOG.$suf
    let "suf+=15"
done
