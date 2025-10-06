#### GEOG 489: Programming for GIS
#### Chunyuan Diao, chunyuan@illinois.edu
#### Lecture 2: Vectors
#### 1/28/2020

######## VECTORS, MATLOFF CHAPTER 2 ########

### Adding or deleting vector elements
# c() is the standard command for creating (concatenating) elements into a vector.
x <- c(88,5,12,13)
x
# Let's insert a 168 after the 12 and before the 13 into the vector:
x <- c(x[1:3],168,x[4])
x


### Obtaining the length of a vector
# Use the length() function:
x <- c(1,2,4)
length(x)
# [1] 3
# Length is important in looping.  This is not the most efficient way to do this, 
# but does illustrate how lengths can be used:
for (i in 1:length(x))
{
	# Print the current element of x
	print(x[i])
}
# Take a look at the vector produced that i loops through:
1:length(x) # We'll look at the ":" command in a bit.
# What happens if we have an empty vector?
x <- c()
length(x)
# This can cause problems in looping:
1:length(x)

### Matrices and arrays ARE vectors
# Say we have a matrix:
m <- matrix(data=c(1,3,2,4),nrow=2,ncol=2)
m
# And we define a 4-element vector:
n <- 10:13
n
# If we add them together, R knows that the matrix is really a vector of c(1,3,2,4)
# with 2 rows and 2 columns, so it can correctly perform the addition and retain
# the output as a matrix.
m+n

# Go ahead and quit out now:
q() # Answer "no"


### Declarations
# In general, we don't need to declare variables ahead of time.  However...
# If we want to use a index to assign vector values, we need to first DECLARE an "empty" vector.
# If not, we get an error.  For instance, try:
z[1] <- 5
z[2] <- 12
# z has not been declared, so that statement is meaningless.  We can declare an empty vector first by:
z <- vector(length=2)
z # Empty vector, defaults to logical FALSEs
z[1] <- 5
z[2] <- 12
z # Now contains the info we wanted.
# Note that re-defining a variable with a different data structure or mode is totally ok:
x <- c(1,5)
mode(x)
x <- "abc"
mode(x)
# We redefined x from a numeric to a character.
# As a sidebar, we can test the mode using a logical statement and the mode name:
mode(x)=="character"
mode(x)=="numeric"
# This could be used in an if-else statement.

### Recycling
# If you perform an operation on two vectors that require them to be the same length 
# 	(e.g. adding two vectors together), the shorter one is "recycled":
c(1,2,4)+c(6,0,9,20,22)
# is the same as (note the recycling of the first vector):
c(1,2,4,1,2)+c(6,0,9,20,22)
# Note the warning.  As a general rule, if you "recycle" a vector, you are probably doing something wrong.
#	The exception to this general rule are "scalars" (single element vectors).

# Matrices, which are vectors, have similar characteristics:
x=matrix(data=c(1,2,3,4,5,6),nrow=3,ncol=2)
x+c(1,2,1,2)
# is the same as
x+matrix(data=c(1,2,1,2,1,2),nrow=3,ncol=2)

### Common vector operations
?"+"
2+3
# + is actually a function!  You can accomplish the same task in "function" form by:
"+"(2,3)
# Vector addition is performed element-wise:
x <- c(1,2,4)
x + c(5,0,-1)
# Multiplication is also done element-wise:
x*c(5,0,-1)
# Other basic operators:
# also are performed element-wise:
x/c(5,4,-1)
x %% c(5,4,-1) # Remember that %% is modulo, e.g. it returns the remainder of the division.

### Vector indexing
# We can extract subvectors of a source vector (vector1) 
# by using an "index vector" (vector2) using this format: vector1[vector2]
y <- c(1.2,3.9,0.4,0.12)
y[c(1,3)] # Returns element 1 and 3 of y.
y[2:4] # Returns elements 2 through 4 of y.
# Duplicates are allowed!  
x <- c(4,2,17,5)
y <-x[c(1,1,3)]
y
# Negative subscripts are used to *exclude* elements:
z <- c(5,12,13)
z[-1] # exclude element 1
z[-1:-2] # Exclude elements 1 through 2
# Using length statements can sometimes help with indexing, and generalize the function.
# In this example, we want all but the last element in the vector.  
# Note that no matter how long z is, this function will always return all be the last element.
z <- c(5,12,13,2,3,4,5)
z[1:(length(z)-1)] # Includes elements 1 through the second-to-last element
# or
z[-length(z)]

### Generating vector sequences with ":" 
# ":" is an important operator, because it produces a vector of numbers in a regular sequence.
5:8 # produces a vector ranging from 5 to 8, incremented by 1.
5:1 # prodcues a vector ranging from 5 to 1, decremented by 1.
# These are very common in for loops.  Try:
x
1:length(x)
for(i in 1:length(x)) { print(x[i]) }
# Order of operations is important with the : operator.  : takes prescedence over arithmetic.
i <- 3
1:i-1 # Means create a vector of 1 to 3, and then subtract 1 from the vector, e.g. (1:i)-1 
1:(i-1) # evaluates i-1 first, and then generates a sequence from 1 to 2

### Generating vector sequences with seq()
# A more general form of : is the seq() function.
?seq
seq(from=1,to=5,by=1) 
# is the same as
1:5
# But we have more custom control:
seq(from=12,to=30,by=3)
# the "to" number sets the maximum possible number of the sequence.  Try:
seq(from=12,to=32,by=3)
# We can also make non-integer sequences, and 
seq(from=1.1,to=2,length=10)
# Note that "by" is determined by: ((to - from)/(length - 1)), we could also do:
seq(from=1.1,to=2,by=0.1)

seq(from=1.1,to=2,by=0.1)

# We can use seq() in for loops to help with the empty vector problem.  Recall:
x <- c() # An empty vector
1:length(x)
for(i in 1:length(x)) { print(x[i]) } 
# You'd think this should not loop at all, since x is empty.  But instead it looped twice.  
# Using seq() fixes this:
seq(x)
for(i in seq(x)) { print(x[i]) } # This should not output anything!  On the other hand:
x <- c(5,12,13)
seq(x) # Notice that the sequence from a vector input generates the full index
for(i in seq(x)) { print(x[i]) }
# So, in general, using seq(x) is safer than 1:length(x) for indexing

### which()
# If we want the positions of the elements that 
# satisfy the logical argument, we use which()
?which
z <- c(5,2,-3,8)
which(z*z > 8) # This is the numerical index of z that satisfy the logical statement.
# This is the longer version of above:
z_index <- seq(z)
z_index
z_index[z*z > 8]

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

### Using any() and all()
x <- 1:10
x
# any() returns TRUE if, for a logical argument, ANY of the vectors returns TRUE:
?any
any(x > 8) # TRUE, because vector elements 9 and 10 are greater than 8.
any(x > 88) # FALSE, because none of the vector elements are greater than 88.
# all() returns TRUE if, for a logical argument, ALL of the vectors returns TRUE:
?all
all(x > 8) # FALSE, because not all of the vector elements are greater than 8.
all(x > 0) # TRUE, because all of the vector elements are greater than 0.

### Vectorized operations
# Certain functions contain significant speedups through the use of vectorization,
# where the function is actually applied one element at a time WITHOUT the use of 
# a for-loop.  Take:
u <- c(5,2,8)
v <- c(1,3,9)
u > v
w <- u > v
# This is a LOT faster than:
w <- vector(length=length(u))
for(i in seq(w)) { w[i]=u[i] > v[i] }
w # Same output, just much slower.
# We can generate vectorized functions if all of the base functions are vectorized:
w <- function(x) { return(x+1) }
w(u)
# Rule of thumb: whenever you can avoid for loops, DO SO.
# Beware of recycling rules, and always check your output.
# Say we want to add a "scalar" to a vector, and square the output.
# There are no such things as scalars in R, there are just single-element vectors.
# In the following case, c is recycled if it is of length 1:
f <- function(x,c) { return((x+c)^2) }
f(x=1:3,c=0) # is the same as:
f(x=1:3,c=rep(0,3))
f(1:3,1)
# We have no check to make sure c is a single element vector, so we can get unexpected behavior
# if we use other types of inputs, e.g.:
f(x=1:3,c=1:4)
# Let's modify our function to limit c to only being a "scalar" (single element vector).  
# We'll use stop() to return an error message of our choosing if the length is not 1.
?stop
f<-function(x,c)
{
  if(length(c) != 1) stop ("vector c not allowed!!!")
  return(((x+c)^2))
}
f(x=1:3,c=1:4)
f(x=1:3,c=3)


### NA and NULL values
# NA and NULL have subtle, but important differences in their meaning.
# NA means "missing data"
# NULL means "value doesn't exist"
x <- c(88,NA,12,168,13)
x
?mean
mean(x) # If x contains NAs, the output of mean() is also NA.  
# We can modify this behavior using na.rm=T
mean(x,na.rm=TRUE) # T and TRUE are the same thing.  F is the shortcut for FALSE.
x <- c(88,NULL,12,168,13) # NULL, on the other hand, is just ignored by mean.
mean(x)
# There are NA values for each mode:
x <- c(5,NA,12)
mode(x) # The vector is numeric
mode(x[1])
mode(x[2]) # numeric NA
x <- c("abc","def",NA)
mode(x) # The vector is character
mode(x[1])
mode(x[3]) # character NA

# One use of NULLs is the build up vectors from scratch, by creating a "blank" vector:
# Builds up a vector of even numbers in 1:10
z <- NULL
for (i in 1:10) 
{ 
  if(i %% 2 ==0) 
  {
    # Merge the "old" z with the current i
    z <- c(z,i)
  }
  print(z)
}
z


# What happens if we set z to NA?
z <- NA
# INTERFACE HINT: since you've already typed the following out, 
# try hitting the up arrow on your keyboard a few times to repeat old command:
for (i in 1:10) 
{ 
  if(i %% 2 ==0) 
  {
    # Merge the "old" z with the current i
    z <- c(z,i)
  }
}
z

# NULL is non-existant, NA is missing.  Check the lengths:
u <- NULL
length(u)
v <- NA
length(v)

### Filtering
# We can subset vectors in one of two ways:
#   Using a vector of numeric (integer) elements, e.g.:
z <- c(6,7,4,2)
numeric_vector <- c(1,2)
z[numeric_vector]
# is the same as:
z[c(1,2)]
# is the same as:
z[1:2]

# We can also use logical vectors
# such that the elements are returned
# if the element is true:
logical_vector <- c(TRUE,TRUE,FALSE,FALSE)
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
x[x > 3] # Returns the filtered x...  but what if we want to convert all those values to 0?
x[x > 3] <- 0
x # All values of x greater than 3 are now equal to 0!



### ifelse()
# if() statements are non-vectorized, so can be slow. 
# ifelse() provides a vectorized version of if()
?ifelse
x <- 1:10
x
x %% 2 == 0
y <- ifelse(x %% 2 == 0,yes="even",no="odd")
y


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

### Miscellaneous c() facts.
# When merging multiple modes, the "lowest common denominator" mode will be used.
# Part of the order (from lowest to highest) is as follows: 
# list, character, numeric:
x <- c(5,2,"abc")
x # Note that the numbers were converted to characters
mode(x)

x <- c(5,"abc",(list(a=1,b=4)))
x # Everything was converted to a list
mode(x)

# c() flattens all of the inputs, so nested c() will make one long vector:
c(5,2,c(1.5,6))

# Quit out to clear out R.
q()
