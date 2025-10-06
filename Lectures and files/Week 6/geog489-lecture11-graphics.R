#### GEOG 489: Programming for GIS
#### Chunyuan Diao, chunyuan@illinois.edu
#### Lecture 11: String Manipulation and Graphics 


# Some pre-class announcements:
# -- Please read Matloff Chapters 11 (String manipulation) and 12 (Graphics)



######## STRING MANIPULATION, MATLOFF CHAPTER 11 ########
# Being able to manipulate and parse string data is a key
# skill with being able to program batch processes, extract
# data from poorly or oddly formatted datasets, and to
# pull metadata out of files.

### grep()
?grep
# grep(pattern,x) looks for a substring pattern in a vector of 
# strings:
mystrings <- c("Equator","North Pole","South Pole")
grep("Pole",mystrings) 
# The substring "Pole" was found in the 2nd and 3rd positions
grep("pole",mystrings) 
# Capitalization matters!

### nchar()
?nchar # finds the number of characters in a string:
nchar("South Pole") # spaces count

### paste()
?paste # concatenates strings into one string
paste("North","Pole") 
# notice by default a space seperates the elements.
paste("North","Pole",sep="") 
paste("North","Pole",sep=".") 
paste("North","and","South","Poles")
x <- "and"
paste("North",x,"South","Poles")

### sprintf()
# This is called a "string print", where we are
# "printing" to a string s.  The %d refers to 
# non-string variables to be formatted as a decimal.
# The variables are defined after the string in the
# order they are entered.  This is a C function, at
# its core.
?sprintf 
i <- 8
s <- sprintf("the square of %d is %d",i,i^2)
s

### substr()
?substr # Returns a substring given a range of characters:
substr("Equator",start=3,stop=5) # return the 3rd through 5th character

substr("IL001",start=3,stop=5)

### strsplit()
# Splits a string into a vector of substrings based on 
# 	a string delimiter.
?strsplit 
strsplit(c("6-16-2011","9-23-2014","10-2014"),split="-") # notice the output is a list.

### regexpr()
# Finds the character position of the first instance of the
# pattern within the string.
?regexpr()
regexpr(pattern="uat",text="Equator")[1]

### gregexpr()
# This is similar to regexpr but it finds all instances of the pattern:
?gregexpr
regexpr("iss","Mississippi")[1]
gregexpr("iss","Mississippi")[[1]]


### Regular expressions
# A "Regular expression" is a way to search for complex substrings,
# 	and is almost a language in and of itself.  "regex" or "regexp" 
# 	are used in a lot of different languages.  These are much more
# 	complicated than what you may be more used to, which is the 
# 	use of wildcards ("*").
# 
# Many of Rs string functions, by default, use regex, including:
#	grep(), grep1(), regexpr(), gregexpr(), sub(), gsub(), and strsplit().
#
# For instance, bracket expressions search for a single character 
# 	that is found within the brackets, so:
mystrings
grep("[au]",mystrings)
# searches for all strings in which the letter a or u is found,
#	and returns the vector position.
#
# A period represents a single-character wildcard, so:
grep("o.e",mystrings)
# searches for all strings in which the pattern of the letter
#	'o' followed by some single character followed by the letter 'e' 
#	is found.
# Each period represents a wildcard for one character, so we can
#	put multiple periods together:
grep("N..t",mystrings)
# A period in a grep is what is known as a metacharacter, so:
grep(".",c("abc","de","f.g"))
# Returned everything, since there is an arbitrary one-character
#  	element in all of those.  What if we want to search for an 
# 	actual period (element 3)?  We use a double backslash to do this:
grep("\\.",c("abc","de","f.g"))
# The reason for the double backslash is a bit arcane, since a single
# 	backslash is usually our signal for a metacharacter (remember "\n")?




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

