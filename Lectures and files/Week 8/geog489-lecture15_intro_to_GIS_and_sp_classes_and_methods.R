#### GEOG 489: Programming for GIS
#### Chunyuan Diao, chunyuan@illinois.edu
#### Lecture 15: Classes for Spatial Data in R (Vector)


# Some pre-class announcements:.
# Assignment 4 is online. It is due by Tuesday, March 24, 2020 at midnight
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
# find all the points in the northern hemisphere
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



### Summary so far:
# Spatial : bounding box and coordinate reference system
# SpatialPoints: Spatial + coordinates
# SpatialPointsDataFrame: SpatialPoints + data frame



