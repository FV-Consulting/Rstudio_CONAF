#### GEOG 489: Programming for GIS
#### Chunyuan Diao, chunyuan@illinois.edu
#### Lecture 16: Classes for Spatial Data in R (Vector)


# Some pre-class announcements:.

#  Assignment 4 is due today, March 24, 2020 at midnight
#  Package introduction PPT is due by March 31. Please submit your PPT on Compass.

# -- IF YOU HAVE NOT TAKEN GIS BEFORE: the easiest way to 
#     get up to speed is to go run through some ArcGIS
#     tutorial (lots of books and online sources). 


######## INTRODUCTION TO GIS PROGRAMMING ########

# Recall that, in GIS, we generally deal with four types of data models:
# 1) Points: a single location, given by a 2- or 3-d coordinate.
# 2) Lines: a set of ordered points connected by straight line segments.
# 3) Polygons: an area, comprised of a set of enclosing lines
# 4) Rasters (aka "grids" aka "images"): a set of regularly spaced 
#	rectangles, arranged in a lattice.  

# Points, lines, and polygons are referred to as "vector data models"
#	and share commonalities in terms of how they are constructed
#	and dealt with in R.

# Grids are a "raster data model", and are stored and accessed in a 
# 	very different way than vectors.  Note that although a raster
#	represents an ordered set of areas, it is not stored as a set
#	of vector polygons (although it could be).  The basic component
#	of a raster is a "pixel" or a "cell".

# GIS data can be linked to a table of attributes (an arbitrarily
#	complex database) through an ID given to each unique entity (a 
#	single point, a single line, a single polygon, or a single pixel)
#	that is also contained within a database.

# R has a LOT of packages available to do spatial analysis:
# http://cran.r-project.org/web/views/Spatial.html

# At the core of R's spatial analysis is the package sp:
install.packages("sp")
help(package="sp")
# This packages contains the core classes and methods for
# spatial data, PRIMARILY vector data.  

# For doing raster analysis, we will use the raster package:
install.packages("raster")
help(package="raster")

# An incredibly powerful and helpful package is rgdal.
# This package allows for import/export of almost any
# vector or raster format, without you having to worry
# about the nuances of each different format.  
# This is actually a wrapper for the 
# Geospatial Data Abstraction Library
# http://gdal.org/
install.packages("rgdal")
help(package="rgdal")

# We will see other packages as we work through the chapters and examples, but these
# three packages (sp, raster and rgdal) will serve as the
# core of what we will be doing!


######## CLASSES FOR SPATIAL DATA IN R, BIVAND ET AL CHAPTER 2 ########

# The data files can be downloaded from compass

library("sp")
help(package="sp")

### Spatial Objects
# The core of a vector spatial object is the class "Spatial".
# This class has only two slots:
#	- a bounding box of class "matrix": 
#		column names "min " and "max"; first row eastings (x-axis);
#		second row northings (y-axis)
#	- a coordinate reference system of class "CRS"
getClass("Spatial")
# Notice how many subclasses inherit this basic spatial class.

# We will learn more about CRS objects later, but a CRS object:
getClass("CRS") # just has a single character string as a slot.
# This character string represents PROJ.4 formatted strings.
# A really simple string representing geographical coordinates
# would be "+proj=longlat" 

# Let's make a simple Spatial object:
# First make a bounding box:
myBoundingBox <- matrix(c(0,0,1,1),ncol=2,
	dimnames=list(NULL,c("min","max")))
myBoundingBox

# We can leave the CRS blank:
?CRS
myCRS <- CRS(projargs = as.character(NA))
myCRS 

# Then we can create a spatial object using Spatial():
?Spatial
mySpatialObject <- Spatial(bbox=myBoundingBox,
    proj4string=myCRS)
mySpatialObject

### SpatialPoints
# Points are the most basic way of describing geographic data.
# They fundamentally are just two coordinates (x,y).  We will
# starts with geographic coordinates, which represent the angles
# east of (e.g.) the Prime Meridian and angles north of the equator.
# x, then, ranges from 0 to 360 (or -180 to 180), and y ranges from
# -90 (south pole) to 90 (north pole).

# Let's read the positions of CRAN051001a.txt.
# CRAN051001a.txt includes CRAN mirrors (when you install a package
# in R, that list you see are the mirrors):
cran_file <- file.choose()
# setwd(file.choose())
CRAN_df <- read.table(cran_file,header=TRUE)
summary(CRAN_df) # Note the long and lat columns.
# Let's make a matrix of the coordinates:
CRAN_mat <- cbind(CRAN_df$long, CRAN_df$lat)
# Create an index using row_names:
row.names(CRAN_mat) <- as.character(1:nrow(CRAN_mat))
CRAN_mat
str(CRAN_mat)

# A SpatialPoints class EXTENDS the Spatial class by adding
# a slot called "coords", which is a matrix of point coordinates:
getClass("SpatialPoints")
# Small note: pluralization MATTERS with some spatial classes.  We'll 
# see some examples of this later.  However, there is no "SpatialPoint"
# class in R.

# This dataset uses a Geographic Projection with a WGS84 ellipsoid:
CRAN_CRS <- CRS("+proj=longlat +ellps=WGS84")
# Now we make a SpatialPoints object:
?SpatialPoints
CRAN_SpatialPoints <- SpatialPoints(coords=CRAN_mat,proj4string=CRAN_CRS)
CRAN_SpatialPoints
summary(CRAN_SpatialPoints)
# Notice that we didn't need to "manually" assign the bounding box, it
# was calculated based on the points.

### SpatialPoints methods
# If we want to retrieve the bounding box, we use the Method bbox:
?bbox
bbox(CRAN_SpatialPoints)
class(bbox(CRAN_SpatialPoints))

# Or if we want to grab the projection string:
?proj4string
proj4string(CRAN_SpatialPoints)
class(proj4string(CRAN_SpatialPoints))
# We can modify (or "erase") the CRS:
  proj4string(CRAN_SpatialPoints) <- CRS(as.character(NA))
  proj4string(CRAN_SpatialPoints)

# We can extract the coordinate out as a matrix:
coordinates(CRAN_SpatialPoints)
class(coordinates(CRAN_SpatialPoints))

# Say we want to look at just points that were from Brazil:
summary(CRAN_df)
brazil_indices <- which(CRAN_df$loc == "Brazil")
brazil_indices

# We can use this to subset the coordinates (since it is just a matrix):
coordinates(CRAN_SpatialPoints)[brazil_indices,]

# But sp allows us to use this directly on the object:
CRAN_SpatialPoints[brazil_indices,]

# We can query the points directly and also use negative
# indices (which, remember, are used to exclude):
# Note the coordinates(CRAN_SpatialPoints)[,2] used column
# 2 because that is the y-coordinate.
south_of_equator_indices <- which(coordinates(CRAN_SpatialPoints)[,2] < 0)
CRAN_SpatialPoints[-south_of_equator_indices,]



### SpatialPointsDataFrame
# So far, we have only been working with "raw points" that have
# no attribute data.  What if we want to now construct something
# more akin to a shapefile, where we have geographic information
# linked to a table?  Data Frames come to the rescue, and we
# get a new class called SpatialPointsDataFrame that is basically
# a SpatialPoints object with a linked data frame:
getClass("SpatialPoints")
getClass("SpatialPointsDataFrame")
?SpatialPointsDataFrame
# Let's create one:
CRAN_mat
CRAN_df
CRAN_SpatialPointsDataFrame1 <- 
  SpatialPointsDataFrame(coords=CRAN_mat,data=CRAN_df,
                         proj4string=CRAN_CRS,match.ID=TRUE)
# How does it link the points to the data frame? 
# when match.ID=TRUE, rownames are used from both the
# coordinates matrix and the data frame to link the two
# together.  If match.ID=FALSE, sp will just assume
# the coordinates and data frame are pre-ordered (which
# might be unsafe).  

summary(CRAN_SpatialPointsDataFrame1)
# Notice the long and lat are present in the Data-- this is not
# because sp is duplicating the coordinate information, rather, 
# because CRAN_df contained two columns named "long" and "lat".

# We can use the data frame notation to look at a single point:
CRAN_SpatialPointsDataFrame1[4,]

# And we can look at the attributes just like we would a data frame:
CRAN_SpatialPointsDataFrame1$loc
CRAN_SpatialPointsDataFrame1[4,]$loc

# Let's look more carefully at the match.ID:
rownames(CRAN_df)
rownames(CRAN_mat)

# We'll randomly order the data frame:
s <- sample(nrow(CRAN_df))
CRAN_df_reordered <- CRAN_df[s,]
rownames(CRAN_df_reordered)

# Let's make a new SpatialPointsDataFrame but keep match.ID=TRUE
CRAN_SpatialPointsDataFrame2 <- 
  SpatialPointsDataFrame(coords=CRAN_mat,data=CRAN_df_reordered,
                         proj4string=CRAN_CRS,match.ID=TRUE)
CRAN_SpatialPointsDataFrame1[4,]
CRAN_SpatialPointsDataFrame2[4,]
CRAN_df_reordered[4,]
# Notice they stayed the same, because we didn't reorder the points,
# so the rownames were used to match the points to the data frame.

# But what if we set match.ID=FALSE:
CRAN_SpatialPointsDataFrame3 <- 
		SpatialPointsDataFrame(coords=CRAN_mat,data=CRAN_df_reordered,
				proj4string=CRAN_CRS,match.ID=FALSE)
CRAN_SpatialPointsDataFrame3[4,]
CRAN_df_reordered[4,]
# The points were linked up in the order of the data frame, not 
# by matching the rownames.

# SpatialPointsDataFrame tries to act like a data frame as much
# as possible:
names(CRAN_SpatialPointsDataFrame1)


# There are some easy ways to build up a SpatialPointsDataFrame.  We could 
# use a SpatialPoints object as the coordinates, rather than a matrix:
summary(CRAN_SpatialPoints)
CRAN_SpatialPointsDataFrame4 <- SpatialPointsDataFrame(coords=
				CRAN_SpatialPoints,data=CRAN_df)
summary(CRAN_SpatialPointsDataFrame4)

# We can also directly assign points to a data frame 
# (converting it to a SpatialPointsDataFrame in the process):

CRAN_df_new <- CRAN_df
class(CRAN_df_new)
coordinates(CRAN_df_new) <- CRAN_mat
class(CRAN_df_new)
summary(CRAN_df_new)
# Don't forget to assign the projection info:
proj4string(CRAN_df_new) <- CRAN_CRS
all.equal(CRAN_df_new,CRAN_SpatialPointsDataFrame1)
str(CRAN_df_new)

# We can also call a data frame's coordinate columns directly, 
# by using a vector of column names to represent the x and y
# coordinates, but be aware this has some implications:
CRAN_df_new2 <- CRAN_df
names(CRAN_df_new2)
coordinates(CRAN_df_new2) <- c("long","lat")
proj4string(CRAN_df_new2) <- CRAN_CRS
names(CRAN_df_new2) 
# Notice that the long and lat columns are gone from the data
# frame -- this is a "cleaning" function so you don't duplicate
# the coordinates.  The columns from the data frame that
# were used for the coordinates show up in the coords.nrs slot:
str(CRAN_df_new2)

# Let's look at an example where we have turtle transect data,
#  which tracks a single Loggerhead turtle from Mexico to 
#  Japan:
# use setwd() to set the working directory that contains the data
getwd()
setwd("C:/Users/Gustavo/Documents/UIUC/Courses/Spring 2020/Programming GIS/Lectures and files/Week 9/Lecture16_Data")
turtle_df <- read.csv("seamap105_mod.csv")
summary(turtle_df)
class(turtle_df$obs_date)
# We want to order the points by date/time.  
# Date/time functions are VERY useful, but take
# some getting used to.  In brief, computers
# represent (at the core) dates and times as 
# "Seconds since some reference date".  Different
# operating systems and programs use different 
# reference dates, as an FYI.  Because dates and times
# can be distributed in so many different formats,
# we need to use a helper function to coerce it to an
# R date object:

# First convert the time column to a character:
turtle_obs_date_character <- as.character(turtle_df$obs_date)
# The format represents how the data is formatted in the character.
# See:
?strptime # for what these codes mean:
turtle_obs_date_strptime <- strptime(x=turtle_obs_date_character,
		format="%m/%d/%Y %H:%M:%S")
?as.POSIXlt	
# Set an origin date/time zone:
timestamp <- as.POSIXlt(turtle_obs_date_strptime,origin="GMT")

# Now merge this with our original data frame:
turtle_df1 <- data.frame(turtle_df,timestamp=timestamp)
summary(turtle_df1)

# Take a look at the numerical data underpinning this object:
unclass(turtle_df1$timestamp)

# Notice the longitude is using x = -180 to 180 format.  This
# is generally fine, but for plotting this will cause problems.
# Let's convert the longitude to run between 0 and 360:
turtle_df1$lon <- ifelse(turtle_df1$lon <0, turtle_df1$lon + 360, turtle_df1$lon)
summary(turtle_df1)
# Now we can order the data by timestamp:
turtle_sp <- turtle_df1[order(turtle_df1$timestamp),]
coordinates(turtle_sp) <- c("lon","lat")
proj4string(turtle_sp) <- CRS("+proj=longlat +ellps=WGS84")
plot(turtle_sp)
summary(turtle_sp)

### Summary so far:
# Spatial : bounding box and coordinate reference system
# SpatialPoints: Spatial + coordinates
# SpatialPointsDataFrame: SpatialPoints + data frame

library("sp")
help(package="sp")

### SpatialLines
# Install some new packages:
install.packages("maps") # Display of maps
# Various geographic tools particularly applied to ESRI files:
install.packages("maptools") 

# Pay attention to singular/plural class names for lines and polygons:
library("sp")
getClass("Line") # A SINGLE line (can have multiple arcs)
getClass("Lines") # Multiple Line objects arranged in a list with a single ID
getClass("SpatialLines") # a Spatial object + a list of Lines objects

# We'll import a map as a SpatialLines object
library("maps")
library("maptools")
?map
japan <- map("world","japan",plot=FALSE)
p4s <- CRS("+proj=longlat +ellps=WGS84")
?map2SpatialLines
SLjapan <- map2SpatialLines(japan,proj4string=p4s)
plot(SLjapan)
class(SLjapan)

# Let's look at this object at multiple depths:
str(SLjapan,max.level=2) # Three slots, lines, bbox, proj4string
str(SLjapan,max.level=3) # Note that the lines slot is a list of "Lines" objects
str(SLjapan,max.level=5) # Note that each Lines object has two slots: a list and an ID
str(SLjapan,max.level=6) # Note that each Lines list has a "Line" object


# The lines slot:
SLjapan_lines <- slot(SLjapan,"lines") # same as SLjapan@lines
class(SLjapan_lines) # actually a list of Lines
class(SLjapan_lines[[1]])
# A Lines can, in theory, have multiple (potentially unconnected) single lines.
# We can check to see how many individual Line objects are in each Lines by:
Lines_len <- sapply(slot(SLjapan,"lines"),
		function(x) length(slot(x,"Lines")))
table(Lines_len)

# A single line segment:
SLjapan_lines # "SpatialLines" object
SLjapan_lines[[1]] # "Lines" object
SLjapan_lines[[1]]@Lines # List object
SLjapan_lines[[1]]@Lines[[1]] # "Line" object
SLjapan_lines[[1]]@Lines[[1]]@coords # Matrix of coordinates

### SpatialLinesDataFrame
# Each Lines object can be linked to an attribute:
# Volcano is a built-in dataset:
?contourLines # Notice this is a grDevice function, not a spatial one
?ContourLines2SLDF # Convert the contourlines to a SpatialLinesDataFrame
volcano_sl <- ContourLines2SLDF(contourLines(volcano))
plot(volcano_sl)
class(volcano_sl)
# We can look at the linked data frame:
t(volcano_sl@data)

Lines_len <- sapply(slot(volcano_sl,"lines"),
		function(x) length(slot(x,"Lines")))

table(Lines_len)
# Another importing example:
llCRS <- CRS("+proj=longlat +ellps=WGS84")
?MapGen2SL
auck_shore <- MapGen2SL("auckland_mapgen.dat",llCRS)
summary(auck_shore)
plot(auck_shore)

### Summary of SpatialLines:
# Spatial : bounding box and coordinate reference system
# Line: a single connected set of arcs, defined by the coordinates of 
#	their nodes.
# Lines: a list of Line objects that share a SINGLE ID.
#	In ESRI terminology, this represents a "multipart line".
#	This is the level that is linked to a data frame.
# SpatialLines: Spatial + a list of Lines
# SpatialLinesDataFrame: SpatialLines + data frame linked to the Lines IDs

### SpatialPolygons:
# Recall that a polygon is essentially just a line except the last coordinate
#	must be the same as the first coordinate.

# Going back to our auck_shore (which was a SpatialLines object):
lns <- slot(auck_shore, "lines") # Pull the list of Lines out
table(sapply(lns,function(x) length(slot(x,"Lines")))) 
# This tells us that the lines slot in auck_shore has 80 Lines objects,
#	each of which contain a single Line.

# We can check for islands as Lines in which the first coordinate
#	of the Line matches the last coordinate:
islands_auck <- sapply(lns,function(x)
		{
			# Pull out the Line coordinates from the first Lines
			#	entry:
			crds <- slot(slot(x,"Lines")[[1]],"coords")	
			# Are the first coordinates equal to the last coordinates?
			identical(crds[1,],crds[nrow(crds),])
		}
)
table(islands_auck) # 64 of the lines in auck_shore are islands

# Let's look at how to build Polygons:
getClass("Polygon")
# This class extends a basic Line in the following ways:
#	1) The Line is confirmed to have the first and last coordinates be equal
#	2) A label point, defined at the centroid of the polygon
#	3) The area of the polygon in the units of the coordinates
#	4) Whether the polygon is a hole (NA by default)
#	5) Ring direction of the polygon
#		These last two deal with topological issues, see 
#		Section 2.6.2 in your text for more information.

getClass("Polygons")
# This is a list of individual Polygon objects, and from a GIS standpoint,
#	is the unit of attribution.  The slots are as follows:
#	1) A list of Polygon objects.
#	2) The order the polygons should be plotted (if > 1 Polygon)
#	3) A label point (the centroid of the largest Polygon)
#	4) An ID (to be linked to the attribute table)
#	5) The total area of all individual Polygon objects.

getClass("SpatialPolygons")
# Fuses a standard Spatial object with a list of Polygons (which, in turn, are a list
#	of individual Polygon objects).  It also contains as plotOrder slot for display
#	purposes (i.e. if two polygons overlap, which is on top?)

# Let's pull out the island subset of the Auckland Shoreline:

plot(auck_shore)
islands_sl <- auck_shore[islands_auck]
plot(islands_sl)
# Notice these are still SpatialLines:
class(islands_sl)  
# We'll pull out just the list of Lines from this:
list_of_Lines <- islands_sl@lines
list_of_Lines[[1]]

# We'll do some lapply magic to make this into a SpatialPolygons object.
# First, let's convert each individual Line to a Polygon, then to a Polygons,
#	then to a list of Polygons:
list_of_Polygons <- lapply(list_of_Lines,function(x)
		{
			# Convert the first (and only) Line in the Lines to a Polygon:
			single_Line <- x@Lines[[1]]@coords
			single_Line_ID <- x@ID
			single_Polygon <- Polygon(coords=single_Line)
			single_Polygons <- Polygons(list(single_Polygon),ID=single_Line_ID)
		})

islands_sp <- SpatialPolygons(list_of_Polygons,
		proj4string=CRS("+proj=longlat +ellps=WGS84"))
summary(islands_sp)
plot(islands_sp) # Looks the same as the SpatialLines version...

# for example: for the first Lines object of list_of_Lines
# single_Line <- list_of_Lines[[1]]@Lines[[1]]@coords
# single_Line_ID <- list_of_Lines[[1]]@ID

### SpatialPolygonsDataFrame
# Just like SpatialPoints and SpatialLines, we can add a data frame
#	that is linked up against an individual Polygons' ID.

library(maps)
library(maptools)
map("state", plot=TRUE)
state.map <- map("state",fill=TRUE, plot=FALSE)
# Let's define IDs based on the state name:
state.map$names # Notice some of these have subregions
IDs <- sapply(strsplit(state.map$names,":"),function(x) x[1])
IDs
state.sp <- map2SpatialPolygons(state.map, IDs=IDs,
                                proj4string=CRS("+proj=longlat +ellps=WGS84"))
plot(state.sp)
class(state.sp)

# Let's link the mean SAT scores from 1999 to this:
sat <- read.table("state.sat.data_mod.txt",row.names=5,header=TRUE)
state.spdf <- SpatialPolygonsDataFrame(state.sp,sat)
# Hmm, something went wrong...  let's check the IDs vs.
#	the row names and make sure there aren't any mismatches:
good_ids <- match(row.names(sat),IDs)
good_ids # Notice the NAs. Let's see what IDs those are:
row.names(sat)[is.na(good_ids)]
IDs 
# Yep, alaska, hawaii and usa are missing from the SpatialPolygons IDs
sat_good_ids <- sat[!is.na(good_ids),]
sat_good_ids
state.spdf <- SpatialPolygonsDataFrame(state.sp,sat_good_ids)
state.spdf@data

### Summary of SpatialPolygons:
# Spatial : bounding box and coordinate reference system
# Polygon: a single connected set of arcs, defined by the coordinates of 
#	their nodes, having the first and last nodes being identical.
#	Also, slots for whether the polygon is a hole and what the
#	ring direction is (clockwise or anti-clockwise).
# Polygons: a list of Polygon objects that share a SINGLE ID.
#	In ESRI terminology, this represents a "multipart polygon".
#	This is the level that is linked to a data frame.
# SpatialPolygons: Spatial + a list of Polygons
# SpatialPolygonsDataFrame: SpatialPolygons + data frame linked to the Polygons IDs

