#!/bin/bash

<<COMMENT1
echo "Umounting bricks"
for i in {0..4}
do
umount /bricks/brick$i
done

echo "Deleting lvs"
for i in {0..4}
do
lvremove /dev/vg_s1/brick$i
lvremove /dev/vg_0/thin_vol_$i
lvremove /dev/vg_0/thin_pool_$i
done

lvdisplay

echo "Deleting volume group vg_s1"
echo "Proceed?"
read n
vgremove vg_s1
vgremove vg_0
vgdisplay
COMMENT1

#Create vg_0
vgcreate vg_0 /dev/sdb
vgdisplay

echo "Proceed?"
read n

#Create thin pool
for i in {0..3}
do
lvcreate -L 2g -T /dev/vg_0/thin_pool_$i
lvcreate -V2g -T /dev/vg_0/thin_pool_$i -n thin_vol_$i
mkfs.xfs -f -i size=512 /dev/vg_0/thin_vol_$i
done

#lvcreate -l 506 -T /dev/vg_0/thin_pool_3
#lvcreate -V1.9g -T /dev/vg_0/thin_pool_3 -n thin_vol_3
#mkfs.xfs -f -i size=512 /dev/vg_0/thin_vol_3

for i in {0..3}
do
    mkdir -p /bricks/brick$i
done
cat ~/scripts/fstab_entry >> /etc/fstab

mount -a
