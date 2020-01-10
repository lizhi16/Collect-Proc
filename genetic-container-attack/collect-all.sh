#/bin/bash

start="Current Locus"
end="INFO  ProgressMeter*2:"

for ((i=1;i<=30;i++))
do
	rm -rf log-$1* 
	ls ./genetic-data-$1/ | while read genetic
	do
		bam=$(ls ./genetic-data-$1/$genetic/ | grep 'bam$')
		echo $bam
		(bash variantsCalling-new.sh $bam $genetic $1 >> log-$1-$genetic.txt 2>&1) &
		sleep 1s 
		tail -f log-$1-$genetic.txt | while read log
		do
			if [[ $log == *$start* ]]
			then
				echo $log
				(./collect-proc.sh $genetic $i) &
			elif [[ $log == *$end* ]]
			then
				echo $log
				docker rm -f $(docker ps -aq)
				kill -9 $(ps -axu | grep collect-proc.sh | awk '{print $2}')
				kill -9 $(ps -axu | grep tail | awk '{print $2}')
				break
			fi
		done	
	done
done
