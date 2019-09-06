#RoseZHill-rzhill@berkeley.edu
#this script contains the parameters used to perform the mapping and read count assignments for the RNA-seq data in this paper
#!/usr/bin/env python
import sys
import os

dir_name = sys.argv[-1] #give dir as sample fastqdir
if dir_name[-1] != '/':
    dir_name = dir_name+'/'

d  = os.listdir(dir_name)
strain = sys.argv[-2] #strain name
gtf = "/path/to/Mus_musculus/Ensembl/GRCm38/Annotation/Genes/genes.gtf" #change this
#define any additional genomes-gtfs here i.e. if you're using other strains
genome = "/path/to/Mus_musculus/Ensembl/GRCm38/Sequence/Bowtie2Index/genome" #change this
out_dir_name = "/path/to/fastq/readmapping" #change this


htseq_out_dir = '%shtseq_out/' % out_dir_name
com = 'mkdir -p %s' % htseq_out_dir 
os.system(com)

for f in d:
    if strain == 'BL6':
        com = "tophat -o %s --max-multihits 1 -G %s --no-novel-juncs --no-novel-indels %s %s" % (out_dir_name+f,gtf,genome,dir_name+f) #can change mapping parameters here
    ##can add additional if statements for other strains or genomes/transcriptomes you wish to map to    
    os.system(com)                                                                                                                                   
    #print(com)

    full_path = out_dir_name+f
    bam = full_path + '/accepted_hits.bam'
    out_file = '%s%s' % (htseq_out_dir, f+'.count')

    com='samtools view %s | htseq-count -s no -m intersection-strict - /path/to/Mus_musculus/Ensembl/GRCm38/Annotation/Genes/genes.gtf > %s' %(bam,out_file) #can change htseq parameters here
    os.system(com)
    #print com
#samples are now ready to use with DEseq
