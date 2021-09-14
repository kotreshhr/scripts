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

ssh root@fedora1 'bash -s' < /root/scripts/clean_bricks.sh 3 
ssh root@fedora1 'bash -s' < /root/scripts/clean_bricks.sh 4
ssh root@fedora1 'mkdir -p /bricks/brick3/b3; mkdir -p /bricks/brick4/b4'
ssh root@fedora1 'mount -a'

#Volume creation and starting
#Slave
gluster vol create slave replica 2 fedora2:/bricks/brick3/b3/A fedora1:/bricks/brick3/b3/A fedora2:/bricks/brick4/b4/B fedora1:/bricks/brick4/b4/B
sleep 2 
gluster vol start slave 
sleep 2
