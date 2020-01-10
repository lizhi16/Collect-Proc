#/bin/bash
startflag="Current Locus"
endflag="INFO  ProgressMeter*2:"

ls ./ | grep log-$1 | while read logs
do
	#echo $logs
	cat $logs | while read log
	do
		if [[ $log == *$startflag* ]]
                then
			startTime=$(echo $log | awk '{print $1}')
                elif [[ $log == *$endflag* ]]
                then
			endTime=$(echo $log | awk '{print $1}')

                	start_hour=$(echo $startTime | cut -d ":" -f1)
			start_hour=$((10#$start_hour))
			
			start_mins=$(echo $startTime | cut -d ":" -f2)
			start_mins=$((10#$start_mins))
                	
			start=$[ $start_mins+start_hour*60 ]

                	end_hour=$(echo $endTime | cut -d ":" -f1)
			end_hour=$((10#$end_hour))
			if [ $end_hour -eq 0 ] && ! [ $start_hour -eq 0 ]
			then
				echo $end_hour,$start_hour
				end_hour=24
			fi
			end_mins=$(echo $endTime | cut -d ":" -f2)
			end_mins=$((10#$end_mins))
                	
			end=$[ end_mins+end_hour*60 ]
			
			diff=$[ end-start ]

        		if [ $diff -le 35 ]; 
			then
               		 	echo $diff
				index=$(echo $logs | cut -d "-" -f3 | cut -d "." -f1)
				echo \"$index\",
        		fi
                fi
	done        
done
