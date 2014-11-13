#!/bin/bash
set -e
# clean up environment
rm -rf files

vagrant up --provider=docker --no-provision

# generate key
if [ ! -f files/id_rsa ]
then
    ssh-keygen -f files/id_rsa -t rsa -N ''
# ssh without password
    cat files/id_rsa.pub |awk '{print $1, $2, "Generated by vagrant"}' > files/authorized_keys2
    cat files/id_rsa.pub |awk '{print $1, $2, "Generated by vagrant"}' > files/authorized_keys
fi

HOSTS=`vagrant ssh-config 2>/dev/null |grep -w Host |awk '{print $2}'`
for h in $HOSTS
do
  addr=`vagrant ssh $h -c "ifconfig eth0" |grep -w inet|awk '{print $2}'`
  echo ${addr} ${h}".local" >> files/hosts
done

vagrant provision