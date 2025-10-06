#### GEOG 489: Programming for GIS
#### Chunyuan Diao, chunyuan@illinois.edu
#### Lecture 7: R Programming Structures (Continued)


# Some pre-class announcements:
# -- Please read Matloff Chapters 7 (Programming Structures)


######## R PROGRAMMING STRUCTURES, MATLOFF CHAPTER 7 ########


### Environment and Scope Issues
# A function has an environment.  Environments need to be paid attention to
# when writing functions.  For example:

w <- 10
g <- function(x) return(x+w)
g(5)
# Why did this work?  We didn't pass w to the function.  
?environment
environment(g)
# This tells us the function was created at the "top level" (R_GlobalEnv),
# which gives the function access to all objects at that level (anything we've
# typed into R).
# We can see all the objects at a given level by using ls()
?ls
ls()
# Notice this returns any object you've created since you started up R 
# (and if you restored a previous workspace, all those objects are there too).
# We can get more info by using ls.str():
?ls.str
ls.str()

# Scope hierarchy: if an object is created within a function,
# that object will be *local* to that function.  So for instance:

g <- function(x)
{
	a=x^2
	return(a)
}
g(10)
print(a) # a was LOCAL to the function g, so no longer exists.
# Now, if an object is used within a function that exists at 
# a higher level, it will search that higher level if it doesn't
# find the object at a lower level.

w <- 10
g <- function(x)
{
	return(x+w)
}
g(5)

# What if we now include w as a local variable to g?

w <- 10
g <- function(x)
{
	w <- 20
	return(x+w)
}
g(5) # Notice that the local variable takes precedence.

# ls() always works with the current level of the environment:

g <- function(x)
{
	w <- 20
	print(ls())
	return(x+w)
}
g(5) # Notice that only w and x were returned, because those were the only
# objects local to g.

# Functions cannot modify variables at a level higher than it directly (usually).
w <- 10
g <- function(x)
{
	w <- 20
	return(x+w)
}
g(5)
w # Notice that w, even though it was defined as 20 within the function, still is
# equal to 10, because the function g was unable to change the global environment.

# IN GENERAL, it is bad form to have a function interact with a global environment.
# Better form is to set those variables as arguments, so g should not be:
w <- 10
g <- function(x)
{
	return(x+w)
}
g(5)

# but...
w <- 10
g <- function(x,w) # w is now a formal argument
{
	return(x+w)
}
g(5,w=10)

### Writing upstairs
# There are occaisions where you want to write a variable to
# a higher level environment.  In these cases, use the superassignment
# operator <<-
?"<<-"
two <- function(u)
{
	u <<- 2*u
	z <- 2*z
  return(z)
}
x <- 1
z <- 3
u # Has not been assigned yet.
two(u=x)
x
z # Notice z did not change, even tho the function set z to be 2*z
u 
# Because the function executed, the value has now been "written upstairs".
# We have only described a two-level environment.  In a more complex environment,
# <<-'s behavior needs a bit more explaining.  What <<- does is work its way
# up the environment levels until it encouters the variable's existence, then
# does the assignment.  If it doesn't find the variable, it will write it to the
# global environment.
f <- function()
{
	# Environment level: 1 level under global
	inc <- function()
	{
		# Environent level: 2 levels under global 
		xint <<- xint + 1
	}
	xint <- 3 
	inc()
	return(xint)
}
f()
xint
# xint isn't found, becayse the function inc() goes up one level once it executes,
# and sees that xint was already defined (xint <- 3), so it assigns xint at that level,
# not the global level.

### Writing to Nonlocals with assign()
?assign
# Assign gives you finer control over writing variables up a level.
rm(u) # Remove u
two <- function(u)
{
	assign("u",2*u,pos=.GlobalEnv)
}
x <- 1
two(x)
x
u

# Notice that the variable name is a character.  This could come 
# in handy if you wanted to automatically create variables in
# the environment from some external source.  Say we have a list
# that we want to write a function to load the list components into the 
# Global environment based on the component names:
myVars <- list(a=1:10,b=c("abc","def"))
a
b
loadVars <- function(list)
{
	listNames <- names(list)
	for(i in 1:length(list))
	{
		assign(listNames[i],list[[i]],pos=.GlobalEnv)
	}
}
loadVars(myVars)
a
b

# Note there is a shortcut function for this particular application:
?list2env




### Recursion
# A recursive function calls itself.  This can be 
# a very powerful solution to various problems.  The basic
# notion of a recursive function is:
# For a problem you are trying to solve of type X:
#  	1) Break the original problem of type X into one or more
# 		smaller problems of type X.
#  	2) Within f(), call f() on each of the smaller problems.
#	3) Within f(), consolidate the results of step 2 to solve
#		the original problem.

# Here is a basic example to solve a sorting problem, "Quicksort":

# Input: a vector of numbers.
# Ouput: the vector of numbers sorted from smallest to largest.

qs <- function(x)
{
	# If x is a one (or zero) element, return it.
	# Notice that this is not a trivial statement, this
	# is a termination condition.
	if(length(x) <= 1) return(x)
	
	pivot <- x[1] # The first element of the vector.
	therest <- x[-1] # Every other element.
	
	sv1 <- therest[therest < pivot] # Every element less than the pivot.
	sv2 <- therest[therest >= pivot] # Every element greather than the pivot.
	
	sv1 <- qs(sv1) # Recursive, send all the less-than elements back to the function.
	sv2 <- qs(sv2) # Recursive, send all the greater-than or equal to elements back to the function.
	# Notice that if the recursion ends, it will return a single element "up the chain".
	
	return(c(sv1,pivot,sv2))
	
}
x <- c(5,4,12,13,3,8,88)
qs(x)

# Let's look at what this does:
# First step: 
# pivot = 5
# therest = (4,12,13,3,8,88)
# sv1 = (4,3)
# sv1 is sent recursively to qs:
#	pivot = 4
#	therest = 3
#	sv1 = 3
#		sv1 is sent recursively to qs
#		termination, returns 3
#	sv2 = blank
#		sv2 is sent recursively to qs
#		termination, returns NULL
#	returns output together as sv1, pivot, sv2:
#		3,4,NULL --> notice this subset is now sorted.

# sv2 = (12,13,8,88)
# ... etc.

