#! /bin/bash

/root/scripts/clean_b1.sh
/root/scripts/all_log_0

gluster vol create slave fedora2:/bricks/brick0/b0 force
sleep 1
gluster vol start slave
sleep 1
