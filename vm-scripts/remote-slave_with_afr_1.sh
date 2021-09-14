#! /bin/bash

#Del slave vol and Clean backend bricks
echo 'y' | gluster vol stop slave 
echo 'y' | gluster vol del slave 
/root/scripts/clean_b1.sh

#Create required parent directories
mkdir -p /bricks/brick1/b1/
mkdir -p /bricks/brick2/b2/
mkdir -p /bricks/brick3/b3/
mkdir -p /bricks/brick4/b4/
