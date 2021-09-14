#! /bin/bash

#Del slave vol and Clean backend bricks
echo 'y' | gluster vol stop slave 
echo 'y' | gluster vol del slave 
/root/scripts/clean_b1.sh

#Volume creation and starting
#Slave
echo 'y' | gluster vol create slave replica 2 fedora2:/bricks/brick1/b1 fedora2:/bricks/brick2/b2 fedora2:/bricks/brick3/b3 fedora2:/bricks/brick4/b4
sleep 2 
gluster vol start slave 
sleep 2
