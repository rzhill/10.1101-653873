                                        #RoseZHill rzhill@berkeley.edu
#this is a template of commands used to generate the heatmap RNA-seq figures in this publication
#if (!require("gplots")) {
   #install.packages("gplots", dependencies = TRUE)
   #library(gplots)
   #}
#if (!require("RColorBrewer")) {
   #install.packages("RColorBrewer", dependencies = TRUE)
   #library(RColorBrewer)
   #}
                                        #used -4 - 8 range for skin, -4 to 4 range for tg
#used a .csv with log2 fold changes and gene names of desired genes as input, with gene names in first column.
library(gplots)
library(RColorBrewer)

f <- file.path("/path/to/table.csv") #change
data <- read.csv(f, sep=",")
genenames <- data[,1]                            
mat_data_time <- data.matrix(data[,2:4]) #change  
rownames(mat_data_time) <- genenames           

my_palette <- colorRampPalette(c("magenta", "yellow", "green"))(n = 299)

col_breaks = c(seq(-4,-1,length=100),  # for magenta, change
  seq(-0.9999,1.0,length=100),           # for yellow, change
  seq(1.0001,8,length=100))             # for green, change
#
png("/path/to/output.png", width = 3*300, height = 10*300, res = 300, pointsize = 12) #change        

heatmap.2(mat_data_time, Rowv = TRUE, Colv = NA, dendrogram = c("none"), trace = c("none"), col=my_palette, breaks = col_breaks, key = F, symkey = F, density.info = c("none"))               

dev.off() 

  
