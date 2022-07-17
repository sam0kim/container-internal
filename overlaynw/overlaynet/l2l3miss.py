#!/usr/bin/env python

# To use this without l2miss/l3miss from vxlan, enable app_solicit on your interface
# echo 1 | sudo tee -a  /proc/sys/net/ipv4/neigh/eth0/app_solicit

from pyroute2 import NetNS
from pyroute2.netlink.rtnl import ndmsg
from pyroute2.netlink.exceptions import NetlinkError
import logging

vxlan_ns="overns"
if_family = {2 : "AF_INET"}
nud_state = {
  0x01 : "NUD_INCOMPLETE",
  0x02 : "NUD_REACHABLE",
  0x04 : "NUD_STALE",
  0x08 : "NUD_DELAY",
  0x10 : "NUD_PROBE",
  0x20 : "NUD_FAILED",
  0x40 : "NUD_NOARP",
  0x80 : "NUD_PERMANENT",
  0x00 : "NUD_NONE"
}
type = {
  0 : "RTN_UNSPEC",
  1 : "RTN_UNICAST",
  2 : "RTN_LOCAL",
  3 : "RTN_BROADCAST",
  4 : "RTN_ANYCAST",
  5 : "RTN_MULTICAST",
  6 : "RTN_BLACKHOLE",
  7 : "RTN_UNREACHABLE",
  8 : "RTN_PROHIBIT",
  9 : "RTN_THROW",
  10 : "RTN_NAT",
  11 : "RTN_XRESOLVE"
}

logging.basicConfig(level=logging.DEBUG)

ns = NetNS(vxlan_ns)
ns.bind()

while True:
    msg = ns.get()
    for m in msg:
        logging.debug("Received an event: {}".format(m['event']))
        if m['event'] != "RTM_GETNEIGH" :
            continue
    if 'ifindex' not in m :
        continue

    ifindex=m['ifindex']
    ifname=ns.get_links(ifindex)[0].get_attr("IFLA_IFNAME")

    logging.debug("------------ ndmsg start ------------")
    logging.debug("Family: {}".format(if_family.get(m['family'],m['family'])))
    logging.debug("Interface {} index: {}".format(ifname,ifindex))
    logging.debug("State: {}".format(nud_state.get(m['state'],m['state'])))
    logging.debug("Flags: {}".format(m['flags']))
    logging.debug("Type: {}".format(type.get(m['ndm_type'],m['ndm_type'])))
    logging.debug("------------ ndmsg end --------------")

    if m.get_attr("NDA_DST") is not None:
      ipaddr=m.get_attr("NDA_DST")
      logging.info("L3Miss on {}: Who has IP: {}? Check arp table on {}".format(ifname,ipaddr,vxlan_ns))

    if m.get_attr("NDA_LLADDR") is not None:
      lladdr=m.get_attr("NDA_LLADDR")
      logging.info("L2Miss on {}: Who has MAC: {}? Check bridge fdb on {}".format(ifname,lladdr,vxlan_ns))





