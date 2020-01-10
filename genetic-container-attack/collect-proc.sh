#/bin/bash
  
for((i=1;i<=100000;i++))
do
        (cat /proc/meminfo >> /home/tmp/meminfo-$1-$2)&
        (cat /proc/buddyinfo >> /home/tmp/buddyinfo-$1-$2)&
        (cat /proc/loadavg >> /home/tmp/loadavg-$1-$2)&
        #(cat /proc/zoneinfo >> ./tmp/zoneinfo-$1)&
        #(cat /proc/interrupts >> $1/interrupts)&
        #(cat /proc/pagetypeinfo >> ./tmp/pagetypeinfo-$1)&
        (cat /proc/softirqs >> /home/tmp/softirqs-$1-$2)&
	sleep 0.01
        wait
done
