#### GEOG 489: Programming for GIS
#### Chunyuan Diao, chunyuan@illinois.edu
#### Assignment 3
#### Due Thursday, March 10, 2019 at midnight.

# Your goal is to write a function that calculates a set of descriptive
#   statitics for a data frame, and return the output in a list format.

# Input: x=data frame, probs=quantile probabilities, na.rm (logical)
# Output: list, one list component per column, named after the data frame columns
	# Sublist components (the components should be named "mean","median","sd", and "quantiles"):
	  #	mean: the column's mean
	  #	median: the column's median
	  # sd: the column's standard deviation
	  # quantiles: a matrix of probs vs. the quantile of x for those probs. 
	# The matrix should have one prob/quantile per row.  
	# The first column should be named "prob" and the second "quantile".

# The na.rm flag should be used with all stats calculations
# if a column cannot have statistics calculated, the value should return NA
#	WITHOUT a warning.  Note that:
	column1 <- c("abc","def")
	mean(column1) 
# returns an NA but also a warning...  you will lose a point if this happens.
# The quantiles, as well, should just be an NA (not a matrix).

# The requirements are as follows:
#	1) The function name should be "descriptiveStats".
#	2) probs should be, by default, set to a 3-element vector of 0.25, 0.5 and 0.75.
#	3) na.rm should be set to FALSE by default.
#	4) x must be checked to make sure it is a data.frame, and stopped with a warning if not.
#	5) probs must be checked to make it is a numeric vector, and 
#     that all values are greater than or equal to 0.0 and less than or equal to 1.0.
#     It should stop with a warning, if not.
# 6) Comment your code in at least 3 places.
#	7) You may NOT use any R packages except the default set.
#	8) The code should be submitted to Compass 2g as a single function with the filename:
#		[your LastName-FirstName-geog489-s20-assignment-03.R
#	and should have at the top:
#	[Your name]
#	Assignment #3
#


# Tests:
myDataFrame1 <- data.frame(col1=((25:1)*10),col2=1:25,col3=letters[1:25])
descriptiveStats(x=myDataFrame1,probs=c(.25,.50),na.rm=FALSE)

# $col1
# $col1$mean
# [1] 130
# 
# $col1$median
# [1] 130
# 
# $col1$sd
# [1] 73.59801
# 
# $col1$quantiles
# prob quantile
# [1,] 0.25       70
# [2,] 0.50      130
# 
# 
# $col2
# $col2$mean
# [1] 13
# 
# $col2$median
# [1] 13
# 
# $col2$sd
# [1] 7.359801
# 
# $col2$quantiles
# prob quantile
# [1,] 0.25        7
# [2,] 0.50       13
# 
# 
# $col3
# $col3$mean
# [1] NA
# 
# $col3$median
# [1] NA
# 
# $col3$sd
# [1] NA
# 
# $col3$quantiles
# [1] NA


# One of the columns has an NA, using default behavior:
myDataFrame2 <- data.frame(col1=c(NA,((24:1)*10)),col2=1:25,col3=letters[1:25])
descriptiveStats(myDataFrame2)

# $col1
# $col1$mean
# [1] NA
# 
# $col1$median
# [1] NA
# 
# $col1$sd
# [1] NA
# 
# $col1$quantiles
# [1] NA
# 
# 
# $col2
# $col2$mean
# [1] 13
# 
# $col2$median
# [1] 13
# 
# $col2$sd
# [1] 7.359801
# 
# $col2$quantiles
# prob quantile
# [1,] 0.25        7
# [2,] 0.50       13
# [3,] 0.75       19
# 
# 
# $col3
# $col3$mean
# [1] NA
# 
# $col3$median
# [1] NA
# 
# $col3$sd
# [1] NA
# 
# $col3$quantiles
# [1] NA

descriptiveStats(myDataFrame2,na.rm=TRUE)

# $col1
# $col1$mean
# [1] 125
# 
# $col1$median
# [1] 125
# 
# $col1$sd
# [1] 70.71068
# 
# $col1$quantiles
# prob quantile
# [1,] 0.25     67.5
# [2,] 0.50    125.0
# [3,] 0.75    182.5
# 
# 
# $col2
# $col2$mean
# [1] 13
# 
# $col2$median
# [1] 13
# 
# $col2$sd
# [1] 7.359801
# 
# $col2$quantiles
# prob quantile
# [1,] 0.25        7
# [2,] 0.50       13
# [3,] 0.75       19
# 
# 
# $col3
# $col3$mean
# [1] NA
# 
# $col3$median
# [1] NA
# 
# $col3$sd
# [1] NA
# 
# $col3$quantiles
# [1] NA