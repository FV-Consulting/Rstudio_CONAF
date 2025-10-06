#### GEOG 489: Programming for GIS
#### Chunyuan Diao, chunyuan@illinois.edu
#### Lecture 17: Introduction to Raster 
###		and Visualizing Spatial Data


# Some pre-class announcements:
# Quiz 6 is on Compass and will be due by the end of this Friday (March 27)



######## INTRODUCTION TO THE 'RASTER' PACKAGE ########

### A quick review of rasters
# Remember that rasters (or "grids" or "images") represent, in GIS
# a set of regularly spaced areas ("cells" or "pixels") on the earth's
# surface.  What differentiates them from vectors is that the 
# coordinates of each cell are not stored explicitly.  A raster file
# has two parts: the data, and the header information.

# The data: in R terms, the data is a vector of data, one value per
# 	grid cell.  

# The header: this carries the information needed to define, minimally,
#	a 2- or 3-d image, e.g. the number of columns, rows, and bands and,
# 	in the case of a 3-d image, the interleave (BSQ, BIP, BIL).
#	To put the grid into geographic space, the CRS is defined, the
# 	(typically) coordinate of the upper left cell, and the resolution
#	of the grid must be known. Thus, to determine, say, the geographic 
#	x-coordinates of a single cell given a known column position, 
#	we multiply the column position of the cell times the x resolution, 
#	and add it to the upper left x coordinate.

### The 'raster' package: 'raster' is the defacto standard for raster
#	processing in R.  There are a large number of reasons for this, but
#	I'll mention two right now:
#	1) Chunking/memory management: You don't need to worry about
#		running out of memory when working with even with extremely 
#		large rasters.
#	2) RGDAL support: you don't need to worry about the format
#		of a file you are working with -- all commands will work
#		with essentially all raster formats.
install.packages("raster")
library("raster")

### Raster Classes:
# Raster class: similar to Spatial; contains slots for the number of
#	columns and rows in the raster; the CRS info; and the spatial 
#	extent (similar to the bbox object in Spatial); whether the raster
#	is rotated and what the angle is, and information on the z- values
#	e.g. do they represent wavelengths, times, etc?

getClass("Raster")

#	-- This is inherited by the following classes:

# RasterLayer: a single layer (band) raster
# RasterBrick: a multiband raster originating from a SINGLE file.
# RasterStack: a multiband raster comprised of MULTIPLE files.

### RasterLayer: inherits Raster; but adds a file slot (if the data
#	is stored on disk); data slot (the data itself); legend and history.
# A RasterLayer can be created using:
?raster 

x <- raster() # Default makes a 1 degree raster of the planet.
x
class(x)

x <- raster(ncol=36,nrow=18,xmn=-1000,xmx=1000,ymn=-100,ymx=900)
x # Notice that the resolution was determined based on the 
# ncol, nrow, and extent.
?res
res(x)

# We can change the resolution:
res(x) <- 100
res(x)
x # Notice that the ncol and nrow were adjusted to fit
# this new resolution:
?ncol
ncol(x)
nrow(x)

# We can adjust the number of columns (changing the resolution):
ncol(x) <- 18
ncol(x)
res(x)

# To set the projection of a raster,use the PROJ4 string and:
?projection
x
projection(x) <- "+proj=utm +zone=48 +datum=WGS84"
x

# Note: all of this does nothing more than create a "skeleton"
#	of a raster: no data exists for the raster yet:
r <- raster(ncol=10,nrow=10)
?ncell
ncell(r)
# Does it have data?
?hasValues
hasValues(r)

# We can give it values using
?values
set.seed(0)
values(r) <- runif(ncell(r))
hasValues(r)

# This is a VERY small raster, so the 'raster' package
#	keeps it in memory.  If it was a large raster,
#	it would need to be stored on disk. We can check this:
?inMemory
inMemory(r)

# The values are stored as a vector and can be indexed as such:
values(r)[1:10]

plot(r,main="Raster with 100 cells")

# If we directly or indirectly add or subtract rows or columns,
#	we need to be careful about losing/gaining unwanted data.
hasValues(r)
res(r)
dim(r) # dim() works with rasters!
xmax(r)
# Let's set the xmax to 0 (so only the western hemisphere
#	is represented):
xmax(r) <- 0   
hasValues(r)
res(r)
dim(r) # Nothing was changed with the data, just the
#	geographic referencing.  However...
ncol(r) <- 6
hasValues(r) # We lost the data when we changed the
#	base information.
dim(r)
xmax(r)

library("raster")
### Other ways to create a RasterLayer:
# -- From a file on disk (we'll discuss this soon)
# -- From other Raster* objects
# -- From a SpatialGrids object (sp)
# -- ... and lots of other ways...

### RasterStack: multi-layered Raster from multiple sources
r1 <- r2 <- r3 <- raster(nrow=10,ncol=10)
values(r1) <- runif(ncell(r1))
values(r2) <- runif(ncell(r2))
values(r3) <- runif(ncell(r3))
# We can combine multiple RasterLayer objects using
?stack
s <- stack(r1,r2,r3) 
# The input can also be a list of RasterLayers
s
class(s)
?nlayers(s)
nlayers(s)

### RasterBrick: multi-layered Raster from a single source
# If the layers are in memory, there is no real difference
# between a RasterBrick and RasterStack:
?brick
b1 <- brick(r1,r2,r3)
b1
class(b1)
# We can also convert a RasterStack into a RasterBrick:
b2 <- brick(s)
b2
class(b2)


######## VISUALISING SPATIAL DATA, BIVAND ET AL CHAPTER 3 ########
### We can use plot() for some basic Spatial* plotting, and the
# 'lattice' package for some more complex plotting.

### The Traditional Plot System
library(sp)
data(meuse) # A data frame with x and y coordinates:
summary(meuse)
# Let's make a SpatialPointsDataFrame:
coordinates(meuse) <- c("x","y")
class(meuse)
plot(meuse)
title("points from meuse")

# Now a SpatialLines object (note the order makes a messy zigzag):
cc <- coordinates(meuse)
meuse.SpatialLines <- SpatialLines(list(Lines(list(Line(cc)),ID="oneLine")))
plot(meuse.SpatialLines)
title("lines from meuse")

# Now a SpatialPolygons object:
data(meuse.riv)
meuse.List <- list(Polygons(list(Polygon(meuse.riv)),ID="meuse.riv"))
meuse.SpatialPolygons <- SpatialPolygons(meuse.List)
plot(meuse.SpatialPolygons,col="yellow")
title("polygons from meuse.riv")

# Now a raster:
library(raster)
data(meuse.grid)
summary(meuse.grid)
# We are going to convert from a set of x,y 
# coordinates to a raster:
?rasterFromXYZ
xyz <- data.frame(meuse.grid$x,meuse.grid$y)
xyz$z <- vector(length=length(meuse.grid$x))
meuse.raster <- rasterFromXYZ(xyz)
meuse.raster
# Use the add=TRUE to add multiple layers to the plot:
image(meuse.raster,col="lightgrey")
plot(meuse.SpatialPolygons,col="grey",add=TRUE)
plot(meuse,add=TRUE)

plot(meuse)
image(meuse.raster,col="lightgrey",add=TRUE)

### Axes and Layout Elements
?layout
# This will allow us to plot two maps arranged in columns:
layout(mat=matrix(c(1,2),nrow=1,ncol=2)) 
plot(meuse.SpatialPolygons,axes=TRUE) # Goes to the first column
plot(meuse.SpatialPolygons,axes=FALSE) # Goes to the second column
?axis 
# at = where the tick marks are drawn:
c(178000 + 0:2 * 2000)
# side: where to draw the tick marks, 1 = below, 2 = left, 
#	3 = above, 4 = right.
axis(side=1,at=c(178000 + 0:2 * 2000),cex.axis=0.7)
axis(side=2,at=c(326000 + 0:3 * 4000),cex.axis=0.7)
?box
box()

# We can take finer control over the size of the plots:
?par
oldpar <- par(no.readonly=TRUE)
layout(mat=matrix(c(1,2),nrow=1,ncol=2)) 
plot(meuse,axes=TRUE,cex=0.6)
plot(meuse.SpatialPolygons,add=TRUE)
title("Sample locations")
# mar modifies the plotting margins in units of 
# lines of text.  We'll more or less remove the
# margins:
par(mar=c(0,0,0,0)+0.1) 
plot(meuse,axes=FALSE,cex=0.6)
plot(meuse.SpatialPolygons,add=TRUE)
box()
# Set the graphic parameters back to default:
par(oldpar)

# Note, both of these plots actually use the same 
# amount of space, but the control is allowing you
# to "recoup" the space that, by default, would be
# devoted to the space for axes and titles.




### Degrees in Axes Labels and Reference Grid
library(maptools)
library(maps)
wrld <- map("world",interior=FALSE,xlim=c(-179,179),ylim=c(-89,89),plot=FALSE)
wrld_p <- pruneMap(wrld,xlim=c(-179,179))
llCRS <- CRS("+proj=longlat +ellps=WGS84")
wrld_sp <- map2SpatialLines(wrld_p,proj4string=llCRS)
prj_new <- CRS("+proj=moll")
# Time to install rgdal:
install.packages("rgdal")
library(rgdal)
?spTransform # VERY IMPORTANT FUNCTION
# spTransform is the function for reprojecting Spatial* objects.
# We'll project the world map to Mollweide:
wrld_proj <- spTransform(wrld_sp,prj_new)
summary(wrld_proj)
# Now we are going to overlay grid lines:
?gridlines
# easts and norths are where we want to put the grid lines:
c(-179,seq(-150,150,50),179.5)
seq(-75,75,15)
wrld_grd <- gridlines(wrld_sp,easts=c(-179,seq(-150,150,50),179.5),
		norths=seq(-75,75,15),ndiscr=100)
# ndiscr are the points needed to define the line.  If we are going
#  to reproject the grid lines (which we are), we want to increase the
#  number of points.
wrld_grd_proj <- spTransform(wrld_grd,prj_new)
?gridat
at_sp <- gridat(wrld_sp,easts=0,norths=seq(-75,75,15),offset=0.1)
at_sp@data # These are the labels we are going to use.
at_proj <- spTransform(at_sp,prj_new)

# Now let's plot this stuff:
plot(wrld_proj,col="blue")
plot(wrld_grd_proj,add=TRUE,lty=3,col="black")
text(coordinates(at_proj),pos=at_proj$pos,offset=at_proj$offset,
		labels=parse(text=as.character(at_proj$labels)),cex=0.6)

### Plot size, plotting area, map scale, and multiple plots
# R distinguishes two areas for plotting: the figure region (the 
# entire region where the plot, axes, title, etc go), and the 
# area where only the data is plotted.

?par
# Get the current plot area in inches:
par("pin")
# Set it to 4 by 4 inches:
par(pin=c(4,4))
par("pin")
# We can set the output device (graphics file) size, e.g.:
?pdf
# pdf("file.pdf",width=10,height=10)
# We can fit the graph to EXACTLY the plot area
# via this trick (notice the edge plot symbols are clipped:
pin <- par("pin")
dxy <- apply(bbox(meuse),1,diff)  # x and y range difference
ratio <- dxy[1]/dxy[2]
par(pin=c(ratio*pin[2],pin[2]),xaxs="i",yaxs="i") # the limits lie at the edges of the plot area
plot(meuse,pch=1)
box()

#####

