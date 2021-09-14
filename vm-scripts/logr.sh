#!/bin/bash

for i in {1..10}; do
    rm -f /mastermnt1/test-file-20151007
    dd if=/dev/zero of=/mastermnt1/test-file bs=1024 count=101 conv=nocreat
    logrotate /etc/logrotate.conf
done;
