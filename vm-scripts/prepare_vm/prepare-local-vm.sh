#! /bin/bash

<<comment1
rpm -qa | grep gluster | xargs rpm -e --nodeps
if [ $? -ne 0 ]
then
	echo "Removing rpms failed"
	exit -1;
else
	echo "Removing rpms success"
fi
comment1

pkill gluster

echo "pvcreate ..."

pvcreate /dev/sda

echo "Creating Virtual volume group vg_s1 and four logical volumes" 
vgcreate vg_s1 /dev/sda
lvcreate -L 2G -n brick1 vg_s1
lvcreate -L 2G -n brick2 vg_s1
lvcreate -L 2G -n brick3 vg_s1
lvcreate -l 511 -n brick4 vg_s1

echo "Creating xfs file system on four logical volumes"
mkfs.xfs -i size=512 /dev/vg_s1/brick1
mkfs.xfs -i size=512 /dev/vg_s1/brick2
mkfs.xfs -i size=512 /dev/vg_s1/brick3
mkfs.xfs -i size=512 /dev/vg_s1/brick4

mkdir -p /bricks/brick1/b1
mkdir -p /bricks/brick2/b2
mkdir -p /bricks/brick3/b3
mkdir -p /bricks/brick4/b4

echo "Adding entries in /etc/fstab"

echo "/dev/vg_s1/brick1	/bricks/brick1	xfs	defaults	1 2" >> /etc/fstab;
echo "/dev/vg_s1/brick2	/bricks/brick2	xfs	defaults	1 2" >> /etc/fstab;
echo "/dev/vg_s1/brick3	/bricks/brick3	xfs	defaults	1 2" >> /etc/fstab;
echo "/dev/vg_s1/brick4	/bricks/brick4	xfs	defaults	1 2" >> /etc/fstab;

echo "Mounting all"
mount -a
