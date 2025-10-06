
## Generate a variable to prove the functions
x<-c(1,2,3,4,5,6,7,8,9,10)
##1. Function that count the number of observations that can be devided by 3
count3 <- function(x) 
{
  k <- 0 # assign 0 to k
  for (n in x) {
    if(n %% 3 == 0)
    {
      k <- k+1 # %% is the modulo operator
    }
  }
  return(k)
}
##Proof of the function

count3(x)

##2. Function that show the position of values devided by 3

which3 <- function(x) { return(which(x %% 3 ==0))}

##Proof of the function

which3(x)