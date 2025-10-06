#### GEOG 489: Programming for GIS
#### Chunyuan Diao, chunyuan@illinois.edu
#### Lecture 5: List and Data frame


# Some pre-class announcements:
# -- Assignment 1 will be due next Tuesday, 11 February 2020 at midnight.
# -- Please read chapter 4 (List) and chapter 5 (data frame).


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

######## LISTS, MATLOFF CHAPTER 4 ########
# A list is a collection of objects of different types, 
# and is the core of R's objected oriented programming.
# Lists have somewhat complex indexing, but are important
# for dealing with complicated objects (such as GIS data).

# A list is, at its core, another type of vector.
# Most of the vectors we have used so far (vectors and matrices)
# are *atomic* vectors, which cannot be broken down into smaller components.
# A list, by comparison, is a *recursive* vector.  It can be broken
# down into smaller components.


### Creating a list

# Here's an example, making an employee database.
# Notice that the components are all different data types,
# namely a chacter, numeric, and logical.
?list
j <- list(name="Joe", salary=55000, union=T)
j # Print out the entire list.
# Notice that our "variable" names show up as *component names* in the list.
# These component names are OPTIONAL.  Try making a list without them:
jalt <- list("Joe",55000,T)
jalt
# Components can be called by using either $ and the name:
j$salary
# We can even use a partial name (be careful with this)...
j$sal
# A list is a vector, so we can create an empty list:
z <- vector(mode="list")
z[["abc"]] <- 3
z

### General list operations: indexing
# lists have a few ways to index them.  Going back to our "j" list:
j$salary # Just use the dollar sign and the component name (or an abbreviated one)
j[["salary"]]
j[[2]] # This works because the 2nd element of the list is the salary vector.

# Double brackets vs. single brackets in lists are important.
# Using a single bracket returns an object of class list (a sublist):
class(j[2])
# This is useful in pulling out sub-lists, e.g.:
j2 <- j[1:2]
j2
class(j2)

# Wheras the double bracket returns an object in its native class:
?"[["
class(j[[2]])
# Note that subsetting the list won't work with double brackets:
j[[1:2]]
# You can only reference a SINGLE component with the double brackets.

### Adding and deleting list elements
# Adding to a list is a bit easier and more intuitive than to a vector/matrix:
z <- list(a="abc",b=12)
z
z$c <- "sailing" # This adds a new component "c" to z which is a character vector.
z

# We can also add using a vector index:
z[[4]] <- 28
z[5:7] <- c(FALSE,TRUE,TRUE)
z

# To delete a list component, set it to NULL:
z$b <- NULL
z 
# Notice the numerical indices were renumbered.
# since "b" was the second component, all subsequent components 
# were moved up.

# Lists, since they are vectors, can be concatenated:
z
j
zj <- c(j,z)

# The number of components can be retrieved by using length():
j
length(j)


### Accessing list components and values
# If the list components have tags, you can retrieve them by:
names(j)
# You can "unlist" a list by coercing everything in a list down
# to an atomic vector.  USE THIS WITH CAUTION.
?unlist
ulj <- unlist(j) # This becomes an atomic vector
ulj
class(ulj)
# Notice the names were kept:
names(ulj)
# We can clear them:
names(ulj) <- NULL
names(ulj)
ulj

# Notice that it is a character vector, because that is
# the "lowest common denominator" everything can be coerced to.
# Compare to:
z <- list(a=5,b=12,c=c(13:16)) # Everything is numeric
y <- unlist(z)
class(y)

# Applying functions to lists
# lapply() and sapply()
?sapply # Also will show the help for lapply
# Recall that apply() works on a matrix input, 
# re-running a function over each dimension of a matrix.
# lapply and sapply are equivalents to apply, 
# except they take list inputs.
# These are critically important functions to learn,
# and provide the basis for many parallel processing routines.

z <- list(1:3,25:29)
z 
# Notice that the first and second components are different sizes,
# so we can't coerce these to a matrix and use apply.
output <- lapply(X=z,FUN=median) 
output
# Applies median() to each list component, 
# and returns the output in list form.  Long-form, this did this:
list(median(z[[1]]),median(z[[2]]))
# Notice we could have written a for loop to accomplish this, 
#  but we'd have had a lot more coding to do:
output <- vector(mode="list") # Make a blank list
for(i in seq(z)) # Cycle through every element of z
{
	output[[i]]=median(z[[i]]) # set the output indexed to i to equal the median of z at index i.
}
output

# sapply is very similar to lapply, but does a check to see if it can "simplify" 
# the output: i.e. reduce it to a matrix or vector:
z
sapply_out <- sapply(X=z,FUN=median)
sapply_out
class(sapply_out) # Output is an integer vector.
lapply_out <- lapply(z,median)
lapply_out
class(lapply_out) # Output is a list.


### Recursive lists
# Lists can be recursive, i.e. you can have a list within a list:
b <- list(u=5,v=12)
c <- list(w = 13:15)
d <- c(b,c)
a <- list(b,c)
a
# Let's take a look at this more carefully.  At the top level of list a
# are two lists, b and c, so:
length(d)
length(a) # is 2.

######## DATA FRAMES, MATLOFF CHAPTER 5 ########

### Data frames as matrices
# Just like a matrix, we can extract subdata frames using matrix notation.
# Note that runif(x) generates x random numbers between 0 and 1.
?runif
random_data <- data.frame(data1=runif(5),data2=runif(5),data3=runif(5))
random_data
random_data[2:5, ] # Returns observation (rows) 2 through 5, all variables (columns).
random_data[2:5,2] # Returns rows 2 through 5, 2nd column.  Note that it is coerced to a vector:
class(random_data[2:5,2]) # We can prevent the coercion using drop=FALSE
random_data[2:5,2,drop=FALSE]
class(random_data[2:5,2,drop=FALSE])

# As with matrices, we can do some filtering using logical statements:
random_data[random_data$data1 >= 0.5, ]

# subset can be used with data frames as well:
?subset
subset(random_data,data1 >= 0.5)

# Let's set the 2nd row, 1st column to be NA:
random_data[2,1] <- NA
random_data
# In many models, we need "complete cases" where there is no missing data.  We can use:
complete.cases(random_data) # Which checks each row to make sure there aren't NAs.  
# We can now use this to subset these out:
random_data[complete.cases(random_data),]

# As with matrices, we can use rbind() and cbind().  
# rbind() adds a row (and must have the same number of elements as the data.frame).
xnewrow <- c(2,"abc",6)
xnew <- rbind(random_data,xnewrow)
xnew
# cbind() needs to have the same number of rows as the data frame.
# We'll add a column to random_data that is the difference between data1 and data2:
random_data_new <- cbind(random_data,(random_data$data1-random_data$data2))
random_data_new
# Notice how ugly this name is.  We could just as easily used our technique
# for adding a new component to a list:
random_data_new$data_diff <- random_data$data1-random_data$data2
random_data_new

# Notice that recycling will be used for making sure the data frame components are
# all the right length:
random_data_new
random_data_new$one <- 1
random_data_new 

### Using apply()
# apply() can be used on a data frame IF all the columns are the same type:
random_data
apply(random_data,2,max)


### Merging data frames
# Data frames are R's version of a spreadsheet.  Like any properly formatted table,
# we can use relational operators to join two tables together.  The basic command
# is merge:
?merge
d1 <- data.frame(names=c("Jack","Jill","John"),states=c("CA","IL","IL"))
d2 <- data.frame(ages=c(10,7,12),names=c("Jill","Jillian","Jack"))
d1
d2
merge(d1,d2)
# Notice a few things.  First R recognized that the shared variable was "names",
# which was used to perform the join.  Second, notice that only shared matches 
# were returned (John is missing from d2, Jillian is missing from d1).  Finally,
# notice that the order of the variables retured follows the first entry, then
# the second.
# What if we don't have the same variable name?
names(d2) <- c("ages","kids")
d1
d2
merge(x=d1,y=d2,by.x="names",by.y="kids") 
# We use the by.x and by.y parameters to name the variable to join on.
# Like with all databases, be careful if you have non-unique indices:
d2 <- rbind(d2,c(15,"Jill")) # We now have 2 Jills in d2
d1
d2
merge(d1,d2,by.x="names",by.y="kids",all.x=TRUE,all.y=TRUE,all=TRUE) # Notice that Jill now appears twice in the output.
# Take a closer look at ?merge to see how to fine-tune a join.

### Applying functions to data frames
# Just like lists, we can lapply() and sapply() a data frame.
# We can sort each individual component of the data frame.
?lapply
dl <- lapply(d2,sort)
dl
# lapply applied to a data frame will apply the function to
# each *column*, and return a list.
class(dl)
# We can coerce this output back to a data frame:
?as.data.frame
dl_df <- as.data.frame(dl) 
# Notice that each column is now sorted, although we've lost the link between the name and their age.
dl_df
class(dl_df)

