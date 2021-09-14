#! /bin/bash

# Clean ge-rep (master:imaster and imaster:slave)
/root/scripts/all_log_0
gluster volume geo-rep master fedora1::imaster stop
sleep 1
gluster volume geo-rep master fedora1::imaster delete
sleep 1
gluster volume geo-rep imaster fedora2::slave stop
sleep 1
gluster volume geo-rep imaster fedora2::slave delete
sleep 1
echo "Delete successful?"
read input
if [[ $input == "n" ]]; then
   echo "Exiting"
   exit 1
fi

#Del master vol and imaster vol and Clean backend bricks
echo 'y' | gluster vol stop master
echo 'y' | gluster vol del master
echo 'y' | gluster vol stop imaster
echo 'y' | gluster vol del imaster
/root/scripts/clean_b1.sh
echo "Cleanup successful?"
read input
if [[ $input == "n" ]]; then
   echo "Exiting"
   exit 1
fi

#Volume creation and starting
#Slave
gluster vol create imaster fedora1:/bricks/brick2/b2 fedora1:/bricks/brick3/b3 
sleep 1 
gluster vol start imaster
sleep 1 
#Master
gluster vol create master fedora1:/bricks/brick0/b0 fedora1:/bricks/brick1/b1 
sleep 1 
gluster vol start master
sleep 1

echo "Do you want to create geo-rep session between master and imaster?"
read input
if [[ $input == "n" ]]; then
   echo "Exiting"
   exit 1
fi

#Geo-rep creation: 1st master:imaster
gluster system:: execute gsec_create
gluster volume geo-rep master fedora1::imaster create push-pem force
sleep 1 
gluster volume geo-rep master fedora1::imaster start
sleep 1 

echo "master:imaster session created?"
echo "If yes, Do you want to setup cacaded setup?"
read input
if [[ $input == "n" ]]; then
   echo "Exiting"
   exit 1
fi

echo "Creating slave vol in fedora2"
ssh root@fedora2  'bash -s' < remote-slave.sh

#Geo-rep creation: 1st imaster:slave
gluster system:: execute gsec_create
gluster volume geo-rep imaster fedora2::slave create push-pem force
sleep 1 
gluster volume geo-rep imaster fedora2::slave start

