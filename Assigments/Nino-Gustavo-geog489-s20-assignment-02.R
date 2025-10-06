##Gustavo Niño
#Assigment 2
##Geog 489

##First we create the local smoother function

localSmoother<-function(myMatrix, smoothingMatrix = matrix(2,3,3)) {
  
  if(class(myMatrix)!= "matrix") { stop("myMatrix must be a matrix")} ##Check if the class is matrix
    
  if(mode(myMatrix) != "numeric" & mode(myMatrix) != "Integer") {stop("myMatrix must be numeric or integer")} ##Check numeric and integer
  
  if(class(smoothingMatrix)!="matrix") { stop("smoothingMatrix must be a matrix")} ##Check if the class is matrix
  
  if(mode(smoothingMatrix) != "numeric" & mode(smoothingMatrix) != "integer") {stop("smoothingMatrix must be numeric or integer")} ##check numeric and integer
  
  if((length(smoothingMatrix[,1])*length(smoothingMatrix[1,]))!=9) {stop("smoothingMatrix must be 3x3")} #Check the dimentions of smooth matrix
 
  #Create the conditions for the loops
  start_r<- 2 #avoid the edge of the first row
  end_r<- nrow(myMatrix)-1 #avoid the edge of the last row
  start_c<-2 #avoid the edge of the first column
  end_c<- ncol(myMatrix)-1 #avoid the edge of the last column
  
  result <- matrix(nrow=nrow(myMatrix),ncol=ncol(myMatrix)) #define the result matrix
  
  for(i in start_r:end_r)  
    {
  for (j in start_r:end_r)  
    {
      a<-myMatrix[(i-1):(i+1),(j-1):(j+1)] 
      windowsm<- a*smoothingMatrix ##Calculate the smooth
      result[i,j]<- sum(windowsm)/9 ##Replace the values in the result matrix
       }
          }
return(result)
}

#Check result

##Function is working
localSmoother(myMatrix = diag(x=2,nrow=5,ncol=5),smoothingMatrix=matrix(1:9,nrow=3,ncol=3))

# Error checking:
localSmoother(myMatrix = diag(x=2,nrow=5,ncol=5))

localSmoother(myMatrix =1:10,smoothingMatrix=matrix(2,nrow=3,ncol=3))

localSmoother(myMatrix = matrix("a",nrow=5,ncol=5),smoothingMatrix=matrix(2,nrow=3,ncol=3))

localSmoother(myMatrix = diag(x=2,nrow=5,ncol=5),smoothingMatrix=1:9)

localSmoother(myMatrix = diag(x=2,nrow=5,ncol=5),smoothingMatrix=matrix(2,nrow=5,ncol=3))

localSmoother(myMatrix = diag(x=2,nrow=5,ncol=5),smoothingMatrix=matrix("a",nrow=3,ncol=3))

