sub_name=$1
snap_name=$2
clone_name=$3
ceph fs subvolume snapshot protect perf-test-vol $sub_name $snap_name 
ceph fs subvolume snapshot clone perf-test-vol $sub_name $snap_name $clone_name
clone_completed="1"
while [ $clone_completed -ne 0 ]
do
   ceph fs clone status perf-test-vol $clone_name  | grep "complete"
   clone_completed="$?"
   sleep 0.3
done
ceph fs subvolume snapshot unprotect perf-test-vol $sub_name $snap_name
