#!/bin/bash
# Mirantis Internship 2018
# Task 4.1
# Eugeniy Khvastunov
# Script that collect system info in task4_1.out
CURPATH="$(pwd)"
SCRPATH="$(echo $0 | rev | cut -c 11- | rev)"
OUTFILE=$CURPATH/$SCRPATH'task4_1.out'
TMPFILE=$CURPATH/$SCRPATH'task4_1.tmp'
CPUName=`/bin/cat /proc/cpuinfo | /usr/bin/awk -F':' '/^model name/{print $2}' | /usr/bin/uniq | /usr/bin/tr -s [:blank:]`
phyCPUCount=`/bin/cat /proc/cpuinfo | /bin/grep -i 'physical id' | /usr/bin/uniq | /usr/bin/wc -l`
coresPerCPU=`/bin/cat /proc/cpuinfo | /usr/bin/awk '/^cpu cores/{print $4}' | uniq`
if [ -f /sys/devices/virtual/dmi/id/board_vendor ] ; then
        MBManufacturer=`/bin/cat /sys/devices/virtual/dmi/id/board_vendor`
else
        MBManufacturer='Unknown vendor'
fi
if [ -f /sys/devices/virtual/dmi/id/board_name ] ; then
        MBProductName=`/bin/cat /sys/devices/virtual/dmi/id/board_name`
else
        MBProductName='Unknown Motherboard'
fi
if [ -f /sys/devices/virtual/dmi/id/board_serial ] ; then
	SSN=`/bin/cat /sys/devices/virtual/dmi/id/board_serial`
else
	SSN='Unknown'
fi
set -o allexport
source /etc/lsb-release
set +o allexport
echo "--- Hardware ---
CPU:$CPUName ($phyCPUCount CPU with $coresPerCPU cores per CPU)
RAM: `/bin/cat /proc/meminfo | /usr/bin/awk '/^MemTotal/{print $2" "$3}'`
Motherboard: $MBManufacturer $MBProductName
System Serial Number: $SSN
--- System ---
OS Distribution: $DISTRIB_DESCRIPTION
Kernel version: `/bin/uname -r`
Installation date:`/sbin/tune2fs -l $(mount | /bin/egrep ' / ' | /usr/bin/awk '{print $1}') | /usr/bin/awk -F'created:' '/^Filesystem created/ { print $2 }' | /usr/bin/tr -s [:blank:]`
Hostname: `/bin/hostname -f`
Uptime: `/usr/bin/uptime -p | /usr/bin/cut -c 4-`
Processes running: `/bin/ps -A --no-headers | /usr/bin/wc -l`
Users logged in: `/usr/bin/who | /usr/bin/wc -l`
--- Network ---
`/bin/ip -4 -o addr | /usr/bin/awk '{print $2": "$4}'`" > $OUTFILE
/bin/ip -4 -o addr | /usr/bin/awk '{print $2}' > $TMPFILE
/bin/ip -d -o -0 addr | /usr/bin/awk '{print $2}' | tr -d [:] | /bin/fgrep -vf $TMPFILE | /usr/bin/awk '{print $0": -"}' >> $OUTFILE
/bin/rm $TMPFILE
