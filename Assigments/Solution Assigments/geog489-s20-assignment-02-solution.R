#	Chunyuan Diao
#	Assignment #2 Solution

#	1) The function name should be "localSmoother".
#	2) smoothingMatrix, by default, should be a 3x3 matrix of all 1s.
localSmoother <- function(myMatrix,smoothingMatrix=matrix(1,nrow=3,ncol=3),na.rm=FALSE)
{
	#	3) The class of myMatrix should be checked to make sure it is a matrix of mode numeric or integer.
	if(class(myMatrix) != "matrix") 
	{ 
		stop("myMatrix must be a matrix") 
	}
	
	if(mode(myMatrix) != "numeric" & mode(myMatrix) != "integer")
	{
		stop("myMatrix must be numeric or integer")
	}
	
	#	4) The dimensions of smoothingMatrix should be checked to make sure it is a numeric 3x3 matrix.
	if(class(smoothingMatrix) != "matrix")
	{
		stop("smoothingMatrix must be a matrix")
	}
	
	if(mode(smoothingMatrix) != "numeric" & mode(smoothingMatrix) != "integer")
	{
		stop("smoothingMatrix must be numeric or integer")
	}
	
	if(any(dim(smoothingMatrix) != 3))
	{
		stop("smoothingMatrix must by 3x3")
	}
	
	# We can add a buffer around the input matrix
	
	nrow_myMatrix <- nrow(myMatrix)
	ncol_myMatrix <- ncol(myMatrix)
	
	if(na.rm)
	{
	  # Extra credit solution:
	  # Add borders to the existing matrix by creating a larger matrix
	  #   (2 rows/columns larger) and placing the old matrix inside of
	  #   it.
		new_myMatrix <- matrix(nrow=(nrow_myMatrix+2),ncol=(ncol_myMatrix+2))
		new_myMatrix[2:(nrow_myMatrix+1),2:(ncol_myMatrix+1)] <- myMatrix
		myMatrix <- new_myMatrix
		nrow_myMatrix <- nrow(myMatrix)
		ncol_myMatrix <- ncol(myMatrix)
	}
	
	outMatrix <- matrix(nrow=nrow_myMatrix,ncol=ncol_myMatrix)
	
	# Since we have a 3x3 matrix, we want to skip processing the
	#   "edge" rows and columns.
	start_row <- 2 
	end_row <- nrow_myMatrix - 1 
	
	start_col <- 2
	end_col <- ncol_myMatrix - 1
	
	for(current_row in start_row:end_row)
	{
		for(current_col in start_col:end_col)
		{
			localWindow <- myMatrix[(current_row-1):(current_row+1),(current_col-1):(current_col+1)]
			localWindow_multiplied <- localWindow*smoothingMatrix
			outMatrix[current_row,current_col] <- mean(localWindow_multiplied,na.rm=na.rm)
		}
	}
	
	if(na.rm)
	{
	  # Extra credit solution.
		# Pull out the middle to return it to the correct size.
		outMatrix <- outMatrix[2:(nrow_myMatrix-1),2:(ncol_myMatrix-1)] 
	}
	
	return(outMatrix)
	
}

# Rubric:

# 1 point for naming the function correctly ("localSmoother"),
#	using myMatrix and and smoothingMatrix as variable names, 
# 	and setting smoothingMatrix=matrix(1,nrow=3,ncol=3) by default.
# 1 point for having all warnings in place:
#	- The class of myMatrix should be checked to make sure it is a matrix of mode numeric.
#		If it fails these checks it should stop with a warning.
#   - The dimensions of smoothingMatrix should be checked to make sure it is a numeric 3x3 matrix.
#		If it fails these checks it should stop with a warning.
#   - stop() had to be used instead of print()
# 1 point for commenting the code in at least 3 places, naming the file correctly,
#	and having the file labelled at the top with the person's name and Assignment #.
# 1 point if the function returns NA around the edge of the matrix.
# 6 points for core code functionality.  Note that the result must
#	be part of a return() statement, not a print() statement.

# Tested with:
localSmoother(myMatrix = diag(x=5,nrow=7,ncol=7),smoothingMatrix=matrix(1:9,nrow=3,ncol=3))
#[,1]     [,2]     [,3]     [,4]     [,5]     [,6] [,7]
#[1,]   NA       NA       NA       NA       NA       NA   NA
#[2,]   NA 8.333333 4.444444 1.666667 0.000000 0.000000   NA
#[3,]   NA 6.666667 8.333333 4.444444 1.666667 0.000000   NA
#[4,]   NA 3.888889 6.666667 8.333333 4.444444 1.666667   NA
#[5,]   NA 0.000000 3.888889 6.666667 8.333333 4.444444   NA
#[6,]   NA 0.000000 0.000000 3.888889 6.666667 8.333333   NA
#[7,]   NA       NA       NA       NA       NA       NA   NA

# Error checking:
localSmoother(myMatrix =1:10,smoothingMatrix=matrix(2,nrow=3,ncol=3))
#Error in localSmoother(myMatrix = 1:10, smoothingMatrix = matrix(2, nrow = 3,  : 
#						myMatrix must be a matrix

localSmoother(myMatrix = matrix("a",nrow=5,ncol=5),smoothingMatrix=matrix(2,nrow=3,ncol=3))
#Error in localSmoother(myMatrix = matrix("a", nrow = 5, ncol = 5), smoothingMatrix = matrix(2,  : 
#						myMatrix must be numeric or integer

localSmoother(myMatrix = diag(x=2,nrow=5,ncol=5),smoothingMatrix=1:9)
#Error in localSmoother(myMatrix = diag(x = 2, nrow = 5, ncol = 5), smoothingMatrix = 1:9) : 
#		smoothingMatrix must be a matrix

localSmoother(myMatrix = diag(x=2,nrow=5,ncol=5),smoothingMatrix=matrix(2,nrow=5,ncol=3))
#Error in localSmoother(myMatrix = diag(x = 2, nrow = 5, ncol = 5), smoothingMatrix = matrix(2,  : 
#						smoothingMatrix must by 3x3

localSmoother(myMatrix = diag(x=2,nrow=5,ncol=5),smoothingMatrix=matrix("a",nrow=3,ncol=3))
#Error in localSmoother(myMatrix = diag(x = 2, nrow = 5, ncol = 5), smoothingMatrix = matrix("a",  : 
#						smoothingMatrix must be numeric or integer



# Total: 10 points
# +1 Extra credit: if they add a new argument "na.rm=FALSE" and if na.rm==TRUE,
#	instead of returning NA for locations where the local window runs off the edge of myMatrix,
#	it uses all the values it can (e.g. the values that are NOT off the edge) to calculate
#	the mean.  Test:
localSmoother(myMatrix = diag(x=5,nrow=7,ncol=7),smoothingMatrix=matrix(1:9,nrow=3,ncol=3),na.rm=TRUE)
#[,1]     [,2]     [,3]     [,4]     [,5]      [,6]     [,7]
#[1,] 17.500000 6.666667 2.500000 0.000000 0.000000  0.000000 0.000000
#[2,] 10.000000 8.333333 4.444444 1.666667 0.000000  0.000000 0.000000
#[3,]  5.833333 6.666667 8.333333 4.444444 1.666667  0.000000 0.000000
#[4,]  0.000000 3.888889 6.666667 8.333333 4.444444  1.666667 0.000000
#[5,]  0.000000 0.000000 3.888889 6.666667 8.333333  4.444444 2.500000
#[6,]  0.000000 0.000000 0.000000 3.888889 6.666667  8.333333 6.666667
#[7,]  0.000000 0.000000 0.000000 0.000000 5.833333 10.000000 7.500000

