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
   
   \# Could use conda to automatically install all the packages using the file DVS_RNASEQ_environment.yaml, which will create an environment named DVS_RNASEQ
   > conda env create -f DVS_RNASEQ_environment.yaml
   \# Activate the conda environment
   conda activate DVS_RNASEQ
2. 
