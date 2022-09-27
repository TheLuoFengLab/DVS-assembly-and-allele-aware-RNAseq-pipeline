#!/bin/bash
#${1} main contig
#${2} main contig diploid region
#${3} alternative contig 1
#${4} alternative contig 1 end 10kb region
#${5} alternative contig 2
#${6} alternative contig 2 end 10kb region
BAM=$7 #Path to the bam file in which all the Pacbio CLR reads have been mapped back to the CANU raw assembly using minimap2 
SUBREADS=$8 #Path to the raw Pacbio CLR subread bam file that contains the pulse level signals

mkdir FALCON_UNZIP_${1}.${2} && cd FALCON_UNZIP_${1}.${2}
conda activate smrtlink
samtools view -b -F 4 $BAM "${1}:${2}" | samtools fasta - > ${1}.${2}.fasta
samtools view -b -F 4 $BAM "${3}:${4}" | samtools fasta - >> ${1}.${2}.fasta
samtools view -b -F 4 $BAM "${5}:${6}" | samtools fasta - >> ${1}.${2}.fasta
echo "${PWD}/${1}.${2}.fasta" > input.fofn
echo $SUBREADS > input_bam.fofn
fc_run fc_run.cfg
fc_unzip.py fc_unzip.cfg
