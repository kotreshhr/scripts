#! /bin/bash

#Volume creation and starting
#Slave
gluster vol create slave fedora2:/bricks/brick3/b3 
sleep 2 
gluster vol start slave 
sleep 2
