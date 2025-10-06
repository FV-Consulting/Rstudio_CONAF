##Assigment 4
##Gustavo Nino
### GEOG 489: Programming for GIS

##Determine the directory
getwd()
setwd("C:/Users/Gustavo/Documents/UIUC/Courses/Spring 2020/Programming GIS/Assigments/Assigment Questions/Assignment4")

##Creation of the function

plotTableFromDisk<-function(dataFile,outpdf = "mypdf.pdf",outcor = "mycor.csv")
{
readfile<-read.csv(dataFile,header = TRUE, as.is = TRUE)  ##Read the file 

pair<-combn(1:ncol(readfile),2,simplify=F) ##Create the pair combinations

csv<-file(outcor,"w")##create file of csv

header <- paste("xcol","ycol","correlation",sep=",")
writeLines(text=header,con=csv)

## Create the correlation function for the pairs
geneCor <- function(pair,gene=readfile)
{
  xlabel<-names(gene[pair[1]])
  ylabel<-names(gene[pair[2]])
  
  a<-cor(gene[,pair[1]],gene[,pair[2]])
  writeLines(text=paste(xlabel,ylabel,a,sep=","),con=csv)
}

outcor<- lapply(pair[1:6],geneCor) ##All the correlations


pdf<-pdf(file=outpdf) ##Create pdf file

##Create the plotting of the pairs
genplot<-function(pair,gene=readfile)
{
  xlabel<-names(gene[pair[1]])
  ylabel<-names(gene[pair[2]])
  
  plot(gene[,pair[1]],gene[,pair[2]],xlim=c(min(readfile),max(readfile))
       ,ylim=c(min(readfile),max(readfile)),xlab = xlabel
       , ylab = ylabel, main = paste(xlabel,"vs",ylabel),
       pch=2,col="red",cex=1.5)
  
  line<-lm(gene[,pair[2]]~gene[,pair[1]])
  abline(line,col = "blue")
  
}

outcor2<- lapply(pair[1:6],genplot,gene = readfile) ##All the plotting
  
##Closing files
dev.off()
close(csv)

return(NULL)
}


##Proof
plotTableFromDisk(dataFile="geneData.csv",outpdf="mypdf.pdf",outcor="mycor.csv")





