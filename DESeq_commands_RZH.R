# http://bioconductor.org/packages/release/bioc/html/DESeq.html
# http://127.0.0.1:11214/library/DESeq/doc/DESeq.pdf
# https://dwheelerau.com/2013/04/15/how-to-use-deseq-to-analyse-rnaseq-data/
#this is a template of commands used to generate the differential expression data in this publication
# general example for running DEseq on dataset with 2 conditions and 3 replicates each
# 'your_data_file' should include raw count for each gene/transcript for each sample

source("https://bioconductor.org/biocLite.R")
biocLite("DESeq")
browseVignettes("DESeq")
library("DESeq")

datafile = "your_data_file" #your merged htseq-counts table
countTable = read.table(datafile, header=TRUE, row.names=1)
dim(countTable)
head(countTable)
samples = c("cond1","cond1","cond1","cond2","cond2","cond2") #list your conditions here
design = data.frame(row.names = colnames(countTable), condition = samples, libType = c("single-end","single-end","single-end","single-end","single-end","single-end") ) #single-end or paired-end
condition = factor(samples)
cds = estimateSizeFactors(newCountDataSet(countTable, condition))
sizeFactors(cds)
head(counts(cds, normalized=TRUE))
cds = estimateDispersions(cds)
str(fitInfo(cds))
plotDispEsts(cds)
head(fData(cds))
res = nbinomTest(cds, "cond1", "cond2") #put your conditions here
head(res)

# print results to text file
write.csv(res, file="results_file_name.csv")








