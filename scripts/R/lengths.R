#load data

args <- commandArgs(TRUE)
inputFile<-args[1]
label<-args[2]

#setwd("lengths")
data<-read.table(inputFile,header=F,sep="\t")
x.data<-data

#histogram
pdf.file<-paste(inputFile,".pdf",sep='')
pdf(pdf.file)

myhist.x<-hist(x.data$V1,breaks=1000,main=paste(label),xlab="lenght of fragment (bp)")
#plot (myhist.x,col=rgb(1,0,0,0.3),border=F,yaxt="n",xlab="fragment length (bp)",xlim=c(0,1000),main="ATAC-seq Fragment lengths")
#legend("topright", inset=.05,c(label), fill=c(rgb(1,0,0,0.3)), horiz=FALSE)
#density plot
plot(myhist.x$mids,myhist.x$density,type="n",yaxt="n",ylab="Frequency",xlab="lenght of fragment (bp)",xlim=c(0,1000),main="ATAC-seq Lengths distribution")
lines(myhist.x$mids,myhist.x$density,col="red",lwd=2.5,type="l")
legend("topright", inset=.05,c(label), fill=c(rgb(1,0,0)), horiz=FALSE)
#log plot
plot(myhist.x$mids,myhist.x$density,type="n",log="y",ylab="log Frequency",xlab="lenght of fragment (bp)",xlim=c(0,1300),ylim=c(1e-6,1e-1),yaxt="n",main="ATAC-seq Log Lengths distribution")
lines(myhist.x$mids,myhist.x$density,col="red",lwd=2.5,type="l")
legend("topright", inset=.05,c(label), fill=c(rgb(1,0,0)), horiz=FALSE)

