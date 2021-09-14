#! /bin/bash

echo 'y' | gluster vol geo-rep master fedora2::slave stop
sleep 1
echo 'y' | gluster vol geo-rep master fedora2::slave delete
sleep 1
echo 'y' | gluster vol stop master
sleep 1
echo 'y' | gluster vol del master
sleep 1
iptables -F
ssh root@fedora2  'bash -s' < /root/scripts/geo-setup/geo_slave_cleanup.sh
/root/scripts/clean_b1.sh
/root/scripts/all_log_0

gluster vol create master fedora1:/bricks/brick0/b0 force
gluster vol start master
sleep 1

ssh root@fedora2  'bash -s' < /root/scripts/geo-setup/geo_slave_setup.sh
sleep 1
gluster system:: execute gsec_create
sleep 1
gluster vol geo-rep master fedora2::slave create push-pem force
sleep 1
gluster vol geo-rep master fedora2::slave start
sleep 1
gluster vol geo-rep master fedora2::slave status
