#!/bin/bash

gluster vol set $1 quick-read on
gluster vol set $1 read-ahead on
gluster vol set $1 io-cache on
gluster vol set $1 stat-prefetch on
gluster vol set $1 eager-lock disable 
gluster vol set $1 remote-dio disable
gluster vol set $1 quorum-type auto
