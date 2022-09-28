# DVS-assembly-and-allele-aware-RNAseq-pipeline

### Phased assembly of expanded and collapsed regions in the raw assembly
![Supplemental Figure 1](https://user-images.githubusercontent.com/46752436/192521914-5f5b54a6-b5d8-4d54-b39a-cdf6d1938ead.jpg)
First step, manual inspection to identify the expanded or collapsed region in the raw CANU assembly. Then using the fc_unzip_region.sh to output the overlapped reads including those aligned to the upstream and downstream 50 kb regions as shown in the above figure. Then using minimap2 (-x asm5) to align the phased contigs back to the
raw contigs with the expanded or collapsed regions and their upstream and downstream 20 kb regions.

### Allele-aware RNAseq pipeline for Sweet orange and other inter-species hybrids between pummelo and mandarin
1. Install the necessary software packages:
  - gffread v0.12.7
  - salmon v1.7.0
  - samtools v1.7.1
  - R version v4.1.3
     - deseq2 v1.34.0
     - tximport v1.22.0
     - tximportdata v1.22.0
     - readr v2.1.2
```  
    # Could use conda to automatically install all the packages using the file DVS_RNASEQ_environment.yaml, 
    # which will create an environment named DVS_RNASEQ
    conda env create -f DVS_RNASEQ_environment.yaml
    # Activate the conda environment
    conda activate DVS_RNASEQ
```
2. The masked DVS assembly and gene structure annotation files (CK2021.09202021.NCBI.fasta and CK2021.09202021.NCBI.gff3) are accessible from https://doi.org/10.6084/m9.figshare.19127066.v1. Prepare the reference transcript sequences for salmon: 
```  
    # Output transcripts from DVS genome
    gffread DVS.09202021.masked.gff3 -g DVS.09202021.masked.fasta -w DVS_masked.transcripts.fasta

    # Preparing fully decoyed transcript index
    # Salmon tutorial from https://combine-lab.github.io/salmon/getting_started/#indexing-txome
    grep "^>" CK2021.09202021.NCBI.fasta | cut -d " " -f 1 > decoys.txt
    sed -i.bak -e 's/>//g' decoys.txt
    cat DVS_masked.transcripts.fasta CK2021.09202021.NCBI.fasta > DVS_masked.decoy.fasta

    # Index the transcript fasta file from DVS
    salmon index -t DVS_masked.decoy.fasta -d decoys.txt -p 8 -i DVS_masked --gencode
```  
3. Run salmon quntification on RNA-seq data of each sample separately with option --useVBOpt (Use the Variational Bayesian EM for multiple-mapped read counting)
```
# Set number of threads to be used in salmon read quntification process
THREADS=8
# Run salmon quantification for each sample. The fastq files are clean with adapters, barcodes, and low-quality 
# terminal bases removed, which could be either compressed or not. If the fastq files are not in the current working
# fold, their full paths should be supplied.
for SAMP in sample1 sample2 sample3 (...) sampleN; do
salmon quant -i DVS_masked -l A --useVBOpt \
         -1 ${SAMP}_1.fq.gz \
         -2 ${SAMP}_2.fq.gz \
         -p $THREADS --validateMappings -o quants/${SAMP}
done
```
4. Run R script for differential expression analysis at both the allele- and orthogroup-level
First, prepare a tab delimited sample information table file SAMPLE_INFO.tsv.

\# Sample info table should contain two columns named 'sample' and 'condition', the sample names must be the same as those used in the 3rd step above

\# Only two conditions are allowed in the table. If multiple condititions are to be compared pairwisely, you should parepare multiple sample information tables

SAMPLE_INFO.tsv:

![image](https://user-images.githubusercontent.com/46752436/192543369-0e7d3ebd-6094-435a-9f92-128662009d1e.png)


Second, run DVS_RNASEQ.R using the provided SAMPLE_INFO.tsv
```
# The R script should be run in the same working dir as the salmon quant command
# The two table files TR_DVS_GENE.FINAL.tsv and TX_DVS_ORTHOGROUP.FINAL.tsv in the folder allele-aware-RNAseq-pipeline 
# should be provided in the current working dir
# The differential expression analysis results will be found in condition1_vs_condition2.allele.tsv (allele-level) and 
# condition1_vs_condition2.orthogroup.tsv (orthogroup-level)
./DVS_RNASEQ.R SAMPLE_INFO.tsv
```

