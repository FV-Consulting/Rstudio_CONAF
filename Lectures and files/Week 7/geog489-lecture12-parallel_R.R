#### GEOG 489: Programming for GIS
#### Chunyuan Diao, chunyuan@illinois.edu
#### Lecture 12: Parallel R 

# Some pre-class announcements:
# Assignment 3 is now online and is due at midnight next Tuesday, March 10.  DO NOT WAIT.


######## GRAPHICS, MATLOFF CHAPTER 12 ########

# One of the things that R is "famous" for is its 
# extremely rich set of graphing capabilities.  
# Unfortunately, this doesn't quite exist for GIS
# graphics yet.  However, we'll take a look at 
# some basic graphing capabilties here.

# First, a word of graphing in R.  There are basically
# two approaches to graphing.  The first is the default
# graphing functions that R comes with. The second is
# a package called "lattice".  We will focus on the former,
# but mention that lattice is a VERY widely used package,
# and allows for vastly exanded graphing capabilities over
# the default package.

### The workhorse of R Base Graphics: the plot() function
?plot
# Plot is a generic function, and is used by a large number
# of objects.  For instance, if we look at plotting two vectors:
plot(x=c(1,2,3),y=c(1,2,4))
# This creates a single point plot, where the pairs are 
# determined element-wise from the two vectors.
# One nice thing about plots is that you can build them
# up in stages.  We can make a blank plot first:
plot(x=c(1,3),y=c(1,8),type="n",xlab="x",ylab="y")
# type = "n" means "no plotting", so you don't see the two points
# (-3,-1) and (3,5) -- instead, these define the ranges of the 
# x and y axes.  xlab and ylab set the labels of the x and y
# axes.

### Adding lines: the abline() function
# To the empty graph, we can now add some points:
x <- c(1,2,3)
y <- c(1,3,8)
points(x,y,xlab="x",ylab="y")
# Notice this didn't overwrite your blank plot,
# it added to it.
# Now, we can add a line created using a linear regression:
lmout <- lm(y ~ x)
lmout
?abline 
abline(lmout)
# abline allows an object of class "lm" as an input.
# We can add a line manually by using the lines() funciton
# and setting the starting and stopping coordinates:
?lines
lines(x=c(1.5,2.5),y=c(3,3))
# We can also connect the dots by setting the type of a plot()
# to "l" for lines:
plot(x=x,y=y,type="l")
# Notice your other items went away.  Whenever you call plot(),
# your current plot is replaced by a new one.  If you want to 
# make multiple plots, you must make a new "window".  This differs
# by system and IDE, but in general:
# For Linux use x11()
# For Mac use quartz()
# For Windows use windows()
# So, if we want to see two histograms:
hist(x)
#quartz()
windows()
hist(y)

### Adding points: the points() function:
plot(x=c(-3,4),y=c(-1,8),type="n",xlab="x",ylab="y")
?points
points(x=c(1.5,2.5,3.5),y=c(0.5,2.5,7.5),pch="+")
# pch refers to the plotting character (symbol).
?par
# par() sets the behavior of all plots made after
# it is run, so to change the background of all new
# plots to be yellow, we can use:
oldpar <- par()
par(bg="yellow")
# par -> oldpar
plot(x=c(-3,4),y=c(-1,8),type="n",xlab="x",ylab="y")
points(x=c(1.5,2.5,3.5),y=c(0.5,2.5,7.5),pch="+")
# par() has a LOT of parameters you can tweak.

### Adding a legend: the legend() function
?legend
par(bg="white")
# We can add legends to our graphs in a lot of ways, 
# you can see some examples using:
example(legend)


### Adding text: the text() function
?text
# We can add text anywhere on the graph using text():
plot(x=c(-3,4),y=c(-1,8),type="n",xlab="x",ylab="y")
points(x=c(1.5,2.5,3.5),y=c(0.5,2.5,7.5),pch="+")
text(x=1.5,y=0.5,"point text") 
# Adds the text at the point 1.5,0.5 on the graph.
# Notice it centers the text over the point.  We might
# have to tweak the positions to look better, e.g.:
plot(x=c(-3,4),y=c(-1,8),type="n",xlab="x",ylab="y")
points(x=c(1.5,2.5,3.5),y=c(0.5,2.5,7.5),pch="+")
text(x=2,y=4,"point text") 

### Pinpointing locations: the locator() function
# Rather than trial and error, you can pinpoint a location
# using the locator() function and the mouse:
locator(1)
# Click on your graph someplace.
# The parameter is how many locations you want to choose,
# so if you want to choose 2 places:
locator(2)
# You could use the locator in the text function to manually
# place the text:
text_location <- locator(1)

text(locator(1),"locator text") 

### Customizing graphs
# R provides a wealth of customization options for graphing:
### Changing character sizes: the cex option
# Note: this is pronounced "kex", and stands for "character expand".
# If you want to bump up the font size, you can use:
text(locator(1),"larger",cex=1.5)
# The value is a multiplier of the base size, so this makes the
# characters 1.5 times their normal size.  Don't confuse this
# with more standad font sizes.

### Changing the range of axes: the xlim and ylim options
x <- c(1,2,3)
y <- c(1,3,8)
plot(x,y)
# Set xlim and ylim to a two-element vector where the first
# element is the minimum of the axis, and the second is the max:
plot(x,y,xlim=c(-10,10),ylim=c(-20,20),xlab="myx",ylab="myy")

### Adding a polygon: the polygon() function
# Don't get too excited yet, this isn't GIS!
f <- function(x) return(1-exp(-x))
?curve
# Curve will draw a function f over an interval
curve(expr=f,from=0,to=2) 
# We can add a polygon that estimates the area 
# under the curve for a small region:
polygon(x=c(1.2,1.4,1.4,1.2),y=c(0,0,f(1.3),f(1.3)),col="gray")
# col refers to the color to fill the polygon with.  We can 
# add other things like striping via the density argument:
curve(expr=f,from=0,to=2) 
polygon(x=c(1.2,1.4,1.4,1.2),y=c(0,0,f(1.3),f(1.3)),density=20)

### Smoothing points: the lowess() and loess() functions
cars # built in dataset of speed vs. distance
# For a data.frame that has two columns, you will plot
# by default the first = x and second = y columns:
plot(cars)
?lowess
lines(lowess(cars))
# This fits a smoothed line to the data.  
# There is another similar function "loess".  
?loess
lines(loess(cars))
# Before using these in practice, you should review how they work
# using the help, and understand the parameters.

### Graphing Explicit Functions
?curve
curve(expr=f,from=0,to=2,n=101) 
# Curve uses, by default, 101 equally spaced points for x.
# We can mod this by adjusting the n value:
curve(expr=f,from=0,to=2,n=3) # Only used 5 x values

### Saving graphs to files
# These graphs wouldn't be much good if we couldn't get
# them out of R into some other format.

# Each graphic window or file we want to "print" to
# is considered a graphics device.  We can see all the
# devices currently opened via:
?dev.list
dev.list() # The number refers to the ID of the graphics device.
# Let's open a pdf file to save a plot to:
pdf("d14_multiple.pdf")
dev.list()
# Usually new graphics devices are set to be the "current" device, 
# which we can test by:
?dev.cur
dev.cur() # the pdf device is the current device.
# We can set our in-IDE display window back to the best current by:
?dev.set
dev.set(2) # Set the current graphics device to be ID #2
# Now let's plot some stuff:
curve(expr=f,from=0,to=2) 
# Notice this went to the display device.  What if we want to
# copy this to the PDF file?
?dev.copy(device=2,which=4)
dev.copy(which=4) # Copies the current device contents to the ID
# given by which=.
# The PDF is an OPEN FILE that is being WRITTEN TO.  Like with all
# open files, we must close it before opening it in e.g. Acrobat:
dev.set(4) # Switch to the pdf device.
?dev.off
dev.off() # Turn it off (close it).
# You can now open d12.pdf which should be in your working directory:
getwd()

### Creating 3-d plots:
# Let's load up the more powerful graphics library "lattice":
install.packages("lattice")
library(lattice)
help(package="lattice")
a <- 1:10
b <- 1:15
# Create all possible combinations of a and b:
eg <- expand.grid(x=a,y=b)
# Add a new column that is a function of x and y:
eg$z <- eg$x^2 + eg$x + eg$y
?wireframe
wireframe(z ~ x+y,eg)
# wireframe() requires x and y to form a rectangular grid.
# We can put some colors on it:
wireframe(z ~ x+y,eg,shade=T)



######## PARALLEL R, MATLOFF CHAPTER 16 ########
# This is a huge topic, and we will talk about
# some aspects of it as it relates to GIS, but the basic
# concept of parallel programming is the following:
#
# Given some problem X that can be divided into 
# subproblems x1, x2, x3, each subproblem can
# be sent to a different "worker" processor (which may be
# located on a different physical computer).  Each
# processor then sends the results of its subproblem
# back to a central "master".  The master often then
# pieces the subproblems back together to return to the user.
#
# Parallel computing is not a cure-all, and not all problems
# will benefit from it.  We'll come back to this issue in a bit.
#
# There are a lot of packages to realize parallel computing
# within R, and current versions of R even come with some
# parallel computing packages built-in.  A full list can
# be found at:
# http://cran.r-project.org/web/views/HighPerformanceComputing.html

# install relevant packages:
install.packages("Biobase")
install.packages("boot")
install.packages("parallel")
install.packages("BiocManager")
#BiocManager::install(c("GenomicRanges", "Organism.dplyr"))


# # First, grab this function:
# source("http://bioconductor.org/biocLite.R")
# biocLite("Biobase")

# We are going to run a test using genetic data:
data(geneData, package = "Biobase")
# This data represents 500 genes (organized by rows)
# with expression data (numerical).  
# The goal is to calculate the correlation coefficient
# between all pairs of genes across all samples.  For example,
# to test gene 12 vs 13:
?cor
geneData[12,]
geneData[13,]
plot(geneData[12,],geneData[13,])
cor(geneData[12,],geneData[13,])
# The total number of paired correlations will be:
#	500 x 499 / 2 = 124,750 correlations
# We can determine all combination ids using:
?combn
# We are going to leave this as a list, for now...
pair <- combn(1:nrow(geneData),2,simplify=F)
length(pair)
head(pair,n=3)
tail(pair,n=3)

# Let's write a function to accept a pair and the database and returns
# the correlation:
geneCor <- function(pair,gene=geneData)
{
	cor(gene[pair[1],],gene[pair[2],])
}

# TEST THIS:
cor(geneData[12,],geneData[13,])
geneCor(pair=c(12,13),gene=geneData)

# We left our pairs as a list, so we can, of course, use lapply:
# Let's just test the first 3 pairs:
pair[1:3]
outcor <- lapply(pair[1:3],geneCor)
outcor

# Now let's do the whole calculation.  First, open your task manager
# by hitting control-alt-delete and choosing Start Task Manager.
# Click the "Performance".  Notice you have a few graphs next to 
# CPU Usage, which shows each processor you have on your machine.

# Type the following and watch the CPU Usage History graph:

system.time(outcor <- lapply(pair,geneCor))



# Let's make an even bigger dataset, making 26 x 4 = 104 columns.
fakeData <- cbind(geneData,geneData,geneData,geneData)
# Now lets make a more complex function that calculates the 
# 95% confidence intervals of the correlation coefficients
# through a process of bootstrapping:
library(boot)
geneCor2 <- function(x, gene = fakeData) 
{
	mydata <- cbind(gene[x[1], ], gene[x[2], ])
	mycor <- function(x, i) cor(x[i,1], x[i,2])
	boot.out <- boot(mydata, mycor, 1000)
	boot.ci(boot.out, type = "bca")$bca[4:5]
}

# Test how long 10 pairs would take:
genCor2_system_time <- system.time(outcor <- lapply(pair[1:10],geneCor2))
genCor2_system_time["elapsed"] # for 10 pairs.  So to figure out
# how long 124,750 pairs will take, let's multiply this by:
genCor2_system_time["elapsed"] *(124750/10)# seconds or
genCor2_system_time["elapsed"] *(124750/10/60/60) # hours
# to execute.  Ouch!  This is a good candidate for 
# parallel processing.

# Let's take a subsample of all the pairs for exploring this further:
pair2 <- sample(pair,300)

# Let's test a sequential version of this:
system.time(outcor <- lapply(pair2,geneCor2))

### parallel: built-in parallel computation package.
# Note: this largely replaces "snow" and "snowfall".

# parallel's basic concept is to launch "worker" instances of R
#	on other processors, and then send the subproblems to each
#	R instance.  This means that if you want to use 4 processors
#	("cores"), after you start a parallel cluster, you will have 5
# 	copies of R running: the master copy (the one you are typing
#	into) and 4 worker copies.  

# The "cluster" of processors can be either a single computer
#	with multiple cores (like the one you are working on),
#	or a network of computers linked by some clustering framework.

# The basic order of using 'parallel' is as follows:
#	  1) library("parallel")
#   2) make a parallel cluster using makeCluster(...)
#	  3) load packages that your function needs into the workers
#		  using clusterEvalQ(cl=...,library(...))
#	  4) load objects from the master environment into the worker
#		  environments using clusterExport(cl=...)
#	  5) Following basic lapply() semantics, use e.g. clusterApplyLB(cl=...)
#		  to apply your function to an input list, where each iteration of the
#		  "loop" will be sent to an available processor.  The output
#	  	is usually a list.
#	6) Shut down your cluster using stopCluster(...)

library("parallel")

# The way parallel works, is we first have to make an R cluster via: 
?makeCluster
# We are going to create a cluster with 4 cpus of type "PSOCK".
# Click the task manager "Processes", and scroll down to the "R"s:
myCluster <- makeCluster(spec=4,type="PSOCK")
# Notice you now have multiple instances of Rscript.exe running now.
myCluster
length(myCluster) # One entry per "worker".
myCluster[[1]]
# We can stop the cluster by:
?stopCluster
stopCluster(myCluster)

# The input can be a set of hostnames which, for a local computer,
# is often "localhost".  Start a new cluster:
myCluster <- makeCluster(spec=c("localhost","localhost","localhost"),
    type="PSOCK")
length(myCluster) # the spec only had three entries this time.
# We can send the same function to each node (worker) 
# in the cluster using 
?clusterCall
clusterCall(cl=myCluster,fun=date)
# These get returned as lists:
workerDates <- clusterCall(cl=myCluster,fun=date)
class(workerDates)
length(workerDates) # One per worker.

# You need to remember that each worker instance of R that is running
#  	is essentially "empty" -- it won't, be default, have access to
# 	the environment of the master.  Thus, we need to send some commands/data
# 	to them in anticipation of running the code.  

workerPackages <- clusterCall(cl=myCluster,fun=search)
workerPackages

# We are using a package called "boot" in our function, so we need
# to load up this package on every worker:
clusterEvalQ(cl=myCluster,library("boot"))

# We can confirm the boot package is now loaded:
clusterCall(cl=myCluster,fun=search)

# Next, we will export the dataset "fakeData" to each worker:
?clusterExport
clusterExport(cl=myCluster,"fakeData")
# Check the environment on each worker:
clusterEvalQ(cl=myCluster,ls())

# Note we could have sent the entire Global environment over to the workers.
clusterExport(cl=myCluster,ls())
clusterEvalQ(cl=myCluster,ls())

# Now comes the actual function call. 
?clusterApplyLB 
# This is VERY similar to an lapply statement, except we 
# 	identify the cluster to send the command to.
# Watch your Performance tab as 3 cores light up:
system.time(outcor2 <- clusterApplyLB(cl=myCluster,pair2,geneCor2))
# vs the non-clustered version:
system.time(outcor <- lapply(pair2,geneCor2))
# We got a big performance boost here!
# Don't forget to shut down your cluster:
stopCluster(myCluster)

# How about with 4 processors?
 myCluster <- makeCluster(spec=4,type="PSOCK")
 clusterEvalQ(cl=myCluster,library("boot"))
 clusterExport(cl=myCluster,"fakeData")
 system.time(outcor2 <- clusterApplyLB(cl=myCluster,pair2,geneCor2))
 stopCluster(myCluster)
 
 
 