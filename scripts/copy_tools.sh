#!/bin/bash

mkdir -p /tmp/tools/{bin,lib64,lib/x86_64-linux-gnu,usr/lib/x86_64-linux-gnu,usr/bin};

# copy ping
ldd /bin/ping;
cp /bin/ping /tmp/tools/bin/;
cp /lib/x86_64-linux-gnu/{libcap.so.2,libidn.so.11,libresolv.so.2,libc.so.6} /tmp/tools/lib/x86_64-linux-gnu/;
cp /usr/lib/x86_64-linux-gnu/libnettle.so.6 /tmp/tools/usr/lib/x86_64-linux-gnu/;

# copy stress
ldd /usr/bin/stress;
cp /usr/bin/stress /tmp/tools/usr/bin/;
cp /lib/x86_64-linux-gnu/{libm.so.6,libc.so.6} /tmp/tools/lib/x86_64-linux-gnu/;
cp /lib64/ld-linux-x86-64.so.2 /tmp/tools/lib64/;

# copy hostname
ldd /bin/hostname;
cp /bin/hostname /tmp/tools/bin/;
cp /lib/x86_64-linux-gnu/libc.so.6 /tmp/tools/lib/x86_64-linux-gnu/;
cp /lib64/ld-linux-x86-64.so.2 /tmp/tools/lib64;

# copy umount
ldd /bin/umount;
cp /bin/umount /tmp/tools/bin/;
cp /lib/x86_64-linux-gnu/{libmount.so.1,libc.so.6,libblkid.so.1,libselinux.so.1,librt.so.1,libuuid.so.1,libpcre.so.3,libdl.so.2,libpthread.so.0} /tmp/tools/lib/x86_64-linux-gnu/;
cp /lib64/ld-linux-x86-64.so.2 /tmp/tools/lib64/;
