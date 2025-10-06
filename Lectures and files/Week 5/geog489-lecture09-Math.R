#### GEOG 489: Programming for GIS
#### Chunyuan Diao, chunyuan@illinois.edu
#### Lecture 9: Doing Math and Simulations in R,


######## DOING MATH AND SIMULATIONS IN R, MATLOFF CHAPTER 8 ########

### Math Functions
# R has any basic math function can you think of:
?exp() 			# Exponential function, base e
?log() 			# Natural logarithm
?log10() 		# Logarithm base 10
?sqrt() 		# Square root
?abs() 			# Absolute value
?sin()			# Trig functions, also includes cos, tan, asin, atan, and atan2
?min()			# Minimum and maximum value of a vector
?max()
?which.min()	# Index of the min or max value of a vector
?which.max()
?pmin()			# Element-wise min or max of several vectors
?pmax()
?sum()			# Sum of the elements of a vector
?prod()			# Product of the elements of a vector
?cumsum()		# Cumulative sum of the elements of a vector
?cumprod()		# Cumulative product of the elements of a vector
?round()		# Round to the closest integer
?floor()		# Round to the closest integer lower
?ceiling()		# Round to the closest integer higher
?factorial()	# Factorial function

### Cumulative sums and products:
?cumsum()
?cumprod()
x <- c(12,5,13)
cumsum(x)
cumprod(x)

### Minima and maxima
?min 
# min() simply combines all of its arguments into a vector and returns
# the minimum value:
x <- c(1,5,6)
y <- c(2,3,2)
min(x,y)
# This is the same thing as:
min(c(x,y))
# pmin, on the other hand, compares these element-wise:
?pmin
x
y
pmin(x,y)
# Note: this function comes in handy when comparing two rasters
# together, and trying to return the lowest or highest value at
# a location.

# What if we wanted to figure out the minimum of a function?
mytrig <- function(x)
{
	return(x^2-sin(x))
}

# Well, we could generate a whole sequence of x values:
x <- seq(-10,10,by=0.01)
# Two issues here: 1) we are making a wild guess that the minimum
# falls within the range of the from and to values, and 2) we are
# assuming that an x precision of 0.01 is adequate to characterize the
# minimum property:
plot(x,mytrig(x))
min(mytrig(x))

# Or we could use the nlm() function:
?nlm # Non-linear minimization of a function using a Newton-type algorithm:
nlm(mytrig,8) 
# The second parameter is an initialization parameter (where to start looking).

### Calculus
# R does have some calculus support, although the more advanced stuff is
# in various add-on packages, not built-in to R.
# For instance, we can compute the derivative of a function via D():
?D
D(expression(exp(x^2)),"x")
# Or integrate (note that this is using a specific form of computational
# integration, an adaptive quadrature algorithm, that may not be good for
# all problems):
?integrate
integrate(function(x) x^2,lower=0,upper=1) # You have to define the bounds
# One good package for solving differential equations is:
install.packages("odesolve")

### Functions for statistical distibutions
# Remember that R started out as an almost purely stats package,
# so its stats capabilites are very advanced.  For distibutions,
# R uses the following nomenclature:
# d: density/probability mass function (pmf)
# p: cumulative distribution function (cdf)
# q: quantiles
# r: random number generations.
# So, for a normal distribution:
?dnorm # Calculates the probability mass function of a normal distribution
?pnorm # Calculates the cumulative distribution function of a normal distribution
?qnorm # Calculates the quantile function of a normal distribution
?rnorm # Generates a set of random numbers drawn from a normal distribution.

# Let's look at a chi-square example:
?rchisq
mean(rchisq(1000,df=2))
# This pulls 1000 random values from a chi-square distribution with 
# degrees of freedom equal to 2 (note that each distribution will have 
# a unique set of parameters used to control it), and then calculates the
# mean value of these.

# What about the 95th percentile of the same distribution:
?qchisq
qchisq(p=0.95,df=2)
# Or the 50th and the 95th at the same time:
qchisq(p=c(0.5,0.95),df=2)

### Sorting
?sort
x <- c(13,5,12,5)
sort(x)
# If we just want the indices of the sort:
order(x)
# These can be used as indices, so say we have two equal
# length vectors:
V1 <- c("def","ab","zzzzz")
V2 <- c(2,5,1)
# We want to sort V1 based on the numerical order of V2:
V1[order(V2)]

# Notice that sort() and order() works with characters as well:
sort(V1)

# Similar to order, we can also generate the "ranks" of the components:
?rank
rank(x) # Notice that the ties were given decimal values

### Linear algebra operations on vectors and matrices
y <- c(1,3,4,10)
# Multiplying a vector or matrix by a "scalar" works as expected:
2*y

# To calculate the dot product (aka "inner product") of two vectors:
?crossprod
crossprod(1:3,c(5,12,13))

# Matrix multiplication uses %*%:
?"%*%"
a <- matrix(c(1,3,2,4),nrow=2)
b <- matrix(c(1,0,-1,1),nrow=2)
a %*% b
# We can solve a system of linear equations or get matrix inverses:
#  x1 + x2 = 2
# -x1 + x2 = 4
# In matrix form, this is:
#  	/  1	1	\  	/ x1 \  = 	/ 2 \
#	\ -1	1 	/	\ x2 /		\ 4 /
# We can use solve() in R:
?solve
a <- matrix(c(1,-1,1,1),nrow=2,ncol=2)
b <- c(2,4)
solve(a,b)
solve(a) # Returns the inverse of a, if b is not given.
# This function calls LAPACK, a linear algebra package that
# is used by many programs, not only R.
# LAPACK functions are often parallelizable.  Depending on your
# install of R, you may notice the execution of LAPACK 
# functions will use all of your available CPUs.



### Set Operations
x <- c(1,2,5)
y <- c(5,1,8,9)

# Union
?union
union(x,y) # Notice duplicated values are gone.

# Intersect
?intersect
intersect(x,y) # Only values shared between both sets.

# setdiff: return values in x that are not in y:
?setdiff
setdiff(x,y)
setdiff(y,x)

# setequal: test for equality between sets:
setequal(x,c(1,2,5))
setequal(x,y)

# %in%: tests whether c is an element of set y:
?"%in%"
2 %in% x
2 %in% y

# choose: number of possible subsets of size k from a set of size n.
?choose
choose(5,2)

# We can build up more complex set operations.  Say
# we want to determine all elements belonging to only
# one of the two sets:
symdiff <- function(a,b)
{
	sdfxy <- setdiff(x,y)
	sdfyx <- setdiff(y,x)
	return(union(sdfxy,sdfyx))
}
symdiff(x,y)

# We can figure out all combinations of a set of numbers:
?combn
combn(1:3,2) # Generate all combinations of 1 through 3 of size 2.

# Built in random variate generators.
# R has a lot of random number generators.  

# Say we want to figure out the probability of getting 4 heads
# in 5 tosses:
?rbinom
x <- rbinom(100000,5,0.5)
# This generates 100,000 variates from a binomial distribution,
# five trials each, with a success probability of 0.5.
mean (x == 4)

# Some other useful random number generators include:
?rnorm()		# Random numbers from a normal distribution.
?runif()		# Random numbers from a uniform distribution.
# etc...

# Let's look more at the pseudo-randomness of R.  We can actually
# recreate a random number stream by setting the "seed":
runif(10)
runif(10)
# Notice these are different.  Now set the seed, which is an initialization
# parameter to the "random" number generator.
set.seed(1234)
runif(10)
set.seed(1234)
runif(10)


