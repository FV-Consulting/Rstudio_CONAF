x  <- c(1,2,3)

for (i in 1>lenght(x)){
  
  print(x[i])
  
}


y<- matrix(c(1,2,3,4,5,6), nrow = 3)

for(i in 1:nrow(y)){
  
  print(y[i,1])
}

for(i in 1:nrow(y)){
  for(j in 1:ncol(y)){
   
     print(y[i,j])  
    
  }
  
}

j <- list(name ="Joe", salary = 55000, union = T)