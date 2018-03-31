#!/bin/bash
# Mirantis Internship 2018
# Task 4.1
# Eugeniy Khvastunov
# Script that collect system info in task4_1.out
CPUName=`/bin/cat /proc/cpuinfo | /usr/bin/awk -F':' '/^model name/{print $2}' | uniq | tr -s [:blank:]`
phyCPUCount=`cat /proc/cpuinfo | grep -i 'physical id' | uniq | wc -l`
coresPerCPU=`/bin/cat /proc/cpuinfo | /usr/bin/awk '/^cpu cores/{print $4}' | uniq`
if [ -f /sys/devices/virtual/dmi/id/board_vendor ] ; then
        MBManufacturer=`cat /sys/devices/virtual/dmi/id/board_vendor`
else
        MBManufacturer='Unknown vendor'
fi
if [ -f /sys/devices/virtual/dmi/id/board_name ] ; then
        MBProductName=`cat /sys/devices/virtual/dmi/id/board_name`
else
        MBProductName='Unknown Motherboard'
fi
if [ -f /sys/devices/virtual/dmi/id/board_serial ] ; then
	SSN=`cat /sys/devices/virtual/dmi/id/board_serial`
else
	SSN='Unknown'
fi
set -o allexport
source /etc/lsb-release
set +o allexport
echo "PWD: `pwd`
SCRPATH: $0
--- Hardware ---
CPU:$CPUName ($phyCPUCount CPU with $coresPerCPU cores per CPU)
RAM: `/bin/cat /proc/meminfo | /usr/bin/awk '/^MemTotal/{print $2" "$3}'`
Motherboard: $MBManufacturer / $MBProductName
System Serial Number: $SSN
--- System ---
OS Distribution: $DISTRIB_DESCRIPTION
Kernel version: `/bin/uname -r`
Installation date:`dumpe2fs $(mount | grep 'on \/ ' | awk '{print $1}') | grep 'Filesystem created:' | awk -F'created:' '{print $2}' | tr -s [:blank:]`
Hostname: `/bin/hostname -f`
Uptime: `/usr/bin/uptime -p`
Processes running: `/bin/ps -A --no-headers | /usr/bin/wc -l`
Users logged in: `/usr/bin/who | /usr/bin/wc -l`
--- Network ---
`/bin/ip -4 -o addr | /usr/bin/awk '{print $2": "$4}'`
" > ./task4_1.out
