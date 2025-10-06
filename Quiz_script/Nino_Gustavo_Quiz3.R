#Creation of the function

factorial <- function(x) {
  if (x <= 0)    return (1)
  if (x>0)       return (x * factorial(x-1))
}

#Proof of the function

factorial(5)