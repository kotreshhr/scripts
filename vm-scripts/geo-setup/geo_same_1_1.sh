#! /bin/bash
echo 'y' | gluster vol geo-rep master `hostname`::slave stop
sleep 1
echo 'y' | gluster vol geo-rep master `hostname`::slave delete
sleep 1
echo 'y' | gluster vol stop master
sleep 1
echo 'y' | gluster vol del master
sleep 1
echo 'y' | gluster vol stop slave
sleep 1
echo 'y' | gluster vol del slave 
/root/scripts/clean_b1.sh
/root/scripts/all_log_0
ldconfig /usr/local/lib
gluster vol create master `hostname`:/bricks/brick0/b0
#gluster vol create master disperse 6 `hostname`:/bricks/brick0/b0 `hostname`:/bricks/brick0/b01 `hostname`:/bricks/brick0/b02 `hostname`:/bricks/brick0/b03 `hostname`:/bricks/brick0/b04 `hostname`:/bricks/brick0/b05 force

#gluster vol create master replica 2 `hostname`:/bricks/brick0/b0 `hostname`:/bricks/brick0/b01 force
gluster vol start master
sleep 1
mount -t glusterfs `hostname`:master /mastermnt
gluster vol create slave `hostname`:/bricks/brick1/b1
#gluster vol create slave disperse 6 `hostname`:/bricks/brick1/b1 `hostname`:/bricks/brick1/b11 `hostname`:/bricks/brick1/b12 `hostname`:/bricks/brick1/b13 `hostname`:/bricks/brick1/b14 `hostname`:/bricks/brick1/b15 force
#gluster volume tier slave attach replica 3 fedora3:/bricks/brick3/b30 fedora3:/bricks/brick3/b31  fedora3:/bricks/brick3/b32 force
#gluster vol create master replica 2 `hostname`:/bricks/brick0/b0 `hostname`:/bricks/brick0/b01 force
#gluster vol create slave replica 2 `hostname`:/bricks/brick1/b1 `hostname`:/bricks/brick1/b11 force
gluster vol start slave
sleep 1
mount -t glusterfs `hostname`:slave /slavemnt

#gluster vol create gluster_shared_storage replica 3 `hostname`:/bricks/brick0/b20 `hostname`:/bricks/brick0/b21 `hostname`:/bricks/brick0/b22 force
#gluster vol start gluster_shared_storage
sleep 1
#mkdir -p /var/run/gluster/shared_storage
#mount -t glusterfs `hostname`:gluster_shared_storage /var/run/gluster/shared_storage

#gluster vol set all cluster.enable-shared-storage enable
#sleep 1

gluster system:: execute gsec_create
gluster vol geo-rep master `hostname`::slave create push-pem
#sleep 1
#gluster vol geo-rep master `hostname`::slave config log_level DEBUG
#sleep 1
#gluster vol geo-rep master `hostname`::slave config use_meta_volume true
#gluster vol geo-rep master `hostname`::slave config lazy_umount false 
sleep 3
gluster vol geo-rep master `hostname`::slave start
sleep 1
gluster vol geo-rep master `hostname`::slave status
