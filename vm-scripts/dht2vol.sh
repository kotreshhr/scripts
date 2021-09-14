#!/bin/bash

#gluster vol create dht2vol mds 2 data 2 fedora1:/bricks/brick0/b0 fedora1:/bricks/brick1/b1 fedora1:/bricks/brick2/b2 fedora1:/bricks/brick3/b3
gluster vol create dht2vol mds 1 data 1 fedora1:/bricks/brick0/b0 fedora1:/bricks/brick1/b1
gluster vol start dht2vol
