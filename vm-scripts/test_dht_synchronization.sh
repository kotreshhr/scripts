#!/bin/bash

cd /
umount /mnt
echo 'y'| gluster vol stop master
echo 'y'| gluster vol del master
~/scripts/clean_b1.sh
sleep 1
#gluster vol create master replica 2 `hostname`:/bricks/brick0/b0 `hostname`:/bricks/brick1/b0 `hostname`:/bricks/brick0/b1 `hostname`:/bricks/brick1/b1 `hostname`:/bricks/brick0/b2 `hostname`:/bricks/brick1/b2 `hostname`:/bricks/brick0/b3 `hostname`:/bricks/brick1/b3 `hostname`:/bricks/brick0/b4 `hostname`:/bricks/brick1/b4 `hostname`:/bricks/brick0/b5 `hostname`:/bricks/brick1/b5 `hostname`:/bricks/brick0/b6 `hostname`:/bricks/brick1/b6 `hostname`:/bricks/brick0/b7 `hostname`:/bricks/brick1/b7 `hostname`:/bricks/brick0/b8 `hostname`:/bricks/brick1/b8 `hostname`:/bricks/brick0/b9 `hostname`:/bricks/brick1/b9 `hostname`:/bricks/brick0/b10 `hostname`:/bricks/brick1/b10 `hostname`:/bricks/brick0/b11 `hostname`:/bricks/brick1/b11 `hostname`:/bricks/brick2/b0 `hostname`:/bricks/brick3/b0 `hostname`:/bricks/brick2/b1 `hostname`:/bricks/brick3/b1 `hostname`:/bricks/brick2/b2 `hostname`:/bricks/brick3/b2 `hostname`:/bricks/brick2/b3 `hostname`:/bricks/brick3/b3 `hostname`:/bricks/brick2/b4 `hostname`:/bricks/brick3/b4 `hostname`:/bricks/brick2/b5 `hostname`:/bricks/brick3/b5 `hostname`:/bricks/brick2/b6 `hostname`:/bricks/brick3/b6 `hostname`:/bricks/brick2/b7 `hostname`:/bricks/brick3/b7 `hostname`:/bricks/brick2/b8 `hostname`:/bricks/brick3/b8 `hostname`:/bricks/brick2/b9 `hostname`:/bricks/brick3/b9 `hostname`:/bricks/brick2/b10 `hostname`:/bricks/brick3/b10 `hostname`:/bricks/brick2/b11 `hostname`:/bricks/brick3/b11 force
gluster vol create master replica 2 `hostname`:/bricks/brick0/b0 `hostname`:/bricks/brick1/b0 `hostname`:/bricks/brick0/b1 `hostname`:/bricks/brick1/b1 `hostname`:/bricks/brick0/b2 `hostname`:/bricks/brick1/b2 `hostname`:/bricks/brick0/b3 `hostname`:/bricks/brick1/b3 `hostname`:/bricks/brick0/b4 `hostname`:/bricks/brick1/b4 `hostname`:/bricks/brick0/b5 `hostname`:/bricks/brick1/b5 `hostname`:/bricks/brick0/b6 `hostname`:/bricks/brick1/b6 `hostname`:/bricks/brick0/b7 `hostname`:/bricks/brick1/b7 `hostname`:/bricks/brick0/b8 `hostname`:/bricks/brick1/b8 `hostname`:/bricks/brick0/b9 `hostname`:/bricks/brick1/b9 `hostname`:/bricks/brick0/b10 `hostname`:/bricks/brick1/b10 `hostname`:/bricks/brick0/b11 `hostname`:/bricks/brick1/b11 force
gluster vol start master

mount -t glusterfs `hostname`:master /mnt
mount -t glusterfs `hostname`:master /mnt1

echo "BEFORE MKDIR:`date +%H::%M::%S::%N`"
for i in {1..5}
do
    for j in {1..5}
    do
        for k in {1..20}
        do
            mkdir -p /mnt/dir$i/dir$j/dir$k
        done
    done
done &
echo "AFTER MKDIR:`date +%H::%M::%S::%N`"

echo "BEFORE RENAME:`date +%H::%M::%S::%N`"
for i in {1..5}
do
    for j in {1..5}
    do
        for k in {1..20}
        do
            mv /mnt/dir$i/dir$j/dir$k /mnt/dir$i/dir$j/rn_dir$k
        done
    done
done &
echo "AFTER RENAME:`date +%H::%M::%S::%N`"

sleep 1

rm -rf /mnt/* &
echo "AFTER RMDIR:`date +%H::%M::%S::%N`"

for i in {1..5}
do
    for j in {1..5}
    do
        for k in {1..20}
        do
            rmdir /mnt/dir$i/dir$j/rn_dir$k
        done
    done
done
