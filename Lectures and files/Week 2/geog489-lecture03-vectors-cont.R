#### GEOG 489: Programming for GIS
#### Chunyuan Diao, chunyuan@illinois.edu
#### Lecture 3: Vectors Continued and Matrices


### Repeating vectors with rep()
?rep
x <- rep(x=8,times=4) # Repeats "8" 4 times
x
x <- rep(8,4) # Is a shortcut for this...
x
# We can repeat larger vectors as well:
rep(c(5,12,13),3)
rep(1:3,2)
# We can interleave the outputs using "each" instead of "times".  
# This repeats the first element of the vector "each" number of times, 
# then the second element, and so on...
rep(c(5,12,13),each=2) # vs.
rep(c(5,12,13),times=2)


### Filtering
# We can subset vectors in one of two ways:
#   Using a vector of numeric (integer) elements, e.g.:
z <- c(6,7,4,2)
numeric_vector <- c(1,2)
z
numeric_vector
z[numeric_vector]
# is the same as:
z[c(1,2)]
# is the same as:
z[1:2]

# We can also use logical vectors
# such that the elements are returned
# if the element is true:
logical_vector <- c(TRUE,TRUE,FALSE,FALSE)
z
logical_vector
z[logical_vector]
# Note that a logical vector must be the same
# lengths as the vector it is indexing:
length(logical_vector)==length(z)

# We can use logical statements to filter out unwanted elements.
# A filtering index is a logical index the same length as a vector to be indexed.
z <- c(5,2,-3,8)
w <- z[z*z > 8]
w
# We will break this down:
z
z*z
z*z > 8 # Note that the second element is FALSE, this is the filtering index.
z[z*z > 8]

# Here's a more complex example, where we use a filter generated from
# one vector and apply it to a different vector of the same length:
z <- c(5,2,-3,8)
j <- z*z > 8
j
y <- c(1,2,30,5)
y[j] # Which is the same thing as...
y[z*z > 8] 

# A really powerful feature of this is selective assignment:
x <- c(1,3,8,2,20)
x > 3 # Is x greater than 3?
x[x > 3] # Returns the filtered x...  but what if we want to convert all those values to 0?
x[x > 3] <- 0
x # All values of x greater than 3 are now equal to 0!


### which()
# If we want the positions of the elements that satisfy the logical argument, we use which()
?which
z <- c(5,2,-3,8)
which(z > 2) # This is the numerical index of z that satisfy the logical statement.
# This is the longer version of above:
z_index <- seq(z)
z_index
z_index[z > 2]

### ifelse()
# if() statements are non-vectorized, so can be slow. 
# ifelse() provides a vectorized version of if()

?ifelse
x <- 1:10
x
x %% 2 == 0
y <- ifelse(x %% 2 == 0,yes="even",no="odd")
y

### Testing vector equality
# How can we test if these two vectors are identical?
x <- 1:3
y <- c(1,3,4)
# We can just use ==, right?
?"=="
x == y
# Wrong.  == is a vectorized function, so works element-wise.
# We can use this statement combined with all() to solve the problem, however:
all(x==y)
# Or we can use the identical() function:
?identical
identical(x,y)
# Identical needs to be treated with care, because it checks more than just the values:
x <- 1:2
y <- c(1,2)
x
y
identical(x,y) 
# What's going on here?  Let's check the number types using typeof()
?typeof
typeof(x)
typeof(y)
# Ah ha!  : produces integers and c() produces floating point numbers.

### Vector names:
# We can assign each element a name using names(), perhaps to use in plotting.
?names
x <- c(1,2,4)
names(x) <- c("a","b","c")
names(x)
x
# To remove names:
names(x) <- NULL
x
# And we can reference using the names as indexes
names(x) <- c("a","b","c")
x["b"] # Be careful if you have duplicate names, this won't work right if you do.
# We don't use names for vectors all that often, but
# we will use names quite a bit with other data structures.


######## R PROGRAMMING STRUCTURES, MATLOFF CHAPTER 7 ########

# Loops
# for() is the most common type of looping.
# Before we learn for(), we'll first learn while() 
# which is a bit more intuitive to beginning programmers.
# while() keeps repeating until some logical statement true,
# which will involve having some "flag" or "trigger event" that
# changes as it loops, otherwise the loop can go on forever.
# Notice we have to "initialize" i:
?"while"
i <- 1
while (i <= 10) # Will keep looping as long as this is TRUE
{
  print(i)
  i <- i+4
} # This will only stop when i > 10

i <- 1
while(TRUE) # Without the break statement, this will be an infinite loop.
{
  print(i)
  i <- i+4
  if(i > 10)
  {
    break
  }
}

# for(n in x) {} translates to:
#  "iterate through each element of x, assigning the variable n to each element
#  in sequence.

x <- c(5,12,13)
for(n in x) { print(n) }

# Here is the while() verison of above:
x <- c(5,12,13)
n <- 1
while(n <= length(x))
{
  # Print the nth element of x
  print(x[n])
  # Increment n by 1.
  n <- n+1 
}

# repeat just keeps repeating until a break statement is reached:
i <- 1
# while(TRUE)

repeat
{
  print(i)
  i <- i+4
  if(i > 10) 
  {
    break
  }
}

# A nice shortcut with for loops is using the next statement, which
# skips all subsequent commands within a loop and proceeds to the next
# iteration.

# This for loop will print a command every time it sees an odd number,
# but skips to the next iteration when it sees an even number. 

for(i in 1:10)
{
  if(i %% 2 == 0) next
  # Notice that "Odd!" is never printed when i is even, 
  # because next skips past it.
  print(i)
}

######## MATRICES AND ARRAYS, MATLOFF CHAPTER 3 ########
# Matrices, remember, are vectors that have additional attributes, namely
# the number of rows and columns in the matrix, as well as whether it is
# column-major (default for R) or row-major (common for geographic data)
# R also supports multidimensional arrays, e.g. a 3-d array (rows, columns, layers)

### Creating matrices
# Matrices are created in "column-major order", so all of column 1 is stored first, 
# then column 2, etc.  Note that raster images tend to be row-major ordered, so
# row 1 is stored first, then row 2, etc...  

?matrix
# Shortcuts with variable names:
# Notice from the help that the first parameter you can pass to matrix()
# is data=.  If you don't specify variable names in function calls, R
# will assume you are calling the variables in order:
y <- matrix(c(1,2,3,4),ncol=2,2) 
y <- matrix(data=c(1,2,3,4),ncol=2,nrow=2) 

# R knows the first parameter of the function matrix() is "data", so it assumes the
# vector in the first position should be assigned to data= without needing to explictly
# define it.

# HINT: UNTIL YOU ARE COMFORTABLE WITH HOW THIS WORKS, DON'T USE SHORTCUTS.  
#   EXPLICITLY DEFINE YOUR PARAMETER NAMES IN THE FUNCTIONAL CALLS.

y # Notice that 1:4 filled in column by column.
# R will figure out the number of columns you need if you only specify nrow:
y <- matrix(data=c(1,2,3,4),nrow=2) # It figures out the ncol by length(data)/nrow
y[ ,2] # shows us everything in column 2 (notice it prints out in vector format)

# We can fill in a matrix element-by-element by first defining an empty matrix:
y <- matrix(nrow=2,ncol=2)
y # As with empty vectors, an empty matrix defaults to mode(y) == logical, 
# but will switch to the mode of the first element we assign.
y[1,1] <- 1
y[2,1] <- 2
y[1,2] <- 3
y[2,2] <- 4
y

# Notice that we CAN fill in a matrix row-by-row (like an image) by using the byrow=TRUE parameter:
m <- matrix(1:6,nrow=2,byrow=TRUE)
m

### General Matrix Operations
# Basic (and advanced) linear algebra operations are available in R and are
# optimized for speed (and may even use parallel execution depending on how you
# configured/installed R).
y <- matrix(c(1,2,3,4),nrow=2,ncol=2) 
# Left scalar multiplication:
y
3 * y
# Matrix multiplication (refer to your linear algebra textbooks for the description):
?"%*%"
y %*% y
# Element-wise multiplication:
y*y
# Element-wise addition:
y+y

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
