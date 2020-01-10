#/bin/bash

cat $1 | while read index
do
	size=$(curl ftp://ftp.1000genomes.ebi.ac.uk/vol1/ftp/phase3/data/$index/alignment/ | grep mapped |  grep 'bam$' | awk '{print $5}'  |  sed -n '1p')
	
	if [[ $size -lt 22000000000 ]]
	then
		name=$(curl ftp://ftp.1000genomes.ebi.ac.uk/vol1/ftp/phase3/data/$index/alignment/ | grep mapped |  grep 'bam$' | awk '{print $9}'  |  sed -n '1p')
		
		echo $name
		wget ftp://ftp.1000genomes.ebi.ac.uk/vol1/ftp/phase3/data/$index/alignment/$name
	fi
done
