#!/usr/bin/env Rscript
# test if there is one argument: if not, return an error
args = commandArgs(trailingOnly=TRUE)
if (length(args)==0) {
  stop("Sample info table must be supplied ", call.=FALSE)
} 

# Load libraries
library("tximport")
library("readr")
library("tximportData")
library("DESeq2")

#Read sample info table
samples <- read.table(args[1],header=1)

#Tread condition column as factor
samples$condition <- factor(samples$condition)

#Use sample name as rownames
rownames <- samples$sample

#Get quant.sf file paths for all samples
files <- file.path('quants', samples$sample, "quant.sf")
names(files) <- samples$sample

#Read transcript name to gene id table
tx2gene <- read.table("TR_DVS_GENE.FINAL.tsv",header=TRUE)

#Read quantification files
txi <- tximport(files, type="salmon", tx2gene=tx2gene)

#tximport object to matrix
dds <- DESeqDataSetFromTximport(txi,colData = samples,design = ~ condition)

#Filter genes with less than 10 total read count
keep <- rowSums(counts(dds)) >= 10
dds <- dds[keep,]

#DESeq statistical analysis
dds <- DESeq(dds)
res <- results(dds)

#Order genes according to padj and save as table
cond <- levels(samples$condition)
NAME <- paste(cond[1],"_vs_",cond[2],'.allele.tsv',sep="")
write.table(res[order(res$padj),],NAME)

tx2orthogroup <- read.table("TX_ORTHOGROUP.FINAL.tsv",header=TRUE)
txi <- tximport(files, type="salmon", tx2gene=tx2orthogroup)
dds <- DESeqDataSetFromTximport(txi,colData = samples,design = ~ condition)
keep <- rowSums(counts(dds)) >= 10
dds <- dds[keep,]
dds <- DESeq(dds)
res <- results(dds)
cond <- levels(samples$condition)
NAME <- paste(cond[1],"_vs_",cond[2],'.orthogroup.tsv',sep="")
write.table(res[order(res$padj),],NAME)
