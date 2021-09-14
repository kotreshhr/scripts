#!/bin/bash

gluster vol create master fedora1:/bricks/brick0/b0
#gluster vol create master replica 2 fedora1:/bricks/brick0/b0 fedora1:/bricks/brick0/b0r force
gluster vol start master
gluster vol create slave fedora1:/bricks/brick1/b1
#gluster vol create slave replica 2 fedora1:/bricks/brick1/b1 fedora1:/bricks/brick1/b1r force
gluster vol start slave

#gluster vol create gluster_shared_storage replica 3 fedora1:/bricks/brick2/b00 fedora1:/bricks/brick2/b01 fedora1:/bricks/brick2/b02 force
#gluster vol start gluster_shared_storage
sleep 1
#mkdir -p /var/run/gluster/shared_storage
#mount -t glusterfs fedora1:gluster_shared_storage /var/run/gluster/shared_storage

#gluster volume set slave features.shard on
#gluster volume set slave strict-write-ordering on
#gluster volume set master features.shard on
#gluster volume set master strict-write-ordering on

#/root/scripts/group-virt.sh master
#/root/scripts/group-virt.sh slave

georepsetup master fedora1 slave

#gluster vol geo-rep master fedora1::slave config use_meta_volume true
