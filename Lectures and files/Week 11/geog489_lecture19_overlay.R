#### GEOG 489: Programming for GIS
#### Chunyuan Diao
#### Lecture 19: Overlay


# Some pre-class announcements:
# Assignment 5 has been posted on Compass (due Thursday, April 16, 2020)


######## FURTHER METHODS FOR HANDLING SPATIAL DATA, BIVAND CHAPTER 5 ########

### Overlays and Spatial Queries
# Recall that a spatial query is essentially a binary problem,
#	Target layer: the layer to extract data FROM
#	Source layer: the layer that is used to determine the 
#		selection from the target layer based on some 
#		spatial relationship.

library(sp)
?"over-methods"

# sp provides basic spatial querying.
# We'll make some polygons (this is from the example for ?overlay
r1 = cbind(c(180114, 180553, 181127, 181477, 181294, 181007, 180409, 
             180162, 180114), c(332349, 332057, 332342, 333250, 333558, 333676, 
                                332618, 332413, 332349))
r2 = cbind(c(180042, 180545, 180553, 180314, 179955, 179142, 179437, 
             179524, 179979, 180042), c(332373, 332026, 331426, 330889, 330683, 
                                        331133, 331623, 332152, 332357, 332373))
r3 = cbind(c(179110, 179907, 180433, 180712, 180752, 180329, 179875, 
             179668, 179572, 179269, 178879, 178600, 178544, 179046, 179110),
           c(331086, 330620, 330494, 330265, 330075, 330233, 330336, 330004, 
             329783, 329665, 329720, 329933, 330478, 331062, 331086))

sr1=Polygons(list(Polygon(r1)),"r1")
sr2=Polygons(list(Polygon(r2)),"r2")
sr3=Polygons(list(Polygon(r3)),"r3")
sr=SpatialPolygons(list(sr1,sr2,sr3))
srdf=SpatialPolygonsDataFrame(sr, data.frame(cbind(1:3,5:3), row.names=c("r1","r2","r3")))
plot(srdf)

data(meuse)
coordinates(meuse) = ~x+y

# Show the points and the polygons:
plot(meuse)
polygon(r1)
polygon(r2)
polygon(r3)

?over
# x is SpatialPointsDataFrame; y is SpatialPolygonsDataFrame
srdf@data # Poly data
head(meuse@data) # Point data
row.names(meuse)
over(meuse,srdf)
# The output is, for each point, the data frame of the
#	polygon it intersected.


# x is SpatialPolygonsDataFrame; y is SpatialPointsDataFrame
over(srdf, meuse,fn = mean)
# The output is, for each polygon, the fn (in this case, mean) 
#	value of the data frame of the points falling within it.

### sp's overlays functions are pretty rudimentary...  
#	what if you want more complex spatial querying?  
#	New package time!
# RGEOS is a wrapper to the Interface to Geometry Engine 
#	- Open Source (GEOS).  Like GDAL/OGR and PROJ.4, these
#	libraries are C code that are stored someplace on your
#	system (or may need to be installed by hand).  GEOS
#	is VERY fast.  rgeos links sp objects to GEOS' processing.

install.packages("rgeos")
help(package="rgeos")
library("rgeos")

# This has most of the vector spatial geoprocessing
#	you are used to.  For instance...

### Buffer
data(meuse)
coordinates(meuse) = ~x+y
summary(meuse)
# Let's buffer these out 100 unit (units of coordinates):
meuse_buffer <- gBuffer(meuse,width=100)
summary(meuse_buffer) # Now a SpatialPolygons!
plot(meuse)
plot(meuse_buffer,add=TRUE) # Notice the polygons were dissolved.
meuse_buffer_individual <- gBuffer(meuse,width=100,byid=TRUE)
plot(meuse)
plot(meuse_buffer_individual,add=TRUE) # Each one is separate.

### Distance between objects:
distance_matrix <- gDistance(meuse,meuse,byid=TRUE)
distance_matrix
diag(distance_matrix) # All zeroes, comparing the points
#	to themselves.

# Here is a rough comparison guide of Arc's select
#	by location vs. rgeos' functions:

# Intersect: ?gIntersection()
# Are within a distance of: ?gWithinDistance()
# Are within: ?gCoveredBy()
# Are completely within: ?gWithin()
# Contain: ?gContains()
# Completely contain: ?gCovers()
# Have their centroid in: ?gCentroid() + ?gIntersection() 
# Share a line segment with: ?gTouches()
# Touch the boundary of: ?gTouches()
# Are identical to: ?identical()
# Are crossed by the outline of: ?gCrosses()
# ... and many more.  

### Spatial Sampling
# If you are planning on doing spatial field
# work, proper spatial sampling is an important
# skill to have.  
library(sp)
?spsample
# This allows you to perform spatial sampling
#   of point locations within a bounding box,
#	grid, polygon, or on a line; given random
#	or regular sampling.

plot(srdf)
points(spsample(srdf, n = 100, "regular"), pch = 3)
# Plots N=100, regularly spaced points falling within the meuse.sr 
#	SpatialPolygon.

plot(srdf)
points(spsample(srdf, n = 100, "random"), pch = 3)
# Plots N=100, random points falling within the meuse.sr 
#	SpatialPolygon.

plot(srdf)
points(spsample(srdf, n = 100, "stratified"), pch = 3) 
# Plots N=100, stratified points falling within the meuse.sr 
#	SpatialPolygon.

######## RASTER MODIFICATION ########
# 'raster' provided a suite of tools for modifying the 
# 	spatial configuration of a Raster* object.
library("raster")

### Reprojecting a Raster*.
# To reproject a raster, we use 
?projectRaster
# Note that this is the raster equivalent of
?spTransform

# projectRaster
# Say we want to project our Lidar data to UTM zone 11:
setwd("C:/Users/genin/OneDrive/Documents/UIUC/Courses/Spring 2020/Programming GIS/Lectures and files/Week 11/geog489_lecture19_overlay_data")    ### need change it to your working directory

highest_hit_raster <- raster("tahoe_lidar_highesthit.tif")

# Let's create a CRS string:
utm_zone_11_crs <- CRS("+proj=utm +zone=11 +ellps=WGS84 +datum=WGS84 +units=m +no_defs")

# We can project a raster using this CRS:
highest_hit_raster_utm <- projectRaster(from=highest_hit_raster,crs=utm_zone_11_crs)
highest_hit_raster_utm # The pixel resolution was kept as close to the original as possible.
plot(highest_hit_raster_utm)
# Let's control the pixel resolution:
highest_hit_raster_utm <- projectRaster(from=highest_hit_raster,crs=utm_zone_11_crs,
		res=c(0.5,0.5))
highest_hit_raster_utm
plot(highest_hit_raster_utm)
# By default, resampling is done via bilinear.  We can do nearest neighbor by:
highest_hit_raster_utm <- projectRaster(from=highest_hit_raster,crs=utm_zone_11_crs,
		res=c(0.5,0.5),method="ngb")
highest_hit_raster_utm
plot(highest_hit_raster_utm)

# We can also use a reference raster to project.  Let's 
# use another raster as a reference:
bareearth_raster <- raster("tahoe_lidar_bareearth.tif")
bareearth_raster

highest_hit_raster_ll <- projectRaster(from=bareearth_raster,
		to=highest_hit_raster_utm)
highest_hit_raster_ll # Notice the res and CRS are the same.

### Cropping and expanding a Raster*.
# To crop a raster, use:
?crop
# We need to use an "Extent" object to define the crop rectangle:
?extent
hh_extent <- extent(highest_hit_raster)
# Let's crop out the bottom left:
middle_x <- mean(c(hh_extent@xmin,hh_extent@xmax))
middle_y <- mean(c(hh_extent@ymin,hh_extent@ymax))
bottomleft <- hh_extent
bottomleft@xmax <- middle_x
bottomleft@ymax <- middle_y
bottomleft
hh_bottomleft <- crop(highest_hit_raster,bottomleft)
plot(highest_hit_raster)
plot(hh_bottomleft,add=TRUE,col="lightgrey")
plot(hh_bottomleft)

# To extend a raster (add pixels to the edges), we use:
?extend
# Let's add 10 pixels to each side.  First we need
# to know the resolution:
hh_res <- res(highest_hit_raster)
hh_res
# So to add 10 pixels, we need to add/subtract a buffer of:
hh_10_pixels <- hh_res * 10 
hh_extent <- extent(highest_hit_raster)
hh_extent_10_pixels <- hh_extent
hh_extent_10_pixels@xmin <- hh_extent@xmin - hh_10_pixels[1]
hh_extent_10_pixels@xmax <- hh_extent@xmax + hh_10_pixels[1]
hh_extent_10_pixels@ymin <- hh_extent@ymin - hh_10_pixels[2]
hh_extent_10_pixels@ymax <- hh_extent@ymax + hh_10_pixels[2]
hh_extent_10_pixels
hh_extend <- extend(highest_hit_raster,hh_extent_10_pixels)
hh_extend # Notice the size of the raster is now 420x420
plot(hh_extend)

### Changing pixel sizes.
# To make pixels larger, use 
?aggregate
highest_hit_raster
# We have to define a function to use to aggregate
# 	higher resolution (smaller) cells into the lower
#	resolution (larger cell), for instance, the mean:
highest_hit_raster_lower <- aggregate(x=highest_hit_raster,
		fact=4,fun=mean)
highest_hit_raster_lower # The pixels were made larger by a factor of 4.
plot(highest_hit_raster_lower)

# To make pixels smaller, use:
?disaggregate
highest_hit_raster_higher <- disaggregate(
		x=highest_hit_raster,fact=2)
highest_hit_raster_higher # Twice the pixels!  
#  This uses bilinear interpolation.
plot(highest_hit_raster_higher)

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
# Adding scalars to a raster:
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
#	calculating the lidar height raster?
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

