#! /bin/bash

umount /bricks/brick0
dd if=/dev/zero of=/dev/vg_0/thin_vol_0 count=10
sync
mkfs.xfs -f -i size=512 -m reflink=1 /dev/vg_0/thin_vol_0
sync

umount /bricks/brick1
dd if=/dev/zero of=/dev/vg_0/thin_vol_1 count=10
sync
mkfs.xfs -f -i size=512 -m reflink=1 /dev/vg_0/thin_vol_1
sync

umount /bricks/brick2
dd if=/dev/zero of=/dev/vg_0/thin_vol_2 count=10
sync
mkfs.xfs -f -i size=512 -m reflink=1 /dev/vg_0/thin_vol_2
sync

umount /bricks/brick3
dd if=/dev/zero of=/dev/vg_0/thin_vol_3 count=10
sync
mkfs.xfs -f -i size=512 -m reflink=1 /dev/vg_0/thin_vol_3
sync
mount -a

#umount /bricks/brick4
#dd if=/dev/zero of=/dev/vg_0/brick4 count=10
#sync
#mkfs.xfs -f -i size=512 -m reflink=1 /dev/vg_0/brick4
#sync
#mount -a

rm -rf /bricks/brick0/*
rm -rf /bricks/brick1/*
rm -rf /bricks/brick2/*
rm -rf /bricks/brick3/*
