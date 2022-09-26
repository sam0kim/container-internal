#!/bin/bash

# copy ps
ldd /bin/ps;
cp /bin/ps /tmp/myroot/bin/;
cp /lib/x86_64-linux-gnu/{libprocps.so.6,libdl.so.2,libc.so.6,libsystemd.so.0,librt.so.1,liblzma.so.5,libgcrypt.so.20,libpthread.so.0,libgpg-error.so.0} /tmp/myroot/lib/x86_64-linux-gnu/;
mkdir -p /tmp/myroot/usr/lib/x86_64-linux-gnu;
cp /usr/lib/x86_64-linux-gnu/liblz4.so.1 /tmp/myroot/usr/lib/x86_64-linux-gnu/;
cp /lib64/ld-linux-x86-64.so.2 /tmp/myroot/lib64/;

# copy mount
ldd /bin/mount;
cp /bin/mount /tmp/myroot/bin/;
cp /lib/x86_64-linux-gnu/{libmount.so.1,libc.so.6,libblkid.so.1,libselinux.so.1,librt.so.1,libuuid.so.1,libpcre.so.3,libdl.so.2,libpthread.so.0} /tmp/myroot/lib/x86_64-linux-gnu/;
cp /lib64/ld-linux-x86-64.so.2 /tmp/myroot/lib64/;

# copy mkdir
ldd /bin/mkdir;
cp /bin/mkdir /tmp/myroot/bin/;
cp /lib/x86_64-linux-gnu/{libselinux.so.1,libc.so.6,libpcre.so.3,libdl.so.2,libpthread.so.0} /tmp/myroot/lib/x86_64-linux-gnu/;
cp /lib64/ld-linux-x86-64.so.2 /tmp/myroot/lib64/;
