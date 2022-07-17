#!/usr/bin/env python

# To use this without l2miss/l3miss from vxlan, enable app_solicit on your interface
# echo 1 | sudo tee -a  /proc/sys/net/ipv4/neigh/eth0/app_solicit

from pyroute2 import NetNS
from pyroute2.netlink.rtnl import ndmsg
from pyroute2.netlink.exceptions import NetlinkError
import logging
import os

vxlan_ns="overns"
#logging.basicConfig(level=logging.INFO)
logging.basicConfig(level=logging.DEBUG)

ipr = NetNS(vxlan_ns)
ipr.bind()

storage_home = "/vagrant/overlaynet/storage"
storage_arp = storage_home + "/arp"
storage_fdb = storage_home + "/fdb"

while True:
    msg = ipr.get()
    for m in msg:
        logging.debug("Received an event: {}".format(m['event']))
        if m['event'] != "RTM_GETNEIGH" :
            continue
    if 'ifindex' not in m :
        continue

    ifindex=m['ifindex']
    ifname=ipr.get_links(ifindex)[0].get_attr("IFLA_IFNAME")

    if m.get_attr("NDA_DST") is not None:
      ipaddr=m.get_attr("NDA_DST")
      logging.info("L3Miss on {}: Who has IP: {}?".format(ifname,ipaddr))

      arp_path = storage_arp + "/" + ipaddr
      if os.path.exists(arp_path):
        f = open(arp_path, 'r')
        mac_addr = f.readline().rstrip()
        f.close()
        logging.info("Populating ARP table from File: IP {} is {}".format(ipaddr,mac_addr))
        try:
          logging.info("ifindex {}, ipaddr {}, mac_addr {}".format(ifindex,ipaddr,mac_addr))
          ipr.neigh('add', dst=ipaddr, lladdr=mac_addr, ifindex=ifindex, state=ndmsg.states['permanent'])
        except NetlinkError as (code, message):
          print(message)

    if m.get_attr("NDA_LLADDR") is not None:
      lladdr=m.get_attr("NDA_LLADDR")
      logging.info("L2Miss on {}: Who has MAC: {}?".format(ifname,lladdr))

      fdb_path = storage_fdb + "/" + lladdr
      if os.path.exists(fdb_path):
        f = open(fdb_path, 'r')
        dst_host=f.readline().rstrip()
        f.close()
        logging.info("Populating FIB table from File: MAC {} is on host {}".format(lladdr, dst_host))
        try:
          logging.info("ifindex {}, lladdr {}, dst_host {}".format(ifindex,lladdr,dst_host))
          ipr.fdb('add', ifindex=ifindex, lladdr=lladdr, dst=dst_host)
        except NetlinkError as (code, message):
          print(message)