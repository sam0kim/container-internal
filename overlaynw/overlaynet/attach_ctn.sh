#!/bin/bash

containerns=${1:-pinkns}
ip=${2:-2}

# set host ip and interface
host_ipaddr=$(ifconfig eth1 &>/dev/null;if [ "$?" == 1 ];then ifconfig eth0; fi | awk '{ print $2}' | grep -E -o "([0-9]{1,3}[\.]){3}[0-9]{1,3}")

# set virtual lladdr & ipaddr
mac=$ip
if [[ "$ip" -lt 10 ]];then
  mac="0${ip}"
fi
lladdr="02:42:c0:a8:00:${mac}"
ipaddr="11.11.11.${ip}"

# storage for arp/fdb
storage_home="/vagrant/overlaynet/storage"
storage_arp="${storage_home}/arp"
storage_fdb="${storage_home}/fdb"

#------------------------------------------------#

# reset
cnt=$(sudo ip netns | grep $containerns | wc -l)
if [ $cnt == 1 ];then 
  echo "reset ${containerns}"
  sudo ip netns del $containerns
  rm "${storage_arp}/${ipaddr}"
  rm "${storage_fdb}/${lladdr}"
fi

# create netns
sudo ip netns add $containerns

# create veth interfaces - vethO (overns), eth0 (containerns)
vethO="vethO${ip}"
sudo ip link add dev $vethO mtu 1450 netns overns type veth peer name eth0 mtu 1450 netns $containerns

# attach first peer to the bridge in our overlay namespace
sudo ip netns exec overns ip link set $vethO master br0
sudo ip netns exec overns ip link set $vethO up

# move second peer tp container network namespace and configure it
sudo ip netns exec $containerns ip link set dev eth0 address $lladdr
sudo ip netns exec $containerns ip addr add dev eth0 "${ipaddr}/24"
sudo ip netns exec $containerns ip link set dev eth0 up

# write arp/fdb info to File
echo $lladdr > "${storage_arp}/${ipaddr}"
echo $host_ipaddr > "${storage_fdb}/${lladdr}"
