ls ./ | grep mapped | while read filename
do
		docker run -v $(pwd):/home/pipeline cloudinsky/gatk:bwa /bin/bash -c "cd /home/pipeline/ && samtools index /home/pipeline/$filename"
done
