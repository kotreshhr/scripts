#!/bin/bash

run=$1

#Restart gluster
pkill gluster
glusterd
sleep 2

#Umount /ce-mastermnt
umount /mastermnt
umount /ce-mastermnt
umount /cd-mastermnt

#Stop volume
echo 'y' | gluster vol stop master
#Del volume
echo 'y' | gluster vol delete master
#Clean bricks
/root/scripts/clean_bricks.sh

#Restart gluster
pkill gluster
glusterd
sleep 2

#Create gluster volume
gluster volume create master replica 3 kotresh:/brick1/b1 kotresh:/brick2/b2 kotresh:/brick3/b3 kotresh:/brick4/b4 kotresh:/brick5/b5 kotresh:/brick6/b6 kotresh:/brick7/b7 kotresh:/brick8/b8 kotresh:/brick9/b9 kotresh:/brick10/b10 kotresh:/brick11/b11 kotresh:/brick12/b12 force

#Start master
gluster vol start master

#Mount the volume
mount -t glusterfs kotresh:master /ce-mastermnt

#Start profile
gluster vol profile master start

#Create result directory
mkdir -p /root/smallfile_results/ctime_enabled/upstream/run${run}

#Run perf test
/root/sandbox/upstream/smallfile/smallfile_cli.py --stonewall N --operation create --threads 4 --file-size 64 --files 5000 --top /ce-mastermnt --host-set kotresh --output-json /root/smallfile_results/ctime_enabled/upstream/run${run}/create

<<STATEDUMP_CREATE
#Get Statedump
client_pid=$(ps -ef | grep glusterfs | grep ce-mastermnt | awk '{print $2}')
kill -USR2 $client_pid 
kill -USR1 $client_pid 
kill -USR2 $client_pid 

brick_pid1=$(ps -ef | grep glusterfsd | grep -F "/brick1/b1" | awk '{print $2}')
brick_pid2=$(ps -ef | grep glusterfsd | grep -F "/brick2/b2" | awk '{print $2}')
brick_pid3=$(ps -ef | grep glusterfsd | grep -F "/brick3/b3" | awk '{print $2}')
brick_pid4=$(ps -ef | grep glusterfsd | grep -F "/brick4/b4" | awk '{print $2}')
brick_pid5=$(ps -ef | grep glusterfsd | grep -F "/brick5/b5" | awk '{print $2}')
brick_pid6=$(ps -ef | grep glusterfsd | grep -F "/brick6/b6" | awk '{print $2}')
kill -USR2 $brick_pid1 $brick_pid2 $brick_pid3 $brick_pid4 $brick_pid5 $brick_pid6
kill -USR1 $brick_pid1 $brick_pid2 $brick_pid3 $brick_pid4 $brick_pid5 $brick_pid6
kill -USR2 $brick_pid1 $brick_pid2 $brick_pid3 $brick_pid4 $brick_pid5 $brick_pid6
STATEDUMP_CREATE


#Capture create profile
setfattr -n trusted.io-stats-dump -v create-ce-mastermnt /ce-mastermnt
gluster vol profile master info > /root/smallfile_results/ctime_enabled/upstream/run${run}/create_profile

#Clear profile info
gluster vol profile master info clear

/root/sandbox/upstream/smallfile/smallfile_cli.py --stonewall N --operation rename --threads 4 --file-size 64 --files 5000 --top /ce-mastermnt --host-set kotresh --output-json /root/smallfile_results/ctime_enabled/upstream/run${run}/rename

<<STATEDUMP_RENAME
#Get Statedump
kill -USR2 $client_pid 
kill -USR1 $client_pid 
kill -USR2 $client_pid 

kill -USR2 $brick_pid1 $brick_pid2 $brick_pid3 $brick_pid4 $brick_pid5 $brick_pid6
kill -USR1 $brick_pid1 $brick_pid2 $brick_pid3 $brick_pid4 $brick_pid5 $brick_pid6
kill -USR2 $brick_pid1 $brick_pid2 $brick_pid3 $brick_pid4 $brick_pid5 $brick_pid6
STATEDUMP_RENAME

#Capture rename profile
setfattr -n trusted.io-stats-dump -v rename-ce-mastermnt /ce-mastermnt
gluster vol profile master info > /root/smallfile_results/ctime_enabled/upstream/run${run}/rename_profile
