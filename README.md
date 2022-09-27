# DVS-assembly-and-allele-aware-RNAseq-pipeline

### Phased assembly of expanded and collapsed regions in the raw assembly
![Supplemental Figure 1](https://user-images.githubusercontent.com/46752436/192521914-5f5b54a6-b5d8-4d54-b39a-cdf6d1938ead.jpg)
First step, manual inspection to identify the expanded or collapsed region in the raw CANU assembly. Then using the fc_unzip_region.sh to output the overlapped reads including those aligned to the upstream and downstream 50 kb regions as shown in the above figure. Then using minimap2 (-x asm5) to align the phased contigs back to the
raw contigs with the expanded or collapsed regions and their upstream and downstream 20 kb regions.

