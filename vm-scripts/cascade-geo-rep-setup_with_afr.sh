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
echo 'y' | gluster vol stop slave 
echo 'y' | gluster vol del slave 


#Clean brick1 and brick2
/root/scripts/clean_bricks.sh 1
/root/scripts/clean_bricks.sh 2
/root/scripts/clean_bricks.sh 3

#Create required parent directories
mkdir -p /bricks/brick1/b1
mkdir -p /bricks/brick2/b2
mkdir -p /bricks/brick3/b3

echo "Clean slave vol in fedora2"
ssh root@fedora2  'bash -s' < remote-slave_with_afr_1.sh 

echo "Cleanup successful?"
read input
if [[ $input == "n" ]]; then
   echo "Exiting"
   exit 1
fi

#Add fedora2 to cluster
gluster peer probe fedora2
sleep 1

#Volume creation and starting
#Slave
gluster vol create slave replica 2 fedora1:/bricks/brick3/b3/A fedora2:/bricks/brick3/b3/A fedora1:/bricks/brick3/b3/B fedora2:/bricks/brick3/b3/B
sleep 1 
gluster vol start slave
sleep 1 

#imaster
gluster vol create imaster replica 2 fedora1:/bricks/brick2/b2/A fedora2:/bricks/brick2/b2/A fedora1:/bricks/brick2/b2/B fedora2:/bricks/brick2/b2/B
sleep 1 
gluster vol start imaster
sleep 1 
#Master
gluster vol create master replica 2 fedora1:/bricks/brick1/b1/A fedora2:/bricks/brick1/b1/A fedora1:/bricks/brick1/b1/B fedora2:/bricks/brick1/b1/B
sleep 1 
gluster vol start master
sleep 1

exit 1

#Geo-rep creation: 1st master:imaster
gluster system:: execute gsec_create
gluster volume geo-rep master fedora1::imaster create push-pem force
sleep 1 
gluster volume geo-rep master fedora1::imaster start
sleep 1 

#Geo-rep creation: 1st imaster:slave
gluster system:: execute gsec_create
gluster volume geo-rep master fedora1::imaster create push-pem force
sleep 1 
gluster volume geo-rep imaster fedora2::slave create push-pem force
sleep 1 
gluster volume geo-rep imaster fedora2::slave start

