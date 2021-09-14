gluster system:: execute gsec_create
sleep 1
iptables -F
sleep 1
gluster vol geo-rep master fedora2::slave create push-pem
sleep 1
gluster vol geo-rep master fedora2::slave status
sleep 1
gluster vol geo-rep master fedora2::slave config use_meta_volume true
sleep 1
gluster vol geo-rep master fedora2::slave start
