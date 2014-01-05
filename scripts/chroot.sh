#!/usr/bin/sudo /bin/bash
export LC_ALL=C
mount -t proc proc proc/
mount -t sysfs sys sys/
mount -o bind /dev dev/
mount -t devpts pts dev/pts/
cp -a /etc/resolv.conf etc/resolv.conf
chroot .
umount dev/pts
umount dev
umount sys
umount proc

