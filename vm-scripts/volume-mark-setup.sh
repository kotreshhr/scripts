#! /bin/bash

# Clean ge-rep
/root/scripts/all_log_0
gluster volume geo-rep master rhs2::slave stop
sleep 1
gluster volume geo-rep master rhs2::slave delete
sleep 1
echo "Delete successful?"
read input
if [[ $input == "n" ]]; then
   echo "Exiting"
   exit 1
fi

#Del master vol and Clean backend bricks
echo 'y' | gluster vol stop master
echo 'y' | gluster vol del master
/root/scripts/clean_b1.sh
echo "Cleanup successful?"
read input
if [[ $input == "n" ]]; then
   echo "Exiting"
   exit 1
fi

#Volume creation and starting
echo "master vol creation:" > /tmp/master_time
gluster vol create master rhs1:/bricks/brick0/b0 && date >> /tmp/master_time
sleep 10
echo "master vol start:" >> /tmp/master_time
gluster vol start master && date >> /tmp/master_time
sleep 10 

echo "If master volume creation successful, clean slave vol and continue?"
read input
if [[ $input == "n" ]]; then
   echo "Exiting"
   exit 1
fi

# getfattr log
echo "Before geo-rep creation:" > /tmp/master_getfattr
getfattr -d -m . -e hex /bricks/brick0/b0 >> /tmp/master_getfattr

#Geo-rep creation with time logging
gluster system:: execute gsec_create
sleep 10 
echo "geo-rep create:" >> /tmp/master_time
gluster volume geo-rep master rhs2::slave create push-pem && date >> /tmp/master_time
sleep 10 

# getfattr log
echo "After geo-rep create:" >> /tmp/master_getfattr
getfattr -d -m . -e hex /bricks/brick0/b0 >> /tmp/master_getfattr

echo "geo-rep start:" >> /tmp/master_time
date >> /tmp/master_time && gluster volume geo-rep master rhs2::slave start
sleep 10 

# getfattr log
echo "After geo-rep start:" >> /tmp/master_getfattr
getfattr -d -m . -e hex /bricks/brick0/b0 >> /tmp/master_getfattr
