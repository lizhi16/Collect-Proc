#/bin/bash

for ((i=1;i<=70;i++))
do
	./collect-single.sh $i meminfo
done
