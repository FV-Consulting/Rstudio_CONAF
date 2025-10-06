#### GEOG 489: Programming for GIS
#### Jonathan Greenberg, jgrn@illinois.edu
#### Assignment 2
#### 10 September 2015
#### Due Wednesday, September 16 2015 at midnight.

# Your goal is to write a local-window smoothing function for use on matrices.
# The inputs are as follows:
#	myMatrix: an arbitarily large numeric matrix that is at least 3x3
# 	smoothingMatrix: an arbitrary 3 x 3 numeric matrix 
#
# The output should be a matrix of the same size as myMatrix:
#	For each location in myMatrix, the value should be equal to the average value of the 
# 	3x3 window around that location multiplied element-wise by the smoothingMatrix.
# So, for example:
myMatrix <- matrix(1:25,nrow=5)
myMatrix
smoothingMatrix <- matrix(0.5,nrow=3,ncol=3)
smoothingMatrix
# The value of the output matrix at position 2,3 will be 
# based on the local window around that point:
localWindow23 <- myMatrix[1:3,2:4]
localWindow23
# Multiplying this local window by the example smoothing matrix and 
# 	determining the mean value results in a single value of 6.
#
# Notice that a local window positioned around myMatrix[1,2] would run
#	off the edge of the matrix.  Pay attention to requirement #5
#	for instructions on what to do at these edge locations.

# The requirements are as follows:
#	1) The function name should be "localSmoother".
#	2) smoothingMatrix, by default, should be a 3x3 matrix of all 1s.
#	3) The class of myMatrix should be checked to make sure it is a matrix of mode numeric.
#		If it fails these checks it should stop with a warning.
#	4) The dimensions of smoothingMatrix should be checked to make sure it is a numeric 3x3 matrix.
#		If it fails these checks it should stop with a warning.
#	5) If a local window would run off the matrix (e.g. is an edge cell), the output value at
#		that location should be NA.
#	6) Comment your code in at least 3 places.
#	7) You may NOT use any R packages except the default set.
#	8) The code should be submitted tom Compass 2g as a single function with the filename:
#		[your UID without the @illinois.edu]-geog489-f15-assignment-02.R
#	and should have at the top:
#	[Your name]
#	Assignment #2
#
# 1 point of extra credit if you add a third parameter to the function 
# 	"na.rm" which should default to FALSE that, if TRUE, functions as follows:
# Instead of returning NA for locations where the local window runs off the edge of myMatrix,
#	it uses all the values it can (e.g. the values that are NOT off the edge) to calculate
#	the mean.

# Small hint:
#   If we have nested for() loops, we get the following behavior:

for(y in 1:3)
{
	for(x in 1:3)
	{
		print(paste("y,x=",y,",",x,sep=""))		
	}
}


# Tests:
localSmoother(myMatrix = diag(x=2,nrow=5,ncol=5),smoothingMatrix=matrix(1:9,nrow=3,ncol=3))
#[,1]     [,2]     [,3]      [,4] [,5]
#[1,]   NA       NA       NA        NA   NA
#[2,]   NA 3.333333 1.777778 0.6666667   NA
#[3,]   NA 2.666667 3.333333 1.7777778   NA
#[4,]   NA 1.555556 2.666667 3.3333333   NA
#[5,]   NA       NA       NA        NA   NA

localSmoother(myMatrix = diag(x=2,nrow=5,ncol=5))
#[,1]      [,2]      [,3]      [,4] [,5]
#[1,]   NA        NA        NA        NA   NA
#[2,]   NA 0.6666667 0.4444444 0.2222222   NA
#[3,]   NA 0.4444444 0.6666667 0.4444444   NA
#[4,]   NA 0.2222222 0.4444444 0.6666667   NA
#[5,]   NA        NA        NA        NA   NA

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


# Extra Credit test:
localSmoother(myMatrix = diag(x=2,nrow=5,ncol=5),smoothingMatrix=matrix(1:9,nrow=3,ncol=3),na.rm=TRUE)
#[,1]     [,2]     [,3]      [,4]     [,5]
#[1,] 7.000000 2.666667 1.000000 0.0000000 0.000000
#[2,] 4.000000 3.333333 1.777778 0.6666667 0.000000
#[3,] 2.333333 2.666667 3.333333 1.7777778 1.000000
#[4,] 0.000000 1.555556 2.666667 3.3333333 2.666667
#[5,] 0.000000 0.000000 2.333333 4.0000000 3.000000
