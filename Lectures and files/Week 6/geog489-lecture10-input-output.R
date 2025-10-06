#### GEOG 489: Programming for GIS
#### Chunyuan Diao, chunyuan@illinois.edu
#### Lecture 10: Input/Output


# Some pre-class announcements:
# Assignment 2 is due at midnight today, Feb. 25.
# Please read Matloff Chapter 10 (Input/Output).


######## INPUT/OUTPUT, MATLOFF CHAPTER 10 ########
# The first step in any GIS project is often getting data
# into your analysis, and the last step is often going to be
# getting results out of your analysis.  We will talk
# about GIS input/output (I/O) soon, but we are going to 
# start with the basics.

## Please change it to your local directory
setwd("U:/Teaching/Spring2020/GISProgramming/Test/")   # Yours are different

### Using the scan() function
# scan() reads data from a file into a vector or list.
?scan
# Let's make some small text files here.  Don't worry about how
# this works yet:
cat("123", "4 5", "6", file="z1.txt", sep="\n")
cat("123", "4.2 5", "6", file="z2.txt", sep="\n")
cat("abc", "de f", "g", file="z3.txt", sep="\n")
cat("abc", "123 6", "y", file="z4.txt", sep="\n")
# We can check to see if the file is in the "working directory":
myfiles <- dir()
myfiles
# Navigate to that file and open it in a text editor.  
# You can find out the location of the working directory by:
getwd()
# Let's scan() the files:
z1 <- scan("z1.txt") # Notice that it created a vector
z1
class(z1)

z2 <- scan("z2.txt")
z2
class(z2)

z3 <- scan("z3.txt")
# Oops, what's going on here?  Let's take a look at
?scan # a bit more closely.  Notice that what=double().
# scan is, by default, attempting to coerce the values
# to a double precision numeric vector.  It is failing on
# the character values within z3.txt.  We can mod this 
# behavior:
z3 <- scan("z3.txt",what="")
z3
class(z3)

z4 <- scan("z4.txt")
# Same error:
z4 <- scan("z4.txt",what="")
z4
class(z4)

# How does scan() know where each vector element starts and stops?
# By default, scan() uses whitespaces as delimiting characters.
# A whitespace includes blanks, returns, and horizontal tabs.
# Look at z3 again:
z3
# Open z3.txt in a text editor and look at the contents. Notice
# the elements are separated by returns AND spaces.
# Let's modify the scan function to only use returns, so
# each line will be one element:
z3 <- scan("z3.txt",what="",sep="\n") # "\n" is a newline character.
z3 # Notice that "de f" are now considered one element.

# What if we want to ask the user to input from the keyboard? 
# We can use scan as well, using a blank value for the file name:
v <- scan("")
# Type:
# 12 5 13
# 3 4 5
# 8
# and then hit return to end it.
v

### Using the readline() function
# We can read a single line from the keyboard by using:
?readline
w <- readline()
# type abc de f
w
# We can use readline with a prompt so the user knows what to do:
inits <- readline("type your initials:")
# Type your initials
inits

### Printing to the screen
x <- 1:3
# We've seen we can just type the object at the command line:
x # to print.  
#we could also use the print() function:
?print
print(x^2)
# Print can only print one object at a time. We could use the cat()
# function to print multiple objects, but we need to remember
# to use a newline character to go to the next line:
?cat
print("abc")
cat("abc","abc",10)
# Say we want to make a more useful statement:
cat("Vector x is",x,"\n")
# We can modify what goes between each element sent to cat:
cat("Vector x is",x,"\n",sep="!")
# or use no space at all:
cat("Vector x is",x,"\n",sep="")
# or have each thing on its own line:
cat("Vector x is",x,sep="\n") 
# or have different separators for each element:
x <- c(5,12,13,8,88)
separators <- c(".",".",".","\n","\n")
cat(x,sep=separators)

### Reading and Writing Files
# Ok, so now let's look at some more useful
# file formats, like a table format:
# Again, don't worry about what this line does yet:
cat("name age", "John 25", "Mary 28", "Jim 19", file="ztable1.txt", sep="\n")
# Open this up in a text editor and look at it.
# We can read this into a data frame with the proper headers using:
?read.table
z1 <- read.table("ztable1.txt",header=TRUE)
z1
class(z1)
names(z1)
# read.table assumes whitespace delimitations. 
# We frequently have csv files to import/export in GIS, so:
cat("name,age", "John,25", "Mary,28", "Jim,19", file="ztable2.csv", sep="\n")
# Confirm this is a CSV file in a text editor
z2 <- read.table("ztable2.csv",sep=",",header=TRUE)
# R conviently provides a "wrapper" for CSV files to make this a 
# bit easier:
z2 <- read.csv("ztable2.csv") # Notice that it assumes header=TRUE

### Introduction to Connections
# To interact with files, R provides many tools
# for fine-tuned control, but we need to work within
# the concept of connections.  This allows us to
# read or write in pieces, rather than all-at-once.
# For big files, this is an important feature so we
# don't run out of memory.
?connection
# We can create a connection to a file in different
# ways, but a common way to connect to a file on disk is
# using file():
?file
myconn <- file("ztable1.txt","r")
# This tells R to open the file ztable1.txt
# in read-only mode ("r")
myconn
class(myconn)
# Notice myconn is the CONNECTION to the file, 
# not the contents.  We can now use this connection
# to access the file:
readLines(myconn,n=1)
readLines(myconn,n=1)
readLines(myconn,n=1)
readLines(myconn,n=1)
readLines(myconn,n=1)
# Notice that the line that is read increments as we 
# call the function over and over again.  n=1 refers
# to "read one line".
# IMPORTANT: remember to close() the connection once
# you are done with it, otherwise weird stuff can happen:
?close
close(myconn)
myconn

# Some symptoms of a non-closed file:
#  You can't delete the file off of disk.
#  You can't open it again.
#  You can't write to it.
#  The position it is reading may not be at the beginning.

# Say we wanted to write a function that reads and prints 
# each line, but prints "reached the end" at the end of the file:
myconn <- file("ztable1.txt","r")
while(TRUE)
{
	r1 <- readLines(myconn,n=1)
	if(length(r1)==0)
	{
		print("Reached the end!")
		break
	} else
	{
		print(r1)
	}
}
close(myconn)


# DON'T FORGET close()!!!!!!!!!
# When in doubt, you can always use:
?closeAllConnections
closeAllConnections()

### Accessing files on remote machines via URLs
# SOME I/O functions can directly access URLs, including
# read.table(), read.csv() and scan().  Here's an example:
# The following website is the online machine learning dataset:
# http://archive.ics.uci.edu/ml/machine-learning-databases/echocardiogram/echocardiogram.data
uci <- "http://archive.ics.uci.edu/ml/machine-learning-databases/echocardiogram/echocardiogram.data"
ecc <- read.csv(uci)
?head # Shows the beginning of a data frame
head(ecc)

### Writing to a file
z1 <- read.table("ztable1.txt",header=TRUE)
z1
# A quick way to write this file out to a new file is:
?write.table
write.table(z1,file="ztablenew.txt")
# Confirm this file was written in the path from:
getwd() # Open it in a text editor.
# Notice that it wrote out the column and row names. 
# If we want to modify this behavior:
write.table(z1,file="ztablenew_nocolrow.txt",
		row.names=FALSE,col.names=FALSE)

# We can also use cat to write, and append to a file:
# Calling cat initially will create a file if it doesn't exist:
cat("def\n",file="cattest.txt") # Don't forget the newline character
# If we want to add a new line to the file, set the append parameter
# to TRUE:
cat("de\n",file="cattest.txt",append=TRUE)
# Confirm this outputted a two-line file in a text editor.
# An important characteristic of this is that the file is
# saved after each operation.  
?writeLines # is the equivalent of readLines and requires a connection:
myconn <- file("writelines_test.txt","w") 
# the "w" indicates the file is opened for writing.
writeLines(c("abc","de","f"),myconn)
close(myconn) # DON'T SKIP THIS STEP (I'm going to keep saying this).
# Check writelines_test.txt -- each part of the vector
# input should be on its own line.

### Getting file and directory information
# This is given a brief discussion in Matloff, but these
# functions are INCREDIBLY important to performing 
# "batch processing" in GIS.
# Briefly, batch processing is repeating the same
# data analysis to multiple files.  For instance, say
# we wanted to reproject a bunch of vector files that we've
# stored in a directory.  We would need to know, first,
# the names of the vector files so we can open them,
# reproject them, and write the output to disk.  We'll return
# to this again, but we'll introduce these functions now:


?dir() # Returns all files in a directory:
dir()
# For batch processing, we might loop through this:
mydir <- dir()
for (i in seq(mydir))
{
	print(mydir[i])
}

# We can also search for patterns:
dir(pattern=".txt")
# We can check to see if a file exists or not:
?file.exists
file.exists("writelines_test.txt")
file.exists("doesnt_exist.txt")
# R, by default, looks in a "working directory" 
# which we can query by:
?getwd
getwd()
# We can change this by using setwd()
?setwd
setwd("Z:/Teaching/GISProgramming/Test/") 
getwd()
dir()

# For a list of other file functions available in R:
?files
