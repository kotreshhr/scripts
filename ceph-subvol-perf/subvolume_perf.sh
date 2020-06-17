#======Create CephFS======
ceph fs volume create perf-test-vol

#===================Subvolume creation =======================
(time for i in {1..1000};do ceph fs subvolume create perf-test-vol sub_$i --size=1048576000;done;) > /root/subvol_creation.out 2>&1

#===================Subvolume deletion =======================
(time for i in {1..1000};do ceph fs subvolume rm perf-test-vol sub_$i;done;) > /root/subvol_deletion.out 2>&1

#===================Snapshot creation =====================
ceph fs subvolume create perf-test-vol sub_0 --size=1048576000
ceph auth get client.admin
## on client
mount -t ceph 192.168.129.134:6789:/ /mnt -o name=admin,secret=AQC9d89eYc7bARAA+xOANXKcDTy5CkESb1IHhA==
dd if=/dev/urandom of=file_1G bs=1M count=1000

(time for i in {1..100};do ceph fs subvolume snapshot create perf-test-vol sub_0 snap_$i;done;) > /root/snap_creation.out 2>&1

#===================Snapshot deletion =====================
(time for i in {1..100};do ceph fs subvolume snapshot rm perf-test-vol sub_0 snap_$i;done;) > /root/snap_deletion.out 2>&1

#============== subvolume creation during cloning =======================
(time for i in {1..15};do /root/clone_perf.sh clone_$i;done;) > /root/clone_15.out 2>&1
(time for i in {1..100};do ceph fs subvolume create perf-test-vol sub_$i --size=1048576000;done;) > /root/subvol_parallel_creation.out 2>&1

#============ clone_perf.sh script begin ======================
clone_name=$1
ceph fs subvolume snapshot protect perf-test-vol sub_0 snap_0
ceph fs subvolume snapshot clone perf-test-vol sub_0 snap_0 $clone_name
clone_completed="1"
while [ $clone_completed -ne 0 ]
do
   ceph fs clone status perf-test-vol $clone_name  | grep "complete"
   clone_completed="$?"
   sleep 0.3
done
ceph fs subvolume snapshot unprotect perf-test-vol sub_0 snap_0
#============ clone_perf.sh script end ======================

