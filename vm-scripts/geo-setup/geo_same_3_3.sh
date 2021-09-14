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
gluster vol create master replica 3 `hostname`:/bricks/brick0/b0 `hostname`:/bricks/brick1/b1 `hostname`:/bricks/brick2/b2 force
gluster vol start master
sleep 1
gluster vol create gluster_shared_storage replica 3 `hostname`:/bricks/brick3/b000 `hostname`:/bricks/brick3/b111 `hostname`:/bricks/brick3/b333 force
gluster vol start gluster_shared_storage
sleep 1
mkdir -p /var/run/gluster/shared_storage
mount -t glusterfs `hostname`:gluster_shared_storage /var/run/gluster/shared_storage
sleep 1
gluster vol create slave replica 3 `hostname`:/bricks/brick0/b00 `hostname`:/bricks/brick1/b11 `hostname`:/bricks/brick2/b22 force
gluster vol start slave
sleep 1
gluster system:: exec gsec_create
gluster vol geo-rep master `hostname`::slave create push-pem force
gluster vol geo-rep master `hostname`::slave config use_meta_volume true
sleep 1
ldconfig /usr/local/lib
ldconfig -p | grep libgf
sleep 1
gluster vol geo-rep master `hostname`::slave start
sleep 1
gluster vol geo-rep master `hostname`::slave status
