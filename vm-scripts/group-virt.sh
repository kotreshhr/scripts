#!/bin/bash

gluster vol set $1 quick-read off
gluster vol set $1 read-ahead off
gluster vol set $1 io-cache off
gluster vol set $1 stat-prefetch off
gluster vol set $1 eager-lock enable
gluster vol set $1 remote-dio enable
gluster vol set $1 quorum-type auto
