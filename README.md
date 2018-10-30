# CTCF_in_mitosis_GR_2018

All code used for analysis of ATAC-seq and CUT&RUN data for the study "CTCF sites display cell cycle dependent dynamics in factor binding and nucleosome positioning". Code for 5C analysis can be found at https://github.com/dekkerlab/cworld-dekker. Code for SpaSPT imaging analysis can be found at https://gitlab.com/tjian-darzacq-lab/spot-on-matlab and https://gitlab.com/tjian-darzacq-lab/SPT_LocAndTrack. 

BioRxiv link to manuscript:
https://www.biorxiv.org/content/early/2018/07/11/365866 

Genomics Data is available on GEO: 
https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE121840

Imaging data is available on Zenodo: 
https://zenodo.org/record/1306976

## Contact information

Please contact Marlies Oomen at marlies.oomen@umassmed.edu for additional information. 

## Disclaimer

These scripts are not meant to work without modification before usage, as many of the scripts (e.g. the bash scripts) will not work outside of the lsf environment that we used during this study. However, the scripts are meant to function as a log on how we did the analysis. Please read the text files in the notes folder for more detailed instruction on how the scripts in this github and from https://github.com/dekkerlab/cworld-dekker were used to perform genomics analysis in our study. 


## Modules and R-packages used:
Modules in LSF environment:

perl/5.18.1			                        
python/2.7.9					                        
python/2.7.9_packages/numpy/1.9.2					                        
python/2.7.9_packages/matplotlib/1.4.3					                        
python/2.7.9_packages/scipy/0.15.1					                        
python/2.7.9_packages/cython/0.23.4					                        
python/2.7.9_packages/pysam/0.8.4					                        
python/2.7.9_packages/h5py/2.5.0					                        
python/2.7.9_packages/scikit-learn/0.17					                        
python/2.7.9_packages/cython/0.22.1					                        
R/3.3.1					                        
bedtools/2.25.0					                        
hpctools/1.0.0					                        
samtools/1.2					                        
bamtools/2.3.0					                        
git/2.1.3					                        
bowtie2/2-2.1.0					                        
blat/35x1					                        
HOMER/4.6					                        
novocraft/V3.02.08					                        
java/1.8.0_77					                        
fastqc/0.11.5					                        
trimmomatic/0.32			 		                        

R-packages:

library(tidyverse)		                        
library(data.table)  		                        
library(dplyr)       		                        
library(tidyr)       		                        
library(ggplot2)     
library(scales)     
library(gridExtra)  
library(ggthemes)   
library(viridis)    
library(knitr)       
library(reshape2)
library (RColorBrewer)
		                        
