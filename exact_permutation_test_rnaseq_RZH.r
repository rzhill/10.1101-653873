#this script will let you test a group of genes' log2fold changes and determine if they are better than random, thus revealing whether a particular group of gene's expression changes are significantly altered
#RoseZHill rzhill@berkeley.edu
pfinder <- function(geneID, deseq_df) {
    rownum <- which(deseq_df[,"Genename"] == geneID)
    pval <- as.character(deseq_df[rownum,"log2FoldChange"])
    return(pval)
}
set.seed(1002392038)
deseq_df <- na.omit(data.frame(read.csv("/path/to/file.csv"), header = TRUE)) #you can replace this file with any deseq expression file
siggenes <- scan("/path/to/genelist.txt", what="character") #replace with your tab-delimited gene list. make sure to only use actual gene symbols with no other information.
plist <- lapply(siggenes, FUN = pfinder, deseq_df)
plist <- na.omit(as.numeric(unlist(plist)))
pmedian <- median(abs(plist))

permlist <- list()
samples <- 10000
for (i in 1:samples) {
    perm <- na.omit(as.numeric(sample(as.character(deseq_df[,"log2FoldChange"]), length(siggenes), replace = FALSE))) 
    permmed <- median(abs(perm))
    permlist <- c(permlist,list(permmed))
    
}
medlist <- list()
for (i in permlist) {
    if(i >= pmedian) {
        medlist <- c(medlist,list(i))
    }
}

print(length(medlist)/samples)
      

