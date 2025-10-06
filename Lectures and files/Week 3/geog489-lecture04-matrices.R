#### GEOG 489: Programming for GIS
#### Chunyuan Diao, chunyuan@illinois.edu
#### Lecture 4: Matrices (Continued)


# Some pre-class announcements:
# -- Assignment 1 will be due next Tuesday, 11 February 2020 at midnight.
# -- READ THE ASSIGNMENT CAREFULLY, AND USE THE TEST CASES TO CHECK YOUR RESULTS.
# -- PUT LOTS OF PRINT STATEMENTS IN YOUR FUNCTION TO CHECK YOUR CODE
#     (but comment them out or remove them before submitting)
# -- Please read chapters 3 (Matrices and Arrays).

# Testing a function, the hack way

# When you are writing a function, sometimes the
# function itself can be a headache, and you just
# want to test the code line by line. 

# We will learn more advanced debugging later,
# but for now we'll do some hack debugging:

oddcount <- function(x) {
	k <- 0 # assign 0 to k
	for (n in x) {
		if(n %% 2 == 0)
		{
			k <- k+1 # %% is the modulo operator
		}
	}
	return(k)
}

# Rather than try to test the whole function, we 
# we will "manually" assign the parameter
# and test the internals of the code:

x <- seq(1:3) # This is the parameter
# Now paste in the internals of the function
# EXCEPT the return statement, and include
# some print statements:

k <- 0 # assign 0 to k
for (n in x) {
	if(n %% 2 == 0)
	{
		print(paste(n,"is even"))
		k <- k+1 # %% is the modulo operator
	}
}

# Run this line-by-line, then test k:
k

######## MATRICES AND ARRAYS, MATLOFF CHAPTER 3 CONT ########

### Matrix indexing
y<-matrix(1:12*3,nrow=4,ncol=3)
# Matrix indexing functions much the same as vectors, 
# except we now have two dimensions (separated by a comma) to deal with:
y
y[ ,2:3] # Means return all rows for columns 2 through 3
y[2:3, ] # Means return all columns for rows 2 through 3
y[2:3,2] # Means return column 2 for rows 2 through 3
# Negative subscripts mean "exclude" just like in vectors:
y[-2,] # Return all columns of all rows EXCEPT row 2

# We can perform assignments using row indices as well:
y<-matrix(1:6,nrow=3,ncol=2)
y
y[c(1,3), ] # Return all columns of rows 1 and 3. 
matrix(c(1,1,8,12),nrow=2)
y[c(1,3),] <- matrix(c(1,1,8,12),nrow=2)

### Installing packages
# Before we press on, it's time to install our first "add-on" package for R.
# Packages are found from a few major repositories, the largest is CRAN:
# http://cran.r-project.org/

# Packages are installed in a specific directory (or directories), but are generally
# not loaded at startup to save memory space and deal with potential cross-package
# problems that pop up from time to time.  To see what is currently LOADED:
?path.package
path.package() # These are the default packages that are loaded by R.

# If you have already installed a package (e.g. "MASS"), you simply use the library() function:
?library
library("MASS") # Note that the quotes, in this case, are not actually required.

# If you want to install a package that you don't currently have, you will use:
?install.packages
install.packages("raster") # In this case, quotes are required.
# You can get an overview of the package info as well as available functions by:
library(help="raster")
# You can also see the main help page for the package by:
help(package="raster")
# If the package is NOT loaded yet, the shortcut for help require an additional parameter:
?brick # A function that is in the raster package.  Notice this doesn't work.  Try:
help("brick",package=raster)
# If we load the library (do this now, we are going to use it):
library("raster")
# we no longer need to specify package=raster:
?brick # Should now work.  Verify the package is loaded:
path.package() 

### Matrices and raster files
# Your first GIS function!
# Matrix notation allows us to interact with raster files.  
# First, let's load up the raster package:
library("raster")
# Next, we are going to use one of the built-in datasets
filename <- system.file("external/test.grd", package="raster")
filename # Returns the path to a sample raster image.
# We can create a raster object (a raster with 1-layer) by:
r <- raster(filename)
# Note, we'll learn a lot more about the raster package later in the class...
r # Note it gives you info about the raster object. 
class(r)
# Let's look at the raster:
plot(r)
# Rasters are basically matrices, and use some of the same basic notation.  
# So, for instance, we can re-assign certain values:
r[75:100,1:10] <- 1500 
plot(r)
# We can "reload" the raster from disk and modify it a different way:
r <- raster(filename)
r[75:100,1:10] <- r[75:100,1:10]*10 # Multiply the values in this subset by 10.
plot(r)
# A quick note:
# A raster object is not identical to a matrix, so some matrix command won't work
# the same on a raster as they will on an R matrix.  We'll learn more about rasters
# later.

### Filtering on matrices
x <- matrix(c(1,2,3,2,3,4),nrow=3,ncol=2)
x[x[,2] >= 3,] # Only returns rows where the second column entry is >= 3
# Breaking this down:
x
x[ ,2]
x[,2] >= 3
j <- x[,2] >= 3
x[j,] # This is a vectorized operation (fast)

# Here's a more complex operation that introduces us to a logical AND statement
?"&"
# There are different logical statements such as:
# AND "&" which is TRUE only if both statements are TRUE
TRUE & FALSE
TRUE & TRUE
FALSE & FALSE
# & is a vectorized (element-by-element) operator:
c(TRUE,TRUE,FALSE) & c(TRUE,FALSE,FALSE)

m <- matrix(1:6,nrow=3)
m
m[m[,1] > 1 & m[,2] > 5,]
# Take a second to break down the different components of this 
# to understand what is going on.
m[,1] > 1
m[,2] > 5
m[,1] > 1 & m[,2] > 5
m
m[m[,1] > 1 & m[,2] > 5,]

### The apply() function
?apply
# Apply is a very powerful tool for use with matrices.
# It allows an easy  way to apply a function
# on a row-by-row, or column-by-column basis.
# The general form is as follows:
# apply(X,MARGIN,FUN,...)
# Where:
# X is a matrix or array
# MARGIN is the dimension to use (1 = row by row, 2 = column by column)
# FUN is a function to be applied
# ... are addition arguments that will be passed to the function.

# So say we want to calculate the mean for each column in a matrix:
z <- matrix(1:6,nrow=3) 
z
apply(X=z,MARGIN=2,FUN=mean)

# This is the same as:
zmean <- vector(length=ncol(z))
for(i in seq(ncol(z)))
{
	zmean[i] <- mean(z[,i])
}
zmean
	
# We can define our own function:
f <- function(x) { x/c(2,8) }
y <- apply(X=z,MARGIN=1,FUN=f)
y

# Note, when testing functions to use with apply, 
# it can help to first extract the dimension you plan to use
# and run that subset through the function directly, e.g.:
test_z <- z[1,] # Pull the first row out to test, since we are using MARGIN = 1
f(test_z) # It works!  Now we can use this in apply...

# Notice z and y are transposed:
z # 3 rows and 2 columns
y # 2 rows and 3 columns
# apply() coerces the output such that the column length == 
# the length of a single function output.  
# The exception to this is if a function returns a "scalar", the output of apply() will be a vector.
# We can always transpose the output using t()
?t
y_transposed <- t(y)
y_transposed

# We can send additional parameters to a function if the function is written properly:
z <- matrix(1:6,nrow=3)
f <- function(x,y) { x/c(y,8) }
y <- apply(X=z,MARGIN=1,FUN=f,y=2) # Notice we have assigned y to be 2


### Adding and deleting matrix rows and columns
# Changing the size of a matrix
# Using rbind() (row bind) and cbind (column bind)
?rbind
?cbind

# Say we want to add a vector of 1s to a 4 x 4 matrix:
ones = rep(1,4)
ones
z <- matrix(seq(10,160,by=10),nrow=4,ncol=4)
z
# We can add the row of ones to the bottom:
rbind(z,ones) 
# Or to the top:
rbind(ones,z)
# Or along the left column:
cbind(ones,z)
# Or the right column:
cbind(z,ones)

# We can reassign ("overwrite") z to have the new column at the right by:
z <- cbind(z,ones)
z


# We can delete rows and columns by just using our subscripts:
z[,1:4] # Clip off the 5th column
# We can reassign it by:
z <- z[,1:4]
z

### More on the Vector/Matrix Distinction
z <- matrix(1:8,nrow=4)
z
# Because matrices are special forms of vectors, 
# many of the vector functions will work on matrices:
length(z)
# But an object of class == "matrix" has more attributes than a vector:
?class
?attributes
class(z)
attributes(z)
# A helpful function for matrices and arrays 
# is determining the length of each dimension:
?dim
dim(z) 
# Notice that the output is a vector, 
# so to return the length of the first dimension, we can:
dim(z)[1]
# and the length of the second dimension:
dim(z)[2]
# A helpful shortcut function for determining the number of rows and columns:
?nrow
?ncol
nrow(z)
ncol(z)

### Avoiding unintended dimension reduction
# Say we have a 4 x 2 matrix:
z <- matrix(1:8,nrow=4)
z
class(z)
# We pull a subset out of the matrix:
r <- z[2, ]
r
class(r) # We now have an integer vector, not a matrix.
attributes(z)
attributes(r)
# So R did some cleaning up for us, 
# it reduced a 1 x 2 matrix to a 2 element vector.  
# This may be fine sometimes, but sometimes we do NOT want R
# to reduce the dimensions, because our code was designed to
# work with the subset as a matrix. 
# We can use the "drop" logical parameter to modify this behavior:
?"["
r <- z[2, ,drop=FALSE] # Note we have to add another comma to keep the columns.
class(r)
attributes(r) # r is now a 1 x 2 matrix, and has not be reduced.

# If we start with a vector, but we want to convert it to a matrix, 
# we can use the as.matrix() function:
?as.matrix
u <- 1:3 # A vector
v <- as.matrix(u) # Now a matrix
attributes(u)
attributes(v)

### Naming matrix rows and columns
z <- matrix(1:4,nrow=2)
# We can name the rows and columns of a matrix using rownames() and colnames()
?rownames
?colnames
colnames(z) # A matrix starts out with no names
colnames(z) <- c("a","b")
z
rownames(z) <- c("row I","row II")
z

### Higher dimensional arrays
# We can create arrays of arbitrary dimensions in R.
# In raster processing, we think of a multi-layered raster as an array.
# e.g., we have three dimensions representing the x location, y location, and layer.

# Say we have two layers as matrices:
layer1 <- matrix(1:6,nrow=3)
layer2 <- matrix(101:106,nrow=3)

# We can merge these into a 3-d array by using the array() function:
?array
merged_array <- array(data=c(layer1,layer2),dim=c(3,2,2))
# The dim= parameter is a vector representing the length of each dimension.
# In this context, we are making a 3-d array with row, column, and layer lengths of
# 3, 2, and 2 respectively.
# Take a look at the array:
merged_array # Notice it prints out one "layer" at a time.
attributes(merged_array)
# Our matrix subsetting notation scales to any number of dimensions.
# So, to pull out first layer of the bottom right corner of the array:
merged_array[3,2,1]
# We can look at all layers of the bottom left corner:
merged_array[3,1, ]
# Or the entire second layer :
merged_array[ , ,2]


