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
