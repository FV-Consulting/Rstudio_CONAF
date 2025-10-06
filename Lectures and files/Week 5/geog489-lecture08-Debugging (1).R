#### GEOG 489: Programming for GIS
#### Chunyuan Diao, chunyuan@illinois.edu
#### Lecture 8: R Programming Debugging


# Some pre-class announcements:
# -- Assignment 2 is now online and is due at midnight next Tuesday, Feb. 25.  DO NOT WAIT.
# -- Please read Matloff Chapter 13 (Debugging)


######## DEBUGGING, MATLOFF CHAPTER 13 ########

# You are already becoming experts on debugging code, but
# if you are still struggling, the main thing to remember
# is the concept of CONFIRMATION.  Don't assume something
# your code is going to work the way you want it to: 
# test it!  

# To begin with, always have small test cases that you
# have figured out the answer to ahead-of-time, e.g.
# confirm the results independently.

# If you write your code in a modular fashion, your 
# top level function should contain a very small 
# number of commands, most of which are function calls
# This will allow you to test the internal functions one at a time.

# Here's a buggy function:
findruns <- function(x,k)
{
	n <- length(x)
	runs <- NULL
	for(i in 1:(n-k))
	{
		if(all(x[i:i+k-1]==1) runs <- c(runs,i)
	}
	return(runs)
}

# Let's paste this into R.
# FIRST THING TO DEBUG: PARENTHESES, BRACKETS, BRACES.
# If you see a bunch of "unexpected" warnings, this is a good
# sign you've not closed a parentheses, bracket or brace.  
# Scroll up in the warnings and look for the first one:

#Error: unexpected symbol in:
#		"        {
#		if(all(x[i:i+k-1]==1) runs"

# Oops, we missed a parentheses to close the if() statement,
# after the "...==1)".  Correct it and try it again:
findruns <- function(x,k)
{
	n <- length(x)
	runs <- NULL
	for(i in 1:(n-k))
	{
		if(all(x[i:i+k-1]==1)) runs <- c(runs,i)
	}
	return(runs)
}

# Ok, so the function had no obvious errors, but does it 
# do what we want?  CONFIRM CONFIRM CONFIRM.

# This should find the position of all runs of 1 of length 2:
findruns(x=c(1,0,0,1,1,0,1,1,1),k=2) 
# The output, as you can see, should be 4, 7 and 8.  
# We have confirmed something is wrong with a simple
# test case.

# There are two basic ways of debugging: those of you who
# have come to office hours have been showing you the 
# "old school" way, which involves using a lot of print 
# statements to confirm each section.  This can get messy,
# but is a quick and dirty way to debug code.

# Single-stepping through your code is an important
# trick, and R provides nice functions to help you with this.
# We use what R calls the "browser" to debug code.  

# First is the function debug():
?debug
# If you call debug on a function you've written, when
# you execute that function, R will enter the browser
# and allow you to step through the function line by line.
debug(findruns)
# Debug is now enabled for function findruns().  Run the 
# test case again:
findruns(c(1,0,0,1,1,0,1,1,1),2)  
# We are now in browser mode (note the prompt says Browse[2]>
# We will now step through the function one line at a time
# and test to see what's going on.

# First, some commands for the Browser prompt:
# n ("next") or ENTER will execute the next line and then pause.

# c ("continue") basically execute until a close brace "}" is
# found.  What this amounts to is if you enter a loop, the entire
# loop will execute before pausing again.  If you are outside of
# a loop, the rest of the funciton will execute down to the brace.

# Any R command: you can type any R command at the browser prompt to
# query/modify the execution.  One exception: if you have a variable
# named after a browser command, wrap it in a print() statement, 
# e.g. print(n) or print(c).

# where : prints a stack trace, what sequence of function calls
# led to the execution of the current location.

# Q : quits the browser and exits back to interactive level.

# The first line was simply the function call.  We want to make
# sure we entered x correctly, so type x at the Browse prompt:
x
# Let's also make sure k was entered correctly:
k
# Yep, good to go. Type "n" to go to the next line:
n
# And again:
n
# Let's print n and confirm that the variable n is indeed the length of x.  
# 	Remember to wrap this in a print line:
print(n)
# Notice that R tells you the NEXT line it will execute each time
# you hit n.  
# Go to the next line:
n
# This is the beginning of our loop.  Let's enter the loop:
n # and again, but first notice that the next line is to assign i.
n
# Let's look at i and make sure that it began at the right value:
i # Yep, it started at location #1.
# Now, before we move forward, let's make sure our if statement
# is working by breaking it into pieces.  This line is supposed to 
# takes a subsection of x ranging from the current position i, running
# a length of k.  In this case, k is 2, our current index is 1, so the
# indexes should be 1:2, so the subvector should be 1 0:
x
# Did this work?  Confirm it!
x[i:i + k - 1]
# Nope!  This didn't return two values, just one.  Let's look and
# see if the index itself is the problem:
i:i + k - 1
# That's not right, it should be 1 2.  Let's make sure i and k are right:
i
k
# Yep, they are right.  Ok, so our indexing is wrong.  Oops, we forgot
# about operator precedence!  Let's see if this works:
i:(i + k - 1)
# Ah hah!  Ok, let's stop the browser right there, fix our code, and
# test it out again:
Q

findruns <- function(x,k)
{
	n <- length(x)
	runs <- NULL
	for(i in 1:(n-k))
	{
		if(all(x[i:(i+k-1)]==1)) runs <- c(runs,i)
	}
	return(runs)
}

# Now test it again:
findruns(c(1,0,0,1,1,0,1,1,1),2) 
# ARGH.  Still not right.  It should have been 4 7 8.

# We are now going to use a "breakpoint" so we don't have 
# to step through the beginning of the code again, since we know 
# the first part works up until it enters the loop. We'll use
# browser() to set a breakpoint.
?browser

# Now we'll set at breakpoint before the if() statement
# by adding the browser() function:
findruns <- function(x,k)
{
  n <- length(x)
  runs <- NULL
  for(i in 1:(n-k))
  {
    browser() # The program will stop here.
    if(all(x[i:(i+k-1)]==1)) runs <- c(runs,i)
  }
  return(runs)
}

# Now start the code:
findruns(c(1,0,0,1,1,0,1,1,1),2) 
# This stopped on the "if(...)" line.  Test i and k:
i
k
# Now test our modified subvector:
x[i:(i+k-1)] # Yay!  That's right!
# Go to the next iteration using c:
c
# Test i:
i
# Great, it iterated.  Now our index:
x[i:(i+k-1)]
# Compare to the full vector:
x # Yep, ok that worked.  
# Now we could keep looping through, but
# let's modify the code a bit to give us
# the browser on the last iteration of the loop.
# As a heads up, many errors occur at the first and
# last iterations.
Q

# Mod the code:

findruns <- function(x,k)
{
	n <- length(x)
	runs <- NULL
	# Notice our loop ends at (n-k)
	for(i in 1:(n-k))
	{
		if(all(x[i:(i+k-1)]==1)) runs <- c(runs,i)
		# Enter the browser on the last iteration:
		if(i==(n-k)) browser()
	}
	return(runs)
}

findruns(c(1,0,0,1,1,0,1,1,1),2) 
# Ok, check i, which should be at the last iteration:
i
# Wait a minute... what did x look like again?
x
# Uh oh, x is 9 elements long, so really should have 
# stopped at 8, not at 7.  Let's take a look at n-k:
(n-k) # Yep, its 7.  This, however, would work:
(n-k+1)
# Ok, let's Quit out of the browser, mod the code again,
# and test it:
Q
findruns <- function(x,k)
{
	n <- length(x)
	runs <- NULL
	# Notice our loop ends at (n-k)
	for(i in 1:(n-k+1))
	{
		if(all(x[i:(i+k-1)]==1)) runs <- c(runs,i)
		# Comment out the browser line for now to ignore it.
		# Enter the browser on the last iteration:
		# if(i==(n-k)) browser()
	}
	return(runs)
}
findruns(c(1,0,0,1,1,0,1,1,1),2) 
# Success!  

findruns(c(1,0,0,1,1,0,1,1,1),5) 


### Tools for Composing Function Code:

# If we've written some code that have functions in it,
# and written it to a file "xyx.R".  We can quickly
# load them into the environment via:
?source
# e.g. (this won't work since I haven't written this file):
source("xyz.R")

# If you want to quickly edit a function from within the R console, you
# can use the fix() and edit() function:
f1 <- function(x) return(x+1)
fix(f1)
f2 <- edit(f1) 
# You will need to close the edit window once you are done to update the function.


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
