#/bin/bash

start="Done initializing engine"
#start="INFO  ProgressMeter*1:"
#end="INFO  ProgressMeter*2:"
end="Traversal complete"

rm -rf *.vcf* log-*

ls genetic-data | while read genetic
do
	bam=$(ls ./genetic-data/$genetic | grep 'bam$')
	echo $bam

	(bash variantsCalling-new.sh $bam $genetic >> log-$genetic.txt 2>&1) &

	#(bash collect-vcf.sh $1)& 

	tail -f log-$genetic.txt | while read log
	do
		if [[ $log == *$start* ]]
		then
			#(./collect-proc.sh $genetic $1 $2)&
			(./sample >> ../tmp/$genetic-$2-$1)&
		elif [[ $log == *$end* ]]
        	then
			echo $log
                	docker rm -f $(docker ps -aq)
			kill -9 $(ps -axu | grep tail | awk '{print $2}')
                	break
       		fi
	done

	wait
	sleep 5s
	echo 1 > /proc/sys/vm/drop_caches
done

#tail -f log-$1.txt | while read log
#do
#	if [[ $log == *$start* ]]
#	then
#		echo $log
#		date >> $1-GATK-HC.vcf 
#		#(./collect-proc.sh $1 1) &
#	elif [[ $log == *$end* ]]
#	then
#		echo $log
#		docker rm -f $(docker ps -aq)
#		kill -9 $(ps -axu | grep collect-proc.sh | awk '{print $2}')
#		kill -9 $(ps -axu | grep tail | awk '{print $2}')
#		break
#	fi
#done	
