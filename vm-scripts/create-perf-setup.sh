umount /mastermnt
umount /var/run/gluster/shared_storage
sleep 1
pkill gluster
sleep 2
glusterd
echo 'y' | gluster vol stop master
echo 'y' | gluster vol del master
echo 'y' | gluster vol stop gluster_shared_storage
echo 'y' | gluster vol del gluster_shared_storage
~/scripts/clean_b1.sh
gluster vol create master replica 3 fedora1:/bricks/brick0/b0 fedora1:/bricks/brick1/b1 fedora1:/bricks/brick2/b2 force
gluster vol start master
gluster vol create gluster_shared_storage replica 3 `hostname`:/bricks/brick3/b30 `hostname`:/bricks/brick3/b31 `hostname`:/bricks/brick3/b32 force
gluster vol start gluster_shared_storage
sleep 2
mkdir -p /var/run/gluster/shared_storage
mount -t glusterfs fedora1:master /mastermnt
mount -t glusterfs `hostname`:gluster_shared_storage /var/run/gluster/shared_storage
