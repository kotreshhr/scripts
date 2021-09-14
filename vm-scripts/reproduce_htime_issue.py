#!/bin/bash

for i in {1..1000}
do
   cat /var/lib/glusterd/vols/master/run/fedora1-bricks-brick0-b0.pid | xargs kill -9
   gluster vol start master force
   sleep 0.5
done
