#### GEOG 489: Programming for GIS
#### Chunyuan Diao, chunyuan@illinois.edu
#### Lecture 6: Tables (Chapter 6) and Programming Structures (Chapter 7)


# Some pre-class announcements:
# -- Assignment 1 will be due today, 11 February 2019 at midnight.
# -- Please read chapter 6 (Tables).


######## MATRICES AND ARRAYS, MATLOFF CHAPTER 3 CONT ########

# 2-d looping

# The goal is to write a loop that will go through
#  all possible combinations of a matrix in 2d.

# Think of this as writing an image one pixel at a time,
#  starting with the first row and then writing each
#  column.  Once all the columns of that first row
#  are written, we move to the second row and repeat 
#  the process.

# So, given matrix dimensions nrow_x and ncol_x:

nrow_x = 3
ncol_x = 2
myMatrix <- matrix(seq(10,60,by=10),nrow=nrow_x,ncol=ncol_x)
myMatrix

# We can loop through each entry by some nested
#  for loops.  First start with looping through each 
#   row:

for(current_row in seq(nrow(myMatrix)))
{
  print(current_row)  
}

# We can loop through each column by:
for(current_col in seq(ncol(myMatrix)))
{
  print(current_col)  
}

# We can now put them together:
for(current_row in seq(nrow(myMatrix)))
{
  for(current_col in seq(ncol(myMatrix)))
  {
    print(paste("Current row:",current_row,
                "Current col:",current_col))
  }
}

# Now let's use these to subscript a matrix:


for(current_col in seq(ncol_x))
{
  for(current_row in seq(nrow_x))
  {
    print(paste("the center cell value is:",
                myMatrix[current_row,current_col]))
  }
}

myMatrix


######## FACTORS AND TABLES, MATLOFF CHAPTER 6 ########
# Factors are ways R deals with categorical data.

### Factors and levels
x <- c(5,12,13,12) # Right now, this is continuous data.  
# We can make this numerical vector into a categorical vector by using factor()
#  This creates a new set of information which are the "levels" (unique factors)
?factor
xf <- factor(x)
xf
str(xf)
# Notice that the vector 1 2 3 2 corresponds to the numerical levels
# These refer to the levels 5, 12 and 13.
length(xf) # This is the number of observations in the factor vector.

x <- c(5,12,13,12)
xff <- factor(x,levels=c(5,12,13,88)) 
# Notice there is currently no level from x that will be 88
xff
xff[2] <- 88 # Now we replace one value with the pre-defined factor.
xff
# What happens if we try to enter a level that hasn't been defined ahead of time, 
# R doesn't like it:
xff[2] <- 28

### tapply() function
# tapply, used with vectors, allows us to apply functions on a per-level basis
?tapply
# For instance, say we want to calculate the mean age of people from different political parties:
ages <- c(25,26,55,37,21,42)
affils <- c("R","D","D","R","U","D") # (D)emocrat, (R)epublican, (U)naffiliated
tapply(X=ages,INDEX=affils,FUN=mean)
# What this did was for each level in affils, it calculated the mean value of ages 
# that were equal to that particular factor, e.g.:
mean(ages[affils=="D"])
mean(ages[affils=="R"])
mean(ages[affils=="U"])

# tapply can work with multiple factors.  Here is a more complex example:
d <- data.frame(gender=c("M","M","F","M","F","F"),
		age=c(47,59,21,32,33,24),
		income=c(55000,88000,32450,76500,123000,45650))
d
# Let's make a categorical variable if someone is over 25:
d$over25 <- ifelse(d$age > 25, 1, 0)
d
# Now, we want to see the mean income for four groups:
#  Males under 25, males over 25, females under 25, females over 25:
tapply(X=d$income,INDEX=list(d$gender,d$over25),mean)
# Notice that tapply figured out there were 4 groups, given the 2 factors (gender and over25).

### split()
# If we want to split a vector or data frame into unique components, we can use split:
?split
d
split(x=d$income,f=d$gender) # The output of split is a LIST
split(x=d$income,f=list(d$gender,d$over25)) # Just like with tapply(), we can use multiple factors.

### by()
# tapply() is designed for use with vectors, but what if we want to do something
# similar with a dataframe?
?by
myData <- warpbreaks # a built in dataset
myData
str(myData)
by(data=myData,INDICES=warpbreaks$wool,FUN=summary)
# What this did was first split the warpbreaks dataframe row-by-row and grouped
# according to the INDICES (in this case, the "wool" column).  Then, the function
# is applied to each new data frame that was created.  We ran the summary() function
# on these groups.
?summary

### Tables
# We can generate contingency tables (counting each factor or factor combination) by:
tapply(X=warpbreaks$wool,INDEX=list(warpbreaks$wool,warpbreaks$tension),length)

# We can do this much more simply by:
?table
mytable <- table(data.frame(warpbreaks$wool,warpbreaks$tension)) # This counts all combinations of wool and tension
mytable
class(mytable)
# Tables are a lot like matrices, so you can subset them as such:
mytable[1,1]
# and do arithmetic:
mytable+1
# But these are fundamentally count data for factors.  
# In remote sensing, we often generate confusion matrices (which would be tables), 
# which require knowing the row and column sums.  We can do this quickly using
?addmargins
addmargins(mytable,FUN=sum)
# We can also "recover" the original factor levels using dimnames:
?dimnames
dimnames(mytable)

######## R PROGRAMMING STRUCTURES, MATLOFF CHAPTER 7 ########

### Looping over nonvector sets
# We can coerce non vector sets into a list, then use lapply to loop through them

# Say we have two matrices:
u <- matrix(runif(6),ncol=2)
v <- matrix(runif(6),ncol=2)

# We want to perform a linear regression between columns 1 and 2 of each matrix, 
# e.g. for one matrix:
?lm
lm(u[,2] ~ u[,1])
lm(v[,2] ~ v[,1])
# So how do we do loop through each matrix?  With lapply, we'd do:
newlist=list(u=u,v=v)
lapply(X=newlist,FUN=function(x) {lm(x[,2] ~ x[,1])  })



### if-else
# So far we've mostly talked about if() statements, which
# execute only if TRUE.  We can append an "else" statement as well:

r <- 3
if(r == 4)
{ # Execute if TRUE
	x <- 1
} else
{ # Execute if FALSE
	x <- 3
}
x

# More carefully, an if statement must coerce down to:

if(TRUE)
{
	# Do something.
} else
{
	# Do something else.
}

### Boolean operators
?"&"
x <- c(T,F,F) # TRUE and FALSE can be abbreviate T and F
y <- c(T,T,F)
# Element-wise boolean operators:
x & y # Element-wise "AND" statement
x | y # Element-wise "OR" statement
xor(x,y) # Element-wise "XOR" (exclusive OR) statement
!x # Element-wise NOT statement

# Notice that none of these could be used with an if() statement,
# because an if() statement must collapse down to a SINGLE
# TRUE.

x && y # AND, only uses the first element of x and y
x || y # OR, only uses the first element of x and y

# In arithmetic, a TRUE == 1 and FALSE == 0
TRUE + 2
FALSE - 1


### Default and named arguments
# As you've seen, sometimes I write out the parameter name
# and sometimes I don't.  For instance:
myvect <- c(1:10)
mean(myvect)
# If you look at the help:
?mean
# You will see the first argument is actually named "x", so:
mean(x=myvect)
# does the same thing.  If you don't name an argument, be aware
# that R will assume you are entering the values in the order
# they appear in the function call.

### return() with > one object (or a complex object)
# return() in a function can only be used once to return a single object.
# If you want to return MULTIPLE objects, you need to store them in a list
# object.  For instance, say we have a function that takes an input x,
# and we want it to return two things: the square of x, and a matrix of 
# all ones of dimension x by x.

myfunc <- function(x)
{
  x_squared <- x^2
  x_matrix <- matrix(1,nrow=x,ncol=x)
  # How do we return both of these?  
  output <- list(x_squared=x_squared,x_matrix=x_matrix)
  return(output)
}

myout <- myfunc(3)
myout


# There are technically two parts to a function,
#  the formal arguments (within the parentheses), and the
#  expression, a.k.a. the body of the function.

# { is actually a function itself! 
?"{"

# { } takes multiple expressions and lumps them together, which 
# function() takes to mean a single expression.  This is why
# if we only have one statement, we don't need the { }:
g <- function(x,y) { return(x+1) }

# We can access the formal argument of a function via the formals() function:
?formals
formals(g)
# And the body of the function:
?body
body(g)
# We can "print" the function like any other object:
g

# Many R functions can be printed:
abline 

# Some R functions are written in C, so are not viewable:
sum

# Functions are objects, so we can assign them as such:
h <- g # Assigns the variable "h" to the function g
formals(h)
body(h)
h(3)
# And we can loop through them:
g <- function(x) return(x+1)
h <- function(x) return(x+2)
for (f in c(g,h))
{
  print(f(2))
}