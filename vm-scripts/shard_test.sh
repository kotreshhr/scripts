#!/bin/bash

#$1 = gfid of 1st shard 
#$2 = gfid of 2nd shard
#$3 = Master mnt
#$4 = Slave mnt
#$5 = file_name

shard_gfid="be318638-e8a0-4c6d-977d-7a937aa84806"


#Create empty file on slave using setxattr interface with gfid $1
python /root/sandbox/upstream/glusterfs/tests/utils/gfid-access.py /$4 ROOT $5 $1 file 0 0 0644

#Create .shard directory on brick backend
python /root/sandbox/upstream/glusterfs/tests/utils/gfid-access.py /$4 ROOT ".shard" $shard_gfid dir 0 0 0755

#Create empty file of 2nd shard chunk
python /root/sandbox/upstream/glusterfs/tests/utils/gfid-access.py /$4 $shard_gfid $1.1 $2 file 0 0 0600

#Rsync .gfid/$1
cd $3
rsync -aR0 --inplace --xattrs --acls --numeric-ids --no-implied-dirs .gfid/$1 /$4/

#Rsync .gfid/$3
rsync -aR0 --inplace --xattrs --acls --numeric-ids --no-implied-dirs .gfid/$2 /$4/

#Rsync xattrs
rsync -aR0 --inplace --xattrs --acls --numeric-ids --no-implied-dirs .gfid/$1 /$4/
cd -
