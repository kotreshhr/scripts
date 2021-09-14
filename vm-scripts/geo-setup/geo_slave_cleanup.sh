#!/bin/bash

iptables -F
echo 'y' | gluster vol stop slave
echo 'y' | gluster vol delete slave
sleep 1
