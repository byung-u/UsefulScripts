#!/bin/sh
# http://techblog.netflix.com/2015/11/linux-performance-analysis-in-60s.html

uptime

dmesg | tail

vmstat 1 1

mpstat -P ALL 1 1

#pidstat 1

#iostat -xz 1
iostat -x 1 1

free -m

sar -n DEV 1 1

#sar -n TCP,ETCP 1 1

