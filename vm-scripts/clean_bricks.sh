#! /bin/bash

umount /bricks/brick$1
dd if=/dev/zero of=/dev/vg_s1/brick$1 count=10
sync
mkfs.xfs -f -i size=512 /dev/vg_s1/brick$1
sync
mount -a
