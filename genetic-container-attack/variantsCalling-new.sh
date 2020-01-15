##reference: http://people.duke.edu/~ccc14/duke-hts-2017/Statistics/08032017/GATK-pipeline-sample.html

##set path
mygatk="gatk"
mybwa="bwa"
mywd="/home/pipeline/"
mypicard="/home/picard.jar"

##set reference and annotation files
myrefdir="/home/pipeline/"
myfasta="/home/pipeline/ref/human_g1k_v37.fasta"
mydata="/home/pipeline/genetic-data/"
##Call variants using Haplotype Caller
##To download samtools, please refer: http://samtools.sourceforge.net/
#docker run -v $(pwd):/home/pipeline cloudinsky/gatk:bwa /bin/bash -c "cd $myrefdir && $mygatk --java-options \"-Xmx4g\" HaplotypeCaller -R $myfasta -I $mydata$2/$1 -ERC GVCF -O $mywd$2-GATK-HC.vcf -L 1:197000000-197500000"
docker run -v $(pwd):/home/pipeline cloudinsky/gatk:bwa /bin/bash -c "cd $myrefdir && $mygatk --java-options \"-Xmx4g\" HaplotypeCaller -R $myfasta -I $mydata$2/$1 -ERC GVCF -O $mywd$2-GATK-HC.vcf -L 1:119672175-119832175"
