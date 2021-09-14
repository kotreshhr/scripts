#!/bin/bash

cd /
umount /mnt
echo 'y'| gluster vol stop master
echo 'y'| gluster vol del master
gluster vol create master replica 2 `hostname`:/bricks/brick0/b0 `hostname`:/bricks/brick1/b0 `hostname`:/bricks/brick0/b1 `hostname`:/bricks/brick1/b1 `hostname`:/bricks/brick0/b2 `hostname`:/bricks/brick1/b2 force
gluster vol start master

mount -t glusterfs `hostname`:master /mnt

for i in {1..5}
do
    for j in {1..10}
    do
        for k in {1..50}
        do
            mkdir -p /mnt/dir$i/dir$j/dir$k &
        done
    done
done &

for i in {1..5}
do
    for j in {1..10}
    do
        for k in {1..50}
        do
            mv /mnt/dir$i/dir$j/dir$k /mnt/dir$i/dir$j/mv_dir$k &
        done
    done
done &

for i in {1..5}
do
    for j in {1..10}
    do
        for k in {1..50}
        do
            rmdir /mnt/dir$i/dir$j/dir$k &
        done
    done
done &
