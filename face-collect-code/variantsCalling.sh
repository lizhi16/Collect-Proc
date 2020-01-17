##reference: http://people.duke.edu/~ccc14/duke-hts-2017/Statistics/08032017/GATK-pipeline-sample.html

##set path
mygatk="gatk"
mybwa="bwa"
mywd="/home/pipeline/"
mypicard="/home/picard.jar"

##set sample data (reads) path
myreads="/home/pipeline/"

##set reference and annotation files
myrefdir="/home/pipeline/"
myfasta="/home/pipeline/human_g1k_v37.fasta"

##set the directory of outputs from middle steps
myprocess="/home/pipeline/"

##create dictionary of reference sequence
cd $myrefdir
$mygatk CreateSequenceDictionary -R $myfasta

##alignment to reference sequence
##To download BWA, please refer: https://github.com/lh3/bwa
##human reads data from 1k genomes project: ftp://ftp.1000genomes.ebi.ac.uk/vol1/ftp/phase3/data
myR1=$myreads"SRR360579_1.filt.fastq"
myR2=$myreads"SRR360579_2.filt.fastq"
mysampleBase="SRR360579.filt"

pwd
#time $mybwa index $myfasta
time $mybwa mem \
-aM \
-t 1 \
$myfasta \
$myR1 $myR2 \
> $myprocess${mysampleBase}.sam 2> $myprocess${mysampleBase}-bwasam.err

##add read groups, sort the reads, save as bam and index bam
##To download picard, please refer: https://github.com/broadinstitute/picard/releases/tag/2.19.0
cd $mywd
myrgID=SRR035308-001 ##unique label
myrgSM=SRR035308 ##sample
myrgLB=SRR035308 ##librabry
myrgPL=illumina ##platform
myrgPU=SRR035308 ##platform unit
time java -Djava.io.tmpdir=$myprocess -jar \
     $mypicard AddOrReplaceReadGroups \
     I=$myprocess${mysampleBase}.sam \
     O=${myprocess}${mysampleBase}-sort-rg.bam \
     SORT_ORDER=coordinate \
     CREATE_INDEX=true \
     RGID=$myrgID RGSM=$myrgSM RGLB=$myrgLB RGPL=$myrgPL RGPU=$myrgPU\
     >  $myprocess${mysampleBase}-rgsort.out 2> $myprocess${mysampleBase}-rgsort.err


##mark duplicate reads
time java -Djava.io.tmpdir=$myprocess -jar \
$mypicard MarkDuplicates I=$myprocess${mysampleBase}-sort-rg.bam \
O=$myprocess${mysampleBase}-sort-rg-dedup.bam M=$myprocess${mysampleBase}-dedup-metric.txt \
ASSUME_SORT_ORDER=coordinate \
CREATE_INDEX=true \
> $myprocess${mysampleBase}-dedup.out 2> $myprocess${mysampleBase}-dedup.err


##Call variants using Haplotype Caller
##To download samtools, please refer: http://samtools.sourceforge.net/
cd $myrefdir
time samtools faidx $myfasta
     $mygatk --java-options "-Xmx4g" HaplotypeCaller \
     -R $myfasta \
     -I $myprocess${mysampleBase}"-sort-rg.bam" \
     -O $mywd${mysampleBase}"-GATK-HC.vcf"
