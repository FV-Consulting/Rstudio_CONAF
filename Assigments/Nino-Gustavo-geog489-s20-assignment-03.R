## Gustavo Enrique Nno
##Assignment 3

##First we create the function

## We create the default vector for Quantiles

a<-c(0.25,0.5,0.75)

## First we create the function that calculate the statistics

stat<-function(x,probs,na.rm) {
  
  if (class(x)!="numeric" & class(x)!= "integer" |(!na.rm & any(is.na(x)))) {l<- list(mean=NA,median=NA,sd=NA,quantile=NA)} #Define NA
  else { 
    l<-vector(mode="list") 
    
    #Define mean, median, sd and quantiles
    
    l$mean<-mean(x,na.rm = na.rm)
    l$median<-median(x,na.rm = na.rm)
    l$sd<-sd(x,na.rm)
    lquantile<- quantile(x,probs = probs,na.rm = na.rm)
    l$quantile<-matrix(c(probs,lquantile),ncol=2,byrow = FALSE)
    colnames(l$quantile)<-c("probs","quantiles")
  }
  
  return(l)
  
}

##Now we create the function that use the statistics 

descriptiveStats<-function(x,probs=a,na.rm=FALSE) {
  
  if (class(x)!="data.frame") {stop("x must be a data frame") } #Stop if it is not data frame
  if (class(probs)!="numeric") {stop("probs must be numeric")} #Stop if the prob are not numeric
  if (any(probs>1)|any(probs<0)) {stop("probs must be bigger than 0 and less than 1")} # Stop if the probs are not between 1 and 0
  
  return(lapply(x,stat,probs = probs, na.rm = na.rm)) ##Define the output function
  
}


##Proof of the function

#First Test
myDataFrame1 <- data.frame(col1=((25:1)*10),col2=1:25,col3=letters[1:25])
descriptiveStats(x=myDataFrame1,probs=c(.25,.50),na.rm=FALSE)

#Second Test
myDataFrame2 <- data.frame(col1=c(NA,((24:1)*10)),col2=1:25,col3=letters[1:25])
descriptiveStats(myDataFrame2)

#Third Test
descriptiveStats(myDataFrame2,na.rm=TRUE)


















