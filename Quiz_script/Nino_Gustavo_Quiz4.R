##Gustavo Enrique Nino
#Geog 489

##Creation of the random distributions 

y<-rnorm(100,mean=1,sd=1) ##Normal distribution 
x<-runif(200,min = 0, max = 2) ##Uniform distribution

z<-data.frame(Normal = y, Uniform = x) ##Data frame with both values

#Create the function that count the values 

count <- function(x) 
{
  k <- 0
  for (n in x) {
    if(n > 0.5 & n<1.5)
    {
      k <- k+1
    }
  }
  return(k)
}

##Use of lapply function 

solution <- lapply(z,FUN = count)

solution ##Check the result
