(time for i in {1..1000};do ceph fs subvolume create perf-test-vol sub_1_$i --size=1048576000;done;) > /root/subvol_creation_parallel_1.out 2>&1 &
(time for i in {1..1000};do ceph fs subvolume create perf-test-vol sub_2_$i --size=1048576000;done;) > /root/subvol_creation_parallel_2.out 2>&1 &
(time for i in {1..1000};do ceph fs subvolume create perf-test-vol sub_3_$i --size=1048576000;done;) > /root/subvol_creation_parallel_3.out 2>&1 &
(time for i in {1..1000};do ceph fs subvolume create perf-test-vol sub_4_$i --size=1048576000;done;) > /root/subvol_creation_parallel_4.out 2>&1 &
(time for i in {1..1000};do ceph fs subvolume create perf-test-vol sub_5_$i --size=1048576000;done;) > /root/subvol_creation_parallel_5.out 2>&1 &
(time for i in {1..1000};do ceph fs subvolume create perf-test-vol sub_6_$i --size=1048576000;done;) > /root/subvol_creation_parallel_6.out 2>&1 &
(time for i in {1..1000};do ceph fs subvolume create perf-test-vol sub_7_$i --size=1048576000;done;) > /root/subvol_creation_parallel_7.out 2>&1 &
(time for i in {1..1000};do ceph fs subvolume create perf-test-vol sub_8_$i --size=1048576000;done;) > /root/subvol_creation_parallel_8.out 2>&1 &
