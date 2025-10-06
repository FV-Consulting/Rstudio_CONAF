
##Creation of the verctor for proof
x<-c(1,2,3,4,5,6,7,8,9)

## First we create a function that work as input to count the observations

count <- function(x,d) 
{
  k <- 0
  for (n in x) {
    if(n %% d == 0)
    {
      k <- k+1
    }
  }
  return(k)
}


## Now we create the function "noRemainderIndices"

noRemainderIndices <- function(x,d=2) {  ##Define d as default value
  
  if  (mode(d)=="character") stop ("d must be numeric") ##Error for character values
  
  if  (length(d) != 1) stop ("d must have a length of 1") ##Error for length different to one
  
  if  (count(x,d) == 0) {print("Null")}     ##Generate the message of Null 
  
  if  (count(x,d) != 0) {return(which(x %% d == 0))} ##Function that choose the position
  
} 

##Proofs of the function

noRemainderIndices(x) ##Default 2
noRemainderIndices(x,3) ##change parameter
noRemainderIndices(x,3:4) ## Error lenght different to 1
noRemainderIndices(x,"ABC") ## Error character
noRemainderIndices(x,11) ## No remainders Null





