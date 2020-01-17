
#/bin/bash

start="119672182"
#start="INFO  ProgressMeter*1:"
#end="INFO  ProgressMeter*2:"
target0="119761726"
target1="119762175"
target2="119763536"
end="119832149"

for ((i=1;i<=5;i++))
do
	echo "--------$i--------"
	rm -rf *.vcf* log-*

	bam=$(ls ./genetic-data/$1 | grep 'bam$')
	echo $bam

	(bash variantsCalling-new.sh $bam $1 >> log-$1.txt 2>&1) &
	for ((j=1;j<=10000000;j++))
	do
		if [ -f $1-GATK-HC.vcf ]
		then 
			break
		fi
	done
	#(bash collect-vcf.sh $1)& 

	tail -f $1-GATK-HC.vcf | while read log
	do
		#date >> log.txt
		#echo $log >> log.txt
		if [[ $log == *$start* ]]
		then
			#echo $log
			(./sample >> ../tmp/$2-$1-$i)&
			#tail log-$1.txt
			echo $log
		elif [[ $log == *$target0* ]]
		then
			echo "---------0----------" >> ../tmp/$2-$1-$i
		elif [[ $log == *$target1* ]]
                then
                        echo "---------1----------" >> ../tmp/$2-$1-$i
		elif [[ $log == *$target2* ]]
                then
                        echo "---------2----------" >> ../tmp/$2-$1-$i
		
		elif [[ $log == *$end* ]]
        	then
			#kill -9 $(ps -axu | grep collect-proc | awk '{print $2}')
			#kill -9 $!
			#echo $log,$!
                	docker rm -f $(docker ps -aq)
			kill -9 $(ps -axu | grep tail | awk '{print $2}')
                	break
       		fi
	done

	wait
	ls ../tmp/
	echo "+==========================+"
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
