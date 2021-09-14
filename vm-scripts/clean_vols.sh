#!/bin/bash

echo y | gluster vol geo-rep master fedora1::slave stop
echo y | gluster vol geo-rep master fedora1::slave del
echo y | gluster vol stop master
echo y | gluster vol del master

echo y | gluster vol stop slave
echo y | gluster vol del slave

/root/scripts/clean_b1.sh
