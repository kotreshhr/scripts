# README

cephadm branch: https://github.com/batrick/ceph-linode/tree/cephadm

1. mv cluster.json.sample cluster.json
2. ./launch.sh
3. source ansible-env.sh
4. do_playbook ceph-linode.yml

Then you can fiddle with logging into the mon for testing:

1. ./ansible-ssh mon-000
2. $ ./cephadm shell

