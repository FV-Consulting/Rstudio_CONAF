#### GEOG 489: Programming for GIS
#### Chunyuan Diao, chunyuan@illinois.edu
#### Lecture 1: Introduction
#### 23 January 2020


######## WHIRLWIND TOUR OF R, MATLOFF CHAPTER 1 ########

### Don't worry about understanding all of the details in this, 
# this is just to start getting you comfortable with R's interface.  

### A First R Session
# Boot up RStudio (a GUI for R).  In R's console, you will type next to the > 
# (use the mouse to click there) and hit return/enter.
x <- c(1,2,4)
# Type the above command into R and press enter.
# x is a *variable*
# '<-' is the 'assignment' operator, and is similar to '=', so:
x = c(1,2,4) # is the same thing.
# c() means "concatenate", i.e. it merges the numbers into a single *vector*.
# The parentheses, in this context, refer to a *function*.  The function name
# is "c" and the inputs are the things that are inside of the parentheses.
# The pound sign you see here means 'comment'.  Anything after it is ignored by R.
# One of the great things about R is that you can print any variable by just typing 
# it and hitting enter.  This is because R is an interpreted language.  We'll define this
# later.
# Do this now:
x
# This is very similar to the print() statement:
print(x)
# You should see:
# [1] 1 2 4
# Individual vector elements are accessed using [ ], where [1] would be the first element, 
# 	[2] the second, and so on...  Type:
x[3]
# [1] 4
# This is what is known as a "subscript" or "index".  We can also do a subset. Type:
x[2:3]
# This asks R to print out the 2nd through the 3rd value in x. ":" is known
# as the "colon operator" and is also a function.  You should see:
# [1] 2 4
# What happens if you try to print out the 4th element of x?
# [try this now]
# We can concatenate vectors into a new, larger vector.  Try:
q <- c(x,x,8)
# Type the above command into R and press enter.  Then print it out:
q
# [1] 1 2 4 1 2 4 8
# Let's do some simple statistics like calculating the mean and standard deviation of x.  Type:
mean(x) # Mean of the x vector.
# And then..
sd(x) # Standard deviation of the x vector.
# Notice these commands print the values out.  When you do an assignment 
# (x <- ...) R will NOT print the values out.
# We can preserve the output as a new variable. Try:
y <- mean(x)
# And then print it by:
y
# Try creating a variable "s" that is the standard deviation of q.  
# Make sure you print it out to confirm it worked.
# [1] 2.478479
#
# Comments are important, and part of your grade will based on 
# clear commenting of your code, so use them frequently.  
# On the same line, you can include a comment, remember 
# everything AFTER the pound sign will be ignored, so:
y # print out y
# Will do the same thing as:
y
# But the former line lets me know, in English, what it is doing.
#
# Many R "packages" contain sample datasets, which we can list by:
data()
# Scroll through the list to see what sample datasets are available.  
# Let's take a look at the Nile dataset.
# Print the Nile dataset by typing:
Nile
# This is a "time series" dataset (don't worry about what that means now), 
# but we can do basic stats on it:
mean(Nile)
# [1] 919.35
sd(Nile)
# [1] 169.2275
# R has advanced plotting and statistical analysis, so let's create a histogram of this dataset:
hist(Nile)
# Now let's quit R "properly" -- this command works on any OS:
q()
# You will be prompted to "Save workspace image? [y/n/c]:"
# Select no by typing "n" or click it.  
# If you click "yes" (or type "y") when you next open R, all of your datasets will re-load.

# Boot up RStudio again.

### Introduction to functions
# Functions are the core of R -- in the previous step, we used multiple functions
# including c(), mean(), sd(), data(), hist() and even q() -- 
# functions will (almost) always have parentheses
# which are used to pass parameters (some functions don't 
# have parameters or don't need them, like q() ).
#
# Using and *writing* functions is a key part of learning any 
# programming language.  We'll do a quick
# introduction here.
#   
# Boot R back up again.  We didn't save our variables, so try:
x
# You should see:
# Error: object 'x' not found
#
# Now we are going to define a function.  
#
# With all functions, we need to consider the following:
# What are the inputs?
# How does the function manipulate the inputs?
# What are the outputs that will be *returned*?
#
# We are going to define a function that does the following:
# Input: a vector of values
# Output: a count of the number of odd values in the vector
#
# Type the following in CAREFULLY.  Hit enter at the end of each line.
# A couple of things to note:
#	- The brackets demarcate the beginning "{" and end "}" of a function or operator 
# 	- You will notice that until you finish typing the function in you will see a "+" instead of a ">".
#		This + is what is called a "line continuation character" and is a reminder that you haven't
#		finished the function (with the end brace).    
oddcount <- function(x) 
{
	k <- 0 # assign 0 to k
	for (n in x) {
		if(n %% 2 == 1)
		{
			k <- k+1 # %% is the modulo operator
		}
	}
  return(k)
}

# If you get any errors, make sure you have a > and re-type the function until you don't get an error.
# Very common errors are not closing parentheses and braces.  We will use tools later on to help with that.
# Use the tab key to create the spacing.  Tabs are not needed, but are key parts of keeping code readable.
#
# Now we have defined the function oddcount.  Notice that the "header" of the function tells us there
# is one input, x.  Recall that the input must be a vector, which we can create using c().  
# If you want to print the code of the function again, just type:
oddcount # no parentheses
# Let's try the function out by passing it a parameter:
oddcount(x=c(1,3,5))
# There are three odd numbers in this vector, so we see:
# [1] 3
# Try:
oddcount(x=c(1,2,3,7,9))
# How many odd numbers were in this?
#
# The function appears to be working, now let's look more carefully at what it is doing.
# 
# Following the *flow* of a function is a critical skill for understanding what it is doing (and fixing
# problems that may arise).
# 
# First, let's look at the modulo operator "%%".  This operator returns the remainder of a division, e.g.:
38 %% 7 
# [1] 3
# Notice that if the modulo of an even number divided by 2 is 0:
38 %% 2
# [1] 0
# And an odd number is 1:
39 %% 2
# [1] 1
# We'll learn more about for loops later on, but for now, for(n in x) { ... } 
# can be interpreted as setting n equal to x[1], running the commands inside of the braces,
# and then once its done, repeating the process on x[2], and so-on until it gets to the end of x.  
# We can see this by typing:
y=c(3,0,7)
for(n in y) { print(n) } # Print simply prints the value of the variable
# This is the same as:
n=y[1]
print(n)
n=y[2]
print(n)
n=y[3]
print(n)
# Back to our oddcount function:
# The function starts with k set to 0, and then starts the loop:
#	for (n in x) {
#		if(n %% 2 == 1) k <- k+1 # %% is the modulo operator
#	}
# x was passed to the function as e.g.: oddcount(x=c(1,3,5)), so x is c(1,3,5)
# The loop starts with n <- x[1], then tests whether or not n is odd by 
# checking if n %% 2 is equal ("==", note the TWO equal signs) to 1.
# Logical statement are used frequently, so let's see what if() is actually testing by typing:
37 %% 2
37 %% 2 == 1  
# [1] TRUE
38 %% 2
38 %% 2 == 1
# [1] FALSE
# an if() statement, fundamentally, is just testing whether a statement is TRUE or FALSE.  
# We'll learn more about these later.
#
# So, if n %% 2 does equal 1, the function adds 1 to k, and repeats the process on x[2], and so on.
#
# Once the function is done, we want to return the value of k which is keeping track of how many odd
# numbers are in our vector, so we use the return() statement:
# return(k)
# 
# Some definitions:
# In the function definition, x is the "formal argument" or "formal parameter" of function oddcount
# c(1,3,5) is the "actual argument" of the function.
# Another note: functions can only return a SINGLE variable.  If we want to return a lot of things,
# we'll use some tricks discussed later.
#
# A lot of times it is helpful to see, more specifically, what a function is doing by using print() statements.
# paste() merges the contents together into a single string.
# We will mod the code a bit to help watch the function run:
oddcount <- function(x) {
#	print("x is:")
	print(x)
	k <- 0 # assign 0 to k
	print(paste("k is initialized as",k))
	for (n in x) {
		print(paste("current x value being tested is",n))
		if(n %% 2 == 1) 
		{
			k <- k+1 # %% is the modulo operator
			print(paste(n,"is an odd number!"))
		} else
		{
			print(paste(n,"is an even number!"))
		}
		print(paste("k is currently",k))
	}
	print(paste("The final k is",k))
	return(k)
}
# And trying running our more verbose function:
oddcount(x=c(1,2,3,7,9))

### Variable scope
# Variables that are WITHIN a function are "local" 
# to that function.  "n" is a local variable to oddcount, 
# so try typing it:
n 
# Error: object 'n' not found
# Variables that are created OUTSIDE of functions 
# are "global" and can be accessed from within functions.
f <- function(x) 
{
  return (x+y)
}# Note y is not a 
# formal argument or defined within the function
f(5) # Note the error
y <- 3 # A global assignment
f(5)
# [1] 8
# This is a dangerous behavior, for those of you who know
# code.  Be aware of this.

### Default arguments
# What happens if we don't pass an argument to oddcount?
oddcount()
# Error in oddcount() : argument "x" is missing, with no default

# We can add default arguments (when they make sense) to 
# functions that, if the user doesn't pass 
# an actual argument to the function, the function uses 
# the default.  For instance:
# g <- function(x,y=2,z=T) { ... }
# If a user doesn't pass y or z to the function, it will 
# still work and will assume y equals 2 and z equal T ("TRUE").
# However, since x does not have a default, if the user 
# doesn't pass x to the function it will not work.

### Preview of some important R data structures
# R data structures are different ways of defining and 
# organizing data, e.g. vector and raster spatial data.  
# Later on, we will learn about geospatial data structures, 
# but we need to start learning the "core" ones first. 

### Vectors (not to be confused with GIS vectors)
# A vector is an ordered set of elements that all share the same "mode" (data type), 
# for instance characters, integers, or floating point numbers.
# A scalar (an individual number), e.g.:
myscalar=2
myscalar
# ..is a ONE ELEMENT VECTOR.  There are no "true" scalars in R.  Thus, we can use vector index notation:
myscalar[1]
# Let's define an x vector:
x <- c(5,12,13)
# We can determine its length by:
length(x)
# [1] 3
# And its mode (data type) by:
mode(x)
# [1] "numeric"
# 
# We can define a single element character vector by using quote marks:
y <- "abc"
length(y)
mode(y)
# and a multiple element character vector using our friend c():
z<-c("abc","29 88")
length(z)
mode(z)
# Note that quote marks will result in a character, even if its a number, e.g.:
w<-"28"
mode(w)

### Matrices
# A matrix is, technically, a vector that has two additional attributes: 
# number or rows and number of columns.  
# The restrictions on a matrix are the same as a vector: all the elements
# must be the same mode (e.g. integer, numeric, or character).
# One way to make a matrix is using the "matrix"
# function:
mymatrix <- matrix(data=c(1,3,5,8),nrow=2,ncol=2)
mymatrix
#      [,1] [,2]
# [1,]    1    5
# [2,]    3    8
# We could also use the "row bind" function to "stack" two vector "rows" together:
mymatrix2 <- rbind(c(1,4),c(2,2))
mymatrix2
# Remember we can index a vector by using a single value, e.g.:
x # Should still be assigned
x[1]
# A matrix has two dimensions, so we need to use two values to index it:
mymatrix
mymatrix[1,2]
#
# A WORD OF WARNING: R matrices are called in the order row,column.  This is
# the OPPOSITE of geographic data, in which we usually call data by:
# column (easting), row (northing).  This may come back to confuse us later, so just
# be aware of this.  This is known as COLUMN-MAJOR ordering of matrices.
# 
# We can extract submatrices by not defining a specific element, e.g.:
mymatrix[1, ] # Prints row 1, all columns of mymatrix
mymatrix[ ,2] # Prints all rows, column 2 of mymatrix

### Lists
# A list is a *vector* in which each element can be any type of data structure, so is
# the most flexible type of data structure.  We'll define a list as containing a 
# single element numeric vector, a 3-element character vector, and a matrix:
mylist <- list(u=2,v=c("abc","def"),w=matrix(data=c(1,2,3,4),nrow=2,ncol=2))
# We can print the whole list out by:
mylist
# And we can access subelements of the list in two ways.  First, by using double brackets:
mylist[[1]] # Prints the single-element numeric vector
mylist[[3]] # Prints the matrix.
# We can also access it by using the variable name and a dollar sign:
mylist$v # Prints the v variable 
mylist$w # Prints the w variable
# A list is a good way to "package up" a bunch of variables to return from a function.
# Lists are used a lot in R to group together disparate types of data into a more tractable variable.  
# For instance, let's output the histogram to a variable:
hn <- hist(Nile)
# Notice it shows you a plot, but we have a histogram "object".  Let's look at it:
hn
# Lists can often be a lot of data to look at.  We can print it out more compactly:
str(hn)
# This variable is a list data structure, at its core.  
# We can look at just the counts of each bin using $:
hn$counts  

### Data frames
# A data frame is a list, but with some restrictions, namely, each element
# of the list must be 1) a vector and 2) the same length of the other elements.
# The vectors, however, can be different modes (unlike a matrix).
# In other words, a data frame is the R equivalent of a spreadsheet.
# MANY models in R require the inputs to be a data frame.  
# We can define a data frame in a similar fashion as a list, but making sure
# we meet the vector length requirements:
d <- data.frame(kids=c("Jack","Jill"),ages=c(12,10))
d
# Try:
f <- data.frame(kids=c("Jack","Jill"),ages=c(12,10,11))
# Why didn't that work?  Hint: READ THE ERRORS.
# Just like lists, we can access individual variables by using the variable names:
d$ages
# We can print the whole data frame:
d 
# or in compact form:
str(d)


### Getting in-program help
# R has some decent (if imperfect) off and online documentation.  Get comfortable
# with looking for help.  To begin with, we can use the help function.  Let's get
# more help with the matrix() command:
help(matrix)
# We can use the question mark as a shortcut:
?matrix
# Sometimes we have some weird characters/functions we want to get help for, for instance:
?for

# Oops, now we've started a for loop.  Go ahead and force an error by typing:
{}
# We can use quotes for functions that don't behave well with the help command:
?"for"
# also, our modulo operator causes a similar problem:
?%% # doesn't work, but:
?"%%" # does.

# All this is fine if we know the name of the function, but what if we don't
# know what function to use for something, 
# e.g. to determine a multivariate normal distribution?  We use help.search (and quotes):
help.search("multivariate normal")
# or the shortcut ??
??"multivariate normal"
# Notice it ID'd the mvrnorm function, in the package MASS.  

# Packages are extremely important -- you can think of these as collections
# of programs that extend the basic R functionality.  This is one of the strengths of
# using R: there is a huge number of packages that have been contributed by users
# around the world.  Visit: 
# http://cran.r-project.org/web/packages/available_packages_by_name.html
# to see packages that are currently mature and distributed freely.
# 
# We can get help for an entire package that has been installed:
help(package="MASS")

# Other sources of help are:
# http://www.r-project.org/ -> click "Manuals" on the left
# http://www.r-project.org/ -> click "Search" on the left
# http://www.rseek.org/ -> probably one of the best searchable help systems

# Once you are done, quit out of R and don't save your data:
q()
# Select "n" or "No"

##### UNGRADED ASSIGNMENTS (do them anyway)
# 1) Download and install R on your home computer from http://cran.r-project.org/
# 2) (Optional but recommended for Mac/Windows): Download and install RStudio Desktop (free) 
#	on your home computer: http://www.rstudio.com/products/RStudio/#Desk  
# Note: you need to install R FIRST.
# 3) Read chapter 1 in Matloff