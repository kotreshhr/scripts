#for i in {1..15};do time bash /root/clone_perf.sh sub_$i snap_$i clone_$i > /root/clone_15_parallel_create_$i.out 2>&1 &;done;
#for i in {1..15}
#do 
#  (time bash /root/clone_perf1.sh sub_$i snap_$i clone_$i) > /root/clone_15_parallel_create_$i.out 2>&1 &
#done
(time bash /root/clone_perf1.sh sub_1 snap_1 clone_1) > /root/clone_15_parallel_create_1.out 2>&1 &
(time bash /root/clone_perf1.sh sub_2 snap_2 clone_2) > /root/clone_15_parallel_create_2.out 2>&1 &
(time bash /root/clone_perf1.sh sub_3 snap_3 clone_3) > /root/clone_15_parallel_create_3.out 2>&1 &
(time bash /root/clone_perf1.sh sub_4 snap_4 clone_4) > /root/clone_15_parallel_create_4.out 2>&1 &
(time bash /root/clone_perf1.sh sub_5 snap_5 clone_5) > /root/clone_15_parallel_create_5.out 2>&1 &
(time bash /root/clone_perf1.sh sub_6 snap_6 clone_6) > /root/clone_15_parallel_create_6.out 2>&1 &
(time bash /root/clone_perf1.sh sub_7 snap_7 clone_7) > /root/clone_15_parallel_create_7.out 2>&1 &
(time bash /root/clone_perf1.sh sub_8 snap_8 clone_8) > /root/clone_15_parallel_create_8.out 2>&1 &
(time bash /root/clone_perf1.sh sub_9 snap_9 clone_9) > /root/clone_15_parallel_create_9.out 2>&1 &
(time bash /root/clone_perf1.sh sub_10 snap_10 clone_10) > /root/clone_15_parallel_create_10.out 2>&1 &
(time bash /root/clone_perf1.sh sub_11 snap_11 clone_11) > /root/clone_15_parallel_create_11.out 2>&1 &
(time bash /root/clone_perf1.sh sub_12 snap_12 clone_12) > /root/clone_15_parallel_create_12.out 2>&1 &
(time bash /root/clone_perf1.sh sub_13 snap_13 clone_13) > /root/clone_15_parallel_create_13.out 2>&1 &
(time bash /root/clone_perf1.sh sub_14 snap_14 clone_14) > /root/clone_15_parallel_create_14.out 2>&1 &
(time bash /root/clone_perf1.sh sub_15 snap_15 clone_15) > /root/clone_15_parallel_create_15.out 2>&1 &
