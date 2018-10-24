print("hello!")

library(tidyverse)
library(data.table)  # faster fread() and better weekdays()
library(dplyr)       # consistent data.frame operations
library(tidyr)       # consistent data.frame cleaning
library(ggplot2)     # base plots are for Coursera professors
library(scales)      # pairs nicely with ggplot2 for plot label formatting
library(gridExtra)   # a helper for arranging individual ggplot objects
library(ggthemes)    # has a clean theme for ggplot2
library(viridis)     # best. color. palette. evar.
library(knitr)       # kable : prettier data.frame output
library(reshape2)
library (RColorBrewer)

args <- commandArgs(TRUE)
my.file<-args[1]
limits_color<-c(0,10)

pdf.file<-paste(my.file,".squished.pdf",sep='')
pdf(file=pdf.file, width=20, height=20)
par(mfcol=c(12,12), oma=c(1,1,0,0), mar=c(1,1,1,1), mgp=c(2,1,0))


#Convert table to matrix and call row and column names

my.table<- lapply(my.file,FUN=function(my.file) {
  read.table(my.file,sep="\t")
})

my.matrix <- do.call("cbind", my.table)
rownames(my.matrix) <- my.matrix[,1]
colnames(my.matrix) <- my.matrix [1,]

my.matrix.noLabels <- my.matrix[-(1:1),-(1:1)] 
motif.label <- my.matrix[-(1:1),-(1:1)] %>% rownames_to_column() %>% rename(motif = rowname) %>% select(motif)  

#order on cluster and means row, make table into matrix and use ggplot to draw heatmap 
mutate(my.matrix.noLabels,means_row = rowMeans(my.matrix.noLabels,na.rm = FALSE)) %>% 
  arrange(means_row) %>% 
  select(-(means_row)) %>%
  as.matrix() %>% 
  melt() %>%
  ggplot(aes(y=Var1,
           x=Var2,
           fill=value)) + 
  geom_tile() +
  #coord_fixed(ratio = 1) +  
  scale_fill_gradientn(colors=c("white", "orange", "red", "darkred"),
                       limits=limits_color,
                       oob=squish) +
  labs(y="Motif", 
       x="distance to element", 
       title="Heatmap Aggregation") + 
  theme(plot.title=element_text(hjust=0,size=50),
        axis.text.x=element_text(size=15),
        #axis.ticks.x=element_blank(),
        axis.text.y=element_blank(),
        axis.ticks.y=element_blank(),
        axis.title=element_text(size=35),
        legend.title=element_text(size=35),
        legend.text=element_text(size=25)) 

print("done")