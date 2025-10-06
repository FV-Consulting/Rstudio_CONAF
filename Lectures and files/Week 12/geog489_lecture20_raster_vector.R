#### GEOG 489: Programming for GIS
#### Chunyuan Diao 
#### Lecture 20: RASTER/VECTOR FUSION

## Announcements:
# Final project proposal will be due by the end of today (April 14)
# Quiz 8 is posted on Compass and will be due by the end of tomorrow (April 15)

######## RASTER ALGEBRA ########
# Doing basic raster algebra is simple, 
#   and takes away issues of dealing
# 	with file size limitations.  
# The basic rule of thumb is that any operation 
# is done on a pixel-by-pixel
#	basis.  Mixing different Raster* objects 
# in a statement requires, generally
#	that they be the same number of rows and columns.

library("raster")
# Adding scalars to a raster (digital surface model of Lake Tahoe):
highest_hit_raster <- raster("tahoe_lidar_highesthit.tif")
highest_hit_raster
# Usually the min/max is not calculated for a raster. 
# Let's fix this
?setMinMax # On big rasters, this can take awhile
highest_hit_raster <- setMinMax(highest_hit_raster)
highest_hit_raster
# We can do basic math with scalars, where "recycling rules"
#	are in effect:
# We'll change the vertical datum of this to start at the 2000m:
highest_hit_raster_2k_datum <- highest_hit_raster - 2000
highest_hit_raster_2k_datum # Notice the axis.
plot(highest_hit_raster_2k_datum)
# How about changing the original raster from meters to feet?
highest_hit_raster_feet <- highest_hit_raster * 3.28084
highest_hit_raster_feet
# Good.  Where is this raster, tho?
inMemory(highest_hit_raster_feet)
fromDisk(highest_hit_raster_feet)
# Interesting.  Raster saw the image was small, so it decided
#	to store the image in main memory, rather than on disk.
# However, bigger files will be stored to disk (even if you
#	don't assign a filename).
# If the files are created on disk, where do they end up?
?rasterOptions
rasterOptions() # Take a look at the options.
# An important option is that "tmpdir" -- this is where raster
#	files are stored if they are too big to fit in memory.  
#	If you are processing big files, and have multiple disks,
#	you may want to consider modifying this.
# Let's modify a few rasterOptions so we can follow
#	what raster is doing.  First, let's set the temp directory
#	to be our working directory so we can more easily see
#	the outputs:
rasterOptions(tmpdir=getwd())
#	We'll also enable a "debugging" mode
#	that forces all rasters to be saved to disk instead of 
#	memory:
rasterOptions(todisk=TRUE)
rasterOptions()
# Recalculate the feet conversion:
highest_hit_raster_feet <- highest_hit_raster * 3.28084
# Notice it was a big slower -- that's because it wrote
#	the output to disk.
fromDisk(highest_hit_raster_feet)
# We can see the filename:
filename(highest_hit_raster_feet)
# And confirm with:
dir()
# The 'raster' package has its own format that is similar
#	to an ENVI file format.  It consists of a binary file
#	(the .gri file) and a header (the .grd file).
# We can confirm this by:
test_raster_format <- raster(filename(highest_hit_raster_feet))
test_raster_format

# We'll set the options back to their defaults:
rasterOptions(default=TRUE)
rasterOptions()

# Back to raster algebra.  Not all math functions
#	will work in a predictable manner, but minimally
#	these functions will:
# +, -, *, /, logical operators such as >, >=, <, ==, ! and functions
# such as abs, round, ceiling, 
# oor, trunc, sqrt, log, log10, exp, cos, sin,
# max, min, range, prod, sum, any, all.

# We can use multiple rasters in a statement. How about
#	calculating the lidar height raster (highest hit return elevation - bare soil return elevation)?
bareearth_raster <- raster("tahoe_lidar_bareearth.tif")
height_raster <- highest_hit_raster-bareearth_raster
height_raster
plot(height_raster)
# We can mix and match -- how about calculating
#	the height in feet?  We have what seems to be
#	two ways of doing this, but one is much faster
#	than the second:
height_raster_feet <- (highest_hit_raster*3.28084)-
  (bareearth_raster*3.28084)
height_raster_feet
# This is much faster:
height_raster_feet <- (highest_hit_raster-bareearth_raster)*3.28084
height_raster_feet
# Why?  Because in the first example, there are three raster calculations
#	that occur: 1) highest_hit_raster*3.28084, 2) bareearth_raster*3.28084,
#	and 3) the difference between 1 and 2.
# In the second case, only two raster calculations occur:
#	1) highest_hit_raster-bareearth_raster, 2) 1 times 3.28084.
# Although the results are the same, the efficiency is not.  Look
#	for chances to simplify the math statements whenever possible.

# Logical statements come in handy.  How about creating a mask
#	of all heights greater than 6 feet (the definition of a "tree"):
tree_mask <- height_raster_feet > 6
tree_mask
plot(tree_mask)

# You can use replacement functions similar to a vector.  Let's
#	make all the trees the same height, 30 feet tall, but leave
#	the rest of the heights alone:
height_raster_feet[tree_mask==1] <- 30
height_raster_feet
plot(height_raster_feet)

# Or just do some basic masking (use NA in masking):
height_raster_feet[tree_mask==1] <- NA
height_raster_feet
plot(height_raster_feet)

# We can compare layers using functions such as
#	min, max, mean, prod, sum, Median, cv, range, any, all.
#	This is applied PIXEL BY PIXEL.
mean_height <- mean(bareearth_raster,highest_hit_raster)
mean_height
plot(mean_height)
min_height <- min(bareearth_raster,highest_hit_raster)
min_height # Should be the same as the bareearth raster.
bareearth_raster <- setMinMax(bareearth_raster)
bareearth_raster

# How about a multi-layer Raster* (brick or stack)?
tahoe_highrez_brick <- brick("tahoe_highrez.tif")
tahoe_highrez_brick <- setMinMax(tahoe_highrez_brick)
tahoe_highrez_brick
# Same basic algebra rules work, except will be applied
#	to each pixel in each layer:
tahoe_highrez_brick_x1000 <- tahoe_highrez_brick*1000
tahoe_highrez_brick_x1000
all_1000s <- bareearth_raster*0+1000
all_1000s
# Recyling rules are used based on the Raster* with
# the most layers.  So:
tahoe_highrez_brick_x1000 <- tahoe_highrez_brick * all_1000s
tahoe_highrez_brick_x1000
# The Raster* was recycled.  We can compare layers the same 
# as before:
# Sum all layers pixel-by-pixel:
tahoe_highrez_brick_sum <- sum(tahoe_highrez_brick)
tahoe_highrez_brick_sum # Notice it's only one layer.



######## RASTER/VECTOR FUSION ########
library("raster")
library("rgdal")
install.packages("spatial.tools")
library("spatial.tools")

# need set up the proper working directory to get access to lecture data
setwd("C:/Users/genin/OneDrive/Documents/UIUC/Courses/Spring 2020/Programming GIS/Lectures and files/Week 12/lecture20_raster_vector_data")

# Say we want to extract raster information at specific 
#	locations, as defined by a vector file.  How do we
#	accomplish this?
?extract
tahoe_highrez_brick <- brick("tahoe_highrez.tif")
#	read the tahoe_highrez_training_points shapefile from the spatial.tools library
tahoe_highrez_training_points <- readOGR(dsn=system.file("external", package="spatial.tools"),layer="tahoe_highrez_training_points")
plotRGB(tahoe_highrez_brick)
plot(tahoe_highrez_training_points,add=TRUE, pch=16, col="yellow")

# We'll extract pixel data at specific POINTS:
?extract
length(tahoe_highrez_training_points)
nlayers(tahoe_highrez_brick)

extracted_data <- extract(x=tahoe_highrez_brick,
      y=tahoe_highrez_training_points)
class(extracted_data)
dim(extracted_data)
extracted_data
# Notice, we just have the pixel values, 1 band per column,
#	1 point per row.  What if we want to retain the cell
#	numbers?

extracted_data_w_cellnum <- extract(x=tahoe_highrez_brick,
	y=tahoe_highrez_training_points,cellnumbers=TRUE)

# cellnumbers are the ID of the cell read from
#	left to right, top to bottom.

# We can return a data frame, instead of a matrix:

extracted_data_w_cellnum <- extract(x=tahoe_highrez_brick,
		y=tahoe_highrez_training_points,
		df=TRUE)

# If we want to link this up with the Spatial*DataFrame coordinates:
extracted_data_w_data <- cbind(extracted_data_w_cellnum,tahoe_highrez_training_points@coords)
names(extracted_data_w_data)

# A point will always return a single value.  What about a polygon?
tahoe_highrez_training_polygons <- 
  readOGR(dsn=system.file("external", package="spatial.tools"),
  layer="tahoe_highrez_training")
plotRGB(tahoe_highrez_brick)
plot(tahoe_highrez_training_polygons,add=TRUE,col="yellow")

extracted_from_poly <- extract(x=tahoe_highrez_brick,
		y=tahoe_highrez_training_polygons)
length(tahoe_highrez_training_polygons)
class(extracted_from_poly)
length(extracted_from_poly)
# Every pixel falling within a polygon is extracted
#	and stored in a list element.
extracted_from_poly
extracted_from_poly[[1]]
# What costitutes a pixel falling within a polygon?
#	We can get more info by storing the weight (the
#	fraction of the pixel covered by a polygon):
extracted_from_poly <- extract(x=tahoe_highrez_brick,
		y=tahoe_highrez_training_polygons,
		weights=TRUE, normalizeWeights = FALSE)
# Values of 1.0 mean the entire pixel was covered
#	by the polygon.  Less than 1.0 mean the pixels
#	were at the edge of the polygon, so they weren't
#	entirely covered.

# A lot of times, we want the mean value per
#	polygon, not the entire polygon.  We can
#	apply a function to the extraction:

extracted_from_poly <- extract(x=tahoe_highrez_brick,
		y=tahoe_highrez_training_polygons,
		fun=mean)

extracted_from_poly 
# Notice only 1 value per band per polygon.

# We can "buffer" the points and treat them as
#	polygons:
extracted_data_buffered <- extract(
  x=tahoe_highrez_brick,y=tahoe_highrez_training_points,
	buffer=5) # buffer is in map units
class(extracted_data_buffered)
length(extracted_data_buffered)

######## YOU NOW KNOW THE CORE OF GIS PROGRAMMING IN R ########

### For the next sections, we are going to start working 
#	on some case studies in using R to solve various
#	GIS problems.

######## RASTER MODELS ########
# First off, R models.  Let's perform a simple linear regression,
#	but using extracted data.
# We are interested in seeing if Lidar derived vegetation 
#	height is linearly related to NDVI:

# Calculate Lidar height:
highest_hit_raster <- raster("tahoe_lidar_highesthit.tif")
bareearth_raster <- raster("tahoe_lidar_bareearth.tif")
lidar_height <- highest_hit_raster - bareearth_raster
plot(lidar_height)
summary(lidar_height)

# Calculate NDVI:
ndvi <- function(x) { (x[1] - x[2])/(x[1] + x[2])}
tahoe_ndvi <- calc(tahoe_highrez_brick,ndvi)

# Extract data using our points vector:
tahoe_highrez_training_points <- readOGR(dsn=
          system.file("external", package="spatial.tools"),
          layer="tahoe_highrez_training_points")

lidar_height_extract <- extract(lidar_height,
      tahoe_highrez_training_points,df=TRUE)
ndvi_extract <- extract(tahoe_ndvi,
      tahoe_highrez_training_points,df=TRUE)

# Let's cbind this thing:
height_vs_ndvi_data <- cbind(ndvi_extract,lidar_height_extract)
# Let's mod the names to make this easier:
names(height_vs_ndvi_data) <- 
  c("ID.1","ndvi","ID.2","lidar_height")
summary(height_vs_ndvi_data)
?plot
plot(height_vs_ndvi_data$ndvi,height_vs_ndvi_data$lidar_height,axes=TRUE)
# Meh, not so great, but then again I wasn't expecting it to be....

# Let's do a simple linear regression:
?lm
# Before we do this, we need to understand
#	R's formula coding.  The generic 
#	format is:
# response variable ~ explanatory variables
# 	or, for our example:
# lidar_height ~ ndvi

ndvi_height_lm <- lm(height_vs_ndvi_data$lidar_height ~ 
      height_vs_ndvi_data$ndvi)
ndvi_height_lm
class(ndvi_height_lm)
summary(ndvi_height_lm)

# Most statistical models in R have a parameter
#	"data" that allows you to set the data frame,
#	and just use the column names in the formula.
#	This makes it a bit easier to write:
ndvi_height_lm <- lm(lidar_height ~ ndvi, 
    data=height_vs_ndvi_data)
# summary() will give us a lot more info:
summary(ndvi_height_lm)
plot(ndvi_height_lm)

# This gives us up to 6 plots:
#	1) Residuals vs. fitted values
# 2) Normal Q-Q plot
#	3) Scale-Location plot of sqrt(residuals) vs. fitted
#	4) Cook's distances vs. row labels
#	5) Residuals vs. leverages
#	6) Cook's distance vs. leverage/1-leverage)
#	By default, #s 1,2,3 and 5 are plotted.

#######


# A key GENERIC function to know is:
?predict
# This is generic function that (typically)
#	takes a statistical model object as
#	an input as well as a set of data to
#	predict on.  
# Each model has different inputs, which we
#	can see by:
?predict.lm

# So, let's create a sequence of 
#	NDVI values and predict the veg height from
#	out model:
ndvi_sequence = data.frame(ndvi=seq(from=-1, to=1, by=0.05))
# You usually need to make sure that the variables are named
#	the same as in the model:
names(ndvi_sequence) <- "ndvi" 
predicted_height <- predict(ndvi_height_lm, newdata = ndvi_sequence)
plot(ndvi_sequence$ndvi,predicted_height)

# Ok, great.  Now comes the fun part.  Let's apply
#	this model to a raster image!

# First off, we need to set the raster layer names
#	to be the same as the variables:
tahoe_ndvi
names(tahoe_ndvi)
names(tahoe_ndvi) <- "ndvi"

# Next, we use predict in a similar way:
tahoe_height_pred <- predict(tahoe_ndvi,ndvi_height_lm)
plot(tahoe_height_pred)
summary(tahoe_height_pred)

# What you just learned is INCREDIBLY hard to do in 
#	ArcGIS, ENVI, Imagine, etc:
#	1) Extract data from a raster at specific points.
#	2) Create a model from the extracted data.
#	3) Apply the model to a 'test' dataset.
#	4) Apply the model to a raster.
# This was TRIVIAL to do in R, and this is one
#	of the chief reasons we use R with GIS!




