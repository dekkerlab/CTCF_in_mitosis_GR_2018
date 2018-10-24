#Details for making heatmap with ggplot2 refer to following page-
#https://www.r-bloggers.com/making-faceted-heatmaps-with-ggplot2/

#https://cran.r-project.org/web/packages/viridis/vignettes/intro-to-viridis.html          #explanation on how to use viridis
#http://blog.aicry.com/r-heat-maps-with-ggplot2/                                          #using ggplot with a matrix
#https://learnr.wordpress.com/2010/01/26/ggplot2-quick-heatmap-plotting/  

#Created by Mihir Metkar, 10/20/16, adapted by Marlies Oomen, 2/23/17

#install.packages("data.table")  # faster fread() and better weekdays()
#install.packages("dplyr")     # consistent data.frame operations
#install.packages("purrr")       # consistent & safe list/vector munging
#install.packages("tidyr")       # consistent data.frame cleaning
#install.packages("ggplot2")     # base plots are for Coursera professors
#install.packages("scales")      # pairs nicely with ggplot2 for plot label formatting
#install.packages("gridExtra")   # a helper for arranging individual ggplot objects
#install.packages("ggthemes")    # has a clean theme for ggplot2
#install.packages("viridis")     # best. color. palette. evar.
#install.packages("knitr")       # kable : prettier data.frame output
#install.packages("reshape2")
#install.packages ("RColorBrewer")
#install.packages("gplots")


library (data.table)  # faster fread() and better weekdays()
library(dplyr)       # consistent data.frame operations
#library(purrr)       # consistent & safe list/vector munging
library(tidyr)       # consistent data.frame cleaning
library(ggplot2)     # base plots are for Coursera professors
library(scales)      # pairs nicely with ggplot2 for plot label formatting
library(gridExtra)   # a helper for arranging individual ggplot objects
library(ggthemes)    # has a clean theme for ggplot2
library(viridis)     # best. color. palette. evar.
library(knitr)       # kable : prettier data.frame output
library(reshape2)
library (RColorBrewer)
#library(gplots)


#load data

args <- commandArgs(TRUE)
my.folder<-args[1]

#limits_color_max <- args[2]
#limits_color_max_num<-function(limits_color_max,numeric=TRUE)

#limits_color<-c(0,limits_color_max_num)

limits_color<-c(0,5)
print("limit color scale")
print(limits_color)

#squished scale

#NS

#Read input file
setwd(my.folder)
getwd()
my.file.list.NS <- list.files(pattern = "$")

#open output file 
pdf.file<-paste("../../NS_C_Vplot_squished.pdf",sep='')
pdf(file=pdf.file, width=20, height=20)
par(mfcol=c(12,12), oma=c(1,1,0,0), mar=c(1,1,1,1), mgp=c(2,1,0))

#convert list of files into table and convert then to matrix
my.list <- lapply(X = my.file.list.NS, FUN = function(x) {
  read.table(x, sep = "\t", skip = 1)[,2]
})
my.df <- do.call("cbind", my.list)
matrix_file <- t(my.df)
matrix_file.melted <- melt(matrix_file) 


ggplot(matrix_file.melted, 
       aes(y=Var1, 
           x=Var2, 
           fill=value)) + 
  geom_tile() +                                         
  scale_fill_gradientn(colors=c("white", "orange", "red", "darkred"),
                       limits=limits_color,
					   oob=squish) +
  scale_x_continuous(breaks=c(0,10,20,30,40,50,60,70,80,90,100,110,120,130,140,150,160),
                     labels=c("-2000","-1750","-1500","-1250","-1000","-750","-500","-250", "0","250","500","750","1000","1250","1500","1750", "2000"),
                     expand = c(0.005, 0)) +
  scale_y_continuous(breaks=c(0,4,8,12,16,20,24,28,32,36,40),
                     labels=c("0","100","200","300","400", "500", "600","700","800","900", "1000"),
                     expand = c(0.005,0)) +
  labs(y="fragment length", 
       x="distance to element", 
       title="Non Synchronous Cells Squished Color Scale") + 
  theme(plot.title=element_text(hjust=0,size=40),
  		axis.title=element_text(size=35),
		axis.text=element_text(size=20),
		legend.title=element_text(size=30),
		legend.text=element_text(size=20)) 

#Mitotic Cell
#Read input file
setwd("../../MOAM-HeLa-M-C_ALL.bam.no_blacklist_regions.bam/aggregateVectors")
getwd()
my.file.list.NS <- list.files(pattern = "$")
#open output file 
pdf.file<-paste("../../M_C_Vplot_squished.pdf",sep='')
pdf(file=pdf.file, width=20, height=20)
par(mfcol=c(12,12), oma=c(1,1,0,0), mar=c(1,1,1,1), mgp=c(2,1,0))
#convert list of files into table and convert then to matrix
my.list <- lapply(X = my.file.list.NS, FUN = function(x) {
  read.table(x, sep = "\t", skip = 1)[,2]
})
my.df <- do.call("cbind", my.list)
matrix_file <- t(my.df)
matrix_file.melted <- melt(matrix_file) 

ggplot(matrix_file.melted, 
       aes(y=Var1, 
           x=Var2, 
           fill=value)) + 
  geom_tile() +                                         
  scale_fill_gradientn(colors=c("white", "orange", "red", "darkred"),
                       limits=limits_color,
					   oob=squish) +
  scale_x_continuous(breaks=c(0,10,20,30,40,50,60,70,80,90,100,110,120,130,140,150,160),
                     labels=c("-2000","-1750","-1500","-1250","-1000","-750","-500","-250", "0","250","500","750","1000","1250","1500","1750", "2000"),
                     expand = c(0.005, 0)) +
  scale_y_continuous(breaks=c(0,4,8,12,16,20,24,28,32,36,40),
                     labels=c("0","100","200","300","400", "500", "600","700","800","900", "1000"),
                     expand = c(0.005,0)) +
  labs(y="fragment length", 
       x="distance to element", 
       title="Mitotic Cells Squished Color Scale") + 
  theme(plot.title=element_text(hjust=0,size=40),
  		axis.title=element_text(size=35),
		axis.text=element_text(size=20),
		legend.title=element_text(size=30),
		legend.text=element_text(size=20)) 


#Mitotic Cluster
#Read input file
setwd("../../MOAM-HeLa-M-Cl-FCl_ALL.bam.no_blacklist_regions.bam/aggregateVectors")
getwd()
my.file.list.NS <- list.files(pattern = "$")
#open output file 
pdf.file<-paste("../../M_Cl_FCl_Vplot_squished.pdf",sep='')
pdf(file=pdf.file, width=20, height=20)
par(mfcol=c(12,12), oma=c(1,1,0,0), mar=c(1,1,1,1), mgp=c(2,1,0))
#convert list of files into table and convert then to matrix
my.list <- lapply(X = my.file.list.NS, FUN = function(x) {
  read.table(x, sep = "\t", skip = 1)[,2]
})
my.df <- do.call("cbind", my.list)
matrix_file <- t(my.df)
matrix_file.melted <- melt(matrix_file) 

ggplot(matrix_file.melted, 
       aes(y=Var1, 
           x=Var2, 
           fill=value)) + 
  geom_tile() +                                         
  scale_fill_gradientn(colors=c("white", "orange", "red", "darkred"),
                       limits=limits_color,
					   oob=squish) +
  scale_x_continuous(breaks=c(0,10,20,30,40,50,60,70,80,90,100,110,120,130,140,150,160),
                     labels=c("-2000","-1750","-1500","-1250","-1000","-750","-500","-250", "0","250","500","750","1000","1250","1500","1750", "2000"),
                     expand = c(0.005, 0)) +
  scale_y_continuous(breaks=c(0,4,8,12,16,20,24,28,32,36,40),
                     labels=c("0","100","200","300","400", "500", "600","700","800","900", "1000"),
                     expand = c(0.005,0)) +
  labs(y="fragment length", 
       x="distance to element", 
       title="Mitotic Frozen Cluster Squished Color Scale") + 
  theme(plot.title=element_text(hjust=0,size=40),
  		axis.title=element_text(size=35),
		axis.text=element_text(size=20),
		legend.title=element_text(size=30),
		legend.text=element_text(size=20)) 