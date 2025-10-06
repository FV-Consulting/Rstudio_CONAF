#Creation of the Matrix
p<- matrix(c(1,2,3,4,5,6), ncol = 3,byrow = TRUE)

#Assign the values for each column
for(i in 1:nrow (p)){
for(j in 1:ncol(p))
  {
   if (i == 1) {p[i,j] <- 10}
   if (i == 2) {p[i,j] <- 20}
    
}
}

##Proof of the procedure

p


