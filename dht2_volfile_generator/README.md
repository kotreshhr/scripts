These scripts are to generate glusterd dht2 specific volfiles
when a normal distributed gluster volume is created!!!

GlusterCreateVolume.py is wrapper around gluster volume creation
command. It creates gluster volume and generates dht2 volfiles
in "/var/lib/glusterd/vols/<volname>/" with .gen as extension.
Please see below for usage.

###python GlusterCreateVolume.py -h
usage: GlusterCreateVolume.py [-h] [--force]
                              VOLUME_NAME MDS_COUNT DS_COUNT BRICKS

Script to create gluster dht2 vol files...

positional arguments:  
  VOLUME_NAME  Volume name  
  MDS_COUNT    MDS count  
  DS_COUNT     DS count  
  BRICKS       Brick list as one string  

optional arguments:  
  -h, --help   show this help message and exit  
  --force      force volume creation  
