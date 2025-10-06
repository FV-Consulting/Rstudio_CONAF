#### GEOG 489: Programming for GIS
#### Chunyuan Diao, chunyuan@illinois.edu
#### Lecture 18: Plotting (Continued) and Spatial Data Import and Export

# Some pre-class announcements:
#  Package introduction PPT is due by the end of today. Please submit your PPT on Compass.




######## VISUALISING SPATIAL DATA, BIVAND ET AL CHAPTER 3 CONTINUED ########

### The Traditional Plot System
install.packages("sp")
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
meuse.SpatialLines <- SpatialLines(
  list(Lines(list(Line(cc)),ID="oneLine")))
plot(meuse.SpatialLines)
title("lines from meuse")

# Now a SpatialPolygons object:
data(meuse.riv)
meuse.List <- list(Polygons(
  list(Polygon(meuse.riv)),ID="meuse.riv"))
meuse.SpatialPolygons <-
  SpatialPolygons(meuse.List)
plot(meuse.SpatialPolygons,col="yellow")
title("polygons from meuse.riv")

# Now a raster:
install.packages("raster")
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

######

### Plotting attributes and map legends
# Let's make a grid of the soil types from meuse.grid:
library(raster)
data(meuse.grid)

xyz <- data.frame(meuse.grid$x,meuse.grid$y,meuse.grid$soil)
meuse.raster <- rasterFromXYZ(xyz)
meuse.raster
# We'll plot the three soil types using a rainbow pallette:
soil_colors <- rainbow(3)
image(meuse.raster,col=rainbow(3),breaks=c(0,1,2,3))
plot(meuse.SpatialPolygons,add=TRUE)
# Scale the points with the value of the zinc column:
meuse$zinc
plot(meuse,pch=1,cex=sqrt(meuse$zinc)/20,add=TRUE)
# Now make a legend for the points:
legVals <- c(100,200,500,1000,2000)
?legend
legend("left",legend=legVals,pch=1,pt.cex=sqrt(legVals)/20,bty="n", y.intersp=0.5,
		title="measured zinc")
# And a legend for the soil
soilVals <- c("Soil A","Soil B","Soil C")
legend("topleft",legend=soilVals,fill=soil_colors,bty="n", y.intersp=0.6,title ="Soil Types")


### Trellis/Lattice Plots with spplot
# spplot uses lattice graphics rather than plot graphics.
# lattice is a more complicated plotting system, but can
# be extended more than plot can.

?spplot
spplot(meuse) # A few warnings but...
# Notice this plotted all columns in meuse:
summary(meuse)
# We can control this by controlling the data columns:
spplot(obj=meuse,zcol=c("lead","zinc","cadmium","copper"))
# We can fine-control the way these plot, check the help.

### Interacting with plots
# R's interaction with plots/spplots is fairly limited.
# There are essentially two functions:
?locator # Returns the x,y positions of the clicked location
?identify # Plots and returns the labels of the items
#	nearest to the point clicked.
plot(meuse)
meuse.id <- identify(coordinates(meuse))
# Esc to finish choosing points
meuse.id

# We can select points using a digitized polygon:
plot(meuse)
region <- locator(type="o")
# Draw a polygon, Esc finish when done:
n <- length(region$x)
p <- Polygon(cbind(region$x,region$y)[c(1:n,1),],hole=FALSE)
ps <- Polygons(list(p),ID="region")
sps <- SpatialPolygons(list(ps))
plot(meuse[!is.na(over(meuse,sps)),],pch=24,cex=0.5,add=TRUE)
plot(sps,add=TRUE)
# To select a polygon:
library(maptools)
prj <- CRS("+proj=longlat +datum=NAD27")
nc_shp <- system.file("shapes/sids.shp",package="maptools")[1]
nc_shp
?readShapePoly # convert shape file to SpatialPolgyonsDataFrame
nc <- readShapePoly(nc_shp,proj4string=prj)
plot(nc)
pt <- locator(type = "p")
print(pt)
?overlay
poly_selected<- !is.na(over(nc,SpatialPoints(cbind(pt$x,pt$y),proj4string=prj)))
nc[poly_selected,]
plot(nc[poly_selected,], col = "blue", add = TRUE)

### Color Palettes and Class Intervals
# R has a number of color palettes to use with plotting:
?rainbow # Notice the other palettes available
?colorRampPalette # We can make a ramp of colors ranging
# between two extremes, e.g. from white to red.
rw.colors <- colorRampPalette(c("blue","white"))

library(raster)
data(meuse.grid)
xyz <- data.frame(meuse.grid$x,meuse.grid$y,meuse.grid$dist)
meuse.raster <- rasterFromXYZ(xyz)
image(meuse.raster,col=rw.colors(20))
# For more complex Palette choices, use the:
install.packages("RColorBrewer")
help(package="RColorBrewer")
library(RColorBrewer)
example(brewer.pal) # Check the graphics output

### Class intervals:
install.packages("classInt")
help(package="classInt")
library("classInt")
# If we want to create intervals for continuous 
# data for mapping/color choices:
pal <- grey.colors(5,0.95,0.55,2.2)
q5 <- classIntervals(meuse$zinc,n=5,style="quantile")
class(q5)
# Make some breaks:
diff(q5$brks)
# Show the range of values per color:
plot(q5,pal=pal)
# Maybe a fisher-jenks set of breaks will be better:
fj5 <- classIntervals(meuse$zinc,n=5,style="fisher")
fj5
diff(q5$brks)
plot(fj5,pal=pal)
# This will probably look better, so let's use these breaks:
q5Colors <- findColours(q5,pal)
plot(meuse,col=q5Colors,pch=19)
legend("topleft",fill=attr(q5Colors,"palette"),
		legend=names(attr(q5Colors,"table")),bty="n")

######## SPATIAL DATA IMPORT AND EXPORT, BIVAND CHAPTER 4 ########

### GDAL/OGR and PROJ.4 Cartographic Projections Library
# http://gdal.org/
# http://trac.osgeo.org/proj/

# PROJ.4: provides a library that standardizes defining
# 	projections and datums, and provides tools for 
# 	converting between projections/datums (reprojection).

# GDAL/OGR (the Geospatial Data Abstraction Library) is an open
# source library that provides abstraction for basic raster/vector
# processing.  In other words: for the most part, you don't
# need to understand any of the nuances of access a given
# file format, GDAL will take care of it.  This includes:
# - reading/writing raster and vector files
# - querying and defining CRS
# - getting raster/vector metadata
# - re-projecting raster/vector data
# - accessing subsets of the raster/vector data
# - ... and a lot more.  
# GDAL is the raster toolkit, and OGR is the vector toolkit.
#	They are packaged together.
# GDAL/OGR has bindings in a number of languages:
# - Perl
# - Python
# - VB6 Bindings (not using SWIG)
# - R
# - Ruby
# - Java
# - C# / .Net
# GDAL/OGR is used by a LARGE number of programs:
#  http://trac.osgeo.org/gdal/wiki/SoftwareUsingGdal
#  Some notable ones:
#	- Google Earth
# 	- Quantum GIS
#	- GRASS GIS
# 	- ArcGIS 9.2+
# 	- IDRISI
# 	- MapServer
# The main interface to GDAL in R is the package:
install.packages("rgdal")
library("rgdal")
# rgdal is a wrapper for the GDAL and PROJ.4 libraries.  

help(package="rgdal")

?make_EPSG
# EPSG is a now-defunct set of geodetic parameters that
# are distributed, for backwards compatibility, with
# PROJ.4.  EPSG parameters are stored as a code that
# is linked to its set of parameters.  Finding the right
# code can be tricky.  We can read in the entire database:
EPSG <- make_EPSG()
summary(EPSG)
head(EPSG)
# Let's say we are looking for the European Datum 1950 (ED50).
# We want to convert this to the WGS84 datum so we can use the
# coordinates with GPS.
# We can first search through this list using our handy text searching:
EPSG[grep("^# ED50$",EPSG$note),] 
# The note column contains the info we want to search on.
# We see the code is 4230, and we can see the PROJ.4 string to use.

### PROJ.4 CRS Specification
# PROJ.4 uses a 'tag=value' representation of the parameters.
# Each tag begins with a '+', the values starting with '='
# and each different tag is separated by a whitespace.
# We can use an EPSG code to give us the right PROJ.4 
# string by:
?CRS
ED50 <- CRS("+init=epsg:4230")
ED50
# +proj is the projection, in this case, geographical
# +ellps is the ellipsoid, in this case the intl (which 
# 	refers to the International Ellipsoid of 1909 (Hayford).
# We want to convert this to WGS84, but the raw ED50 definition
# 	requires additional parameters to do the conversion.  In
# 	this case, they have been defined by the
# +towgs84 tag.  Don't worry too much right now about
# 	what those parameters mean, just be aware that some
#	CRS tags do not contain ALL the info needed to perform
#	a conversion.

# Ok, let's convert the datum now:
# We can convert from DMS formatted coordinates
# to numeric via:
?char2dms
IJ.east <- as(char2dms("4d31'00\"E"),"numeric")
IJ.north <- as(char2dms("52d28'00\"N"),"numeric")
# Make a single SpatialPoints point:
IJ.ED50 <- SpatialPoints(cbind(x=IJ.east,y=IJ.north),ED50)
IJ.ED50
# spTransform is our workhorse reprojection/datum conversion
# tool for vectors:
?spTransform
res <- spTransform(IJ.ED50,CRS("+proj=longlat +datum=WGS84"))
res # Now uses the WGS84 datum, instead of the intl datum.
# Backconvert to DMS format:
?dd2dms
x <- as(dd2dms(coordinates(res)[1]),"character")
y <- as(dd2dms(coordinates(res)[2]),"character")
cat("intl coordinates:","4d31'00\"E","52d28'00\"N")
cat("WGS84 coordinates",x,y,"\n")


### Vector File Formats
# Now that we have a better understand of importing/defining
# 	CRS, we will move on to importing vector files.
# We will use the OGR libraries that ship with GDAL, interfaced
#	with the rgdal library.
# OGR (and GDAL) work by the programmers defining "drivers" for
# 	each unique format.  When a vector file is brought into
#	R, OGR will (usually) figure out what format the file is in,
#	load the correct driver, and import the data.
# What formats can you work with?  This may differ from system
#	to system (the GDAL/OGR libraries can be "expanded" with
#	new drivers beyond the defaults, but this takes a bit more
#	know-how).
library("rgdal")

?ogrDrivers
ogrDrivers()
# A fuller list (all possible) can be found at:
# http://gdal.org/ogr/ogr_formats.html

# To import a vector into a Spatial* or Spatial*DataFrame,
#	we use:
?readOGR
# The two basic input parameters are:
#	dsn: the dataset name
#	layer: the layer name to extract
# This gets a bit confusing from one format to
#	the next, so a bit of knowledge of each unique
#	vector format is required.  For instance,
#	for an ESRI Shapefile, which is actually a set of 
#	files stored in the same directory with extensions:
#	a .shp, .dbf, and .shx 
#	dsn will be the directory these files are in,
#	and layer will be the shapefile name WITHOUT the
#	extensions:
# "." means "current directory":

# set the directory to the folder that contains the scot data. your directory will be different
setwd("E:/Lecture18_Data/")

scot_LL <- readOGR(dsn=".",layer="scot")
# We could also have done:
scot_LL <- readOGR(getwd(),"scot")
# Notice that OGR knew it was an ESRI Shapefile with
#	Polygon data and 2 field of information:
summary(scot_LL)
# ESRI Shapefiles store their projection info in a
# 	.prj file, but this particular file did not have one.
# As such, notice the proj4string is [NA].  Let's remedy this:
proj4string(scot_LL) <- CRS("+proj=longlat +ellps=WGS84")
summary(scot_LL)
# We have another data file which contains data we want to
# link based on the IDs:
scot_LL$ID
scot_dat <- read.table("scotland.dat",header=TRUE)
# Hmm, looks like the header is no good.  
# Let's just skip it:
scot_dat <- read.table("scotland.dat",skip=1)
# And manually set up the column names:
names(scot_dat) <- c("District","Observed","Expected",
		"PcAFF","Latitude","Longitude")
# We'll merge on this column:
scot_dat$District
scot_dat1 <- scot_dat[match(scot_LL$ID,scot_dat$District),]
scot_dat1 # Ordered and subsetted to scot_LL
# Fix the row names so the match will work:
row.names(scot_dat1) <- sapply(slot(scot_LL,"polygons"),
		function(x) slot(x,"ID"))
library("maptools")
?spCbind # This is a helpful tool for cbinding to 
# a Spatial*DataFrames:
scot_LLa <- spCbind(scot_LL,scot_dat1)
scot_LLa@data

# Let's reproject it to the British National Grid!
scot_BNG <- spTransform(scot_LLa,CRS("+init=epsg:27700"))

### Exporting Vector Data
# Ok, so we made this nice vector file and reprojected it,
# 	how do we now export this?
?writeOGR
# The basic inputs are:
#	obj: a Spatial* object
#	dsn: the dataset output name to use, can be 
#		a folder or filename.
#	layer: the layer name to write it to.
# We'll write to a KML file for use in Google Earth:
writeOGR(scot_LLa["ID"],dsn="scot_district.kml",layer="borders",
		driver="KML")

# We can also write to a Shapefile:
drv <- "ESRI Shapefile"
writeOGR(scot_BNG,dsn=".",layer="scot_BNG",driver=drv)

### Raster File Formats
# Ok, so now we have a good understanding of vector
# 	importing and exporting.  What about rasters?

### Import/Export with 'rgdal'
# We will first look at the "low level" importing 
# 	through rgdal, and then the more useful approach
#	using raster (which will use rgdal).

# We'll work with the Auckland Shuttle Radar Topography
#	Mission elevation dataset downloaded from the 
#	book's website:
dir()
# Hmm, the file was zipped (as is often the case with
#	large files).  We could manually unzip this, but
#	what if we want to unzip a LOT of files?  
?unzip
unzip("70042108.zip")
# Hmm, this worked but maybe we should do this
#	more neatly, having each file unzipped to 
#	its own directory:
unzip("70042108.zip",exdir="70042108")
# That's better!

# Now, we can use readGDAL to read the raster
# file:
?readGDAL
auck_ell <- readGDAL("70042108/70042108.tif")
summary(auck_ell)
# WARNING WARNING WARNING: this just loaded the
#	image into memory!  A big file would kill
#	our system if we did this.  Also note it
#	its class is:
class(auck_ell)
# Which is not as useful as a Raster* object.

# Let's be more careful with opening a raster:
?GDAL.open
x <- GDAL.open("70042108/70042108.tif")
class(x) # This is similar to a file connection
# At this point, almost nothing has been loaded
# into memory.  We can get basic info on the file.
# Can GDAL "understand" this format?
?getDriver
xx <- getDriver(x)
xx
?getDriverLongName
getDriverLongName(xx) # Yup, it sees its a GeoTIFF
dim(x)
# As with file connections, don't forget to
# close the file!
GDAL.close(x)

# To get a better overview of a file without
# having to fully import it, use:
?GDALinfo
GDALinfo("70042108/70042108.tif")
# Notice that the metadata is also printed (your
#	text uses an older version of rgdal that
#	doesn't show the metadata).
?writeGDAL 
# writeGDAL can export a SpatialGridDataFrame
#	or a SpatialPixelsDataFrame to any format.
#	We aren't working with SpatialGrid or SpatialPixels,
#	so we won't use writeGDAL.

### Import/Export with 'raster'
# As we've discussed before, when dealing with raster
#	files, use the 'raster' package, not sp.  'raster'
#	will utilize rgdal when needed for import/export.

# Recall the differences between the three types of
#	Raster* objects:
# RasterLayer: a single layer (band) raster
# RasterBrick: a multiband raster originating from a SINGLE file.
# RasterStack: a multiband raster comprised of MULTIPLE files.

library("raster")
# We'll now use each of the creation functions to "import"
#	different raster files.
?raster
?brick
?stack

# If we just want to import a single band file, we use raster()
#	with the filename:
highest_hit_raster <- raster("tahoe_lidar_highesthit.tif")
highest_hit_raster
inMemory(highest_hit_raster) # Notice it is NOT loaded into memory
nlayers(highest_hit_raster)
dim(highest_hit_raster)
image(highest_hit_raster,main="Lidar Highest Hit Raster",
		col=gray(0:255/255))

# How about a multiband image stored in a single file?
#	We use brick:
tahoe_highrez_brick <- brick("tahoe_highrez.tif")
tahoe_highrez_brick
inMemory(tahoe_highrez_brick)
nlayers(tahoe_highrez_brick)
dim(tahoe_highrez_brick)
# Use plotRGB to plot 3 bands as an RGB image:
plotRGB(tahoe_highrez_brick)
# We can invert the band/color mapping:
plotRGB(tahoe_highrez_brick,r=3,g=2,b=1)
# Notice if we use the same band, we get a greyscale:
plotRGB(tahoe_highrez_brick,r=1,g=1,b=1)

# Now, we'll fuse multiple files into a single Raster*
#	object using stack():
band1_filename <- "tahoe_lidar_bareearth.tif"
band2_filename <- "tahoe_lidar_highesthit.tif"
tahoe_lidar <- stack(band1_filename,band2_filename)
tahoe_lidar
nlayers(tahoe_lidar)
dim(tahoe_lidar)
plot(tahoe_lidar,y=1) # Plots layer = 1
plot(tahoe_lidar,y=2) # Plots layer = 2

# We can read any Raster* object to any file format
#	listed in:
?gdalDrivers
gdalDrivers()
# We can write in any format as long as create==TRUE:
# Long names:
gdalDrivers()$long_name[gdalDrivers()$create==TRUE]
# Driver names:
gdalDrivers()$name[gdalDrivers()$create==TRUE]

### To write, we use:
?writeRaster
# To save to a GeoTIFF (the suffix will be appended):
mysavedraster <- 
		writeRaster(x=tahoe_lidar,filename="tahoe_lidar",format="GTiff",overwrite=TRUE)
# To save to a different numerical format (e.g. integer):
writeRaster(x=tahoe_lidar,filename="tahoe_lidar_int",format="GTiff",
		dataType="INT2S",overwrite=TRUE)
# ENVI file with a different band order and an NAflag set:
writeRaster(x=tahoe_lidar,filename="tahoe_lidar_bsq",format="ENVI",
		NAflag=-9999,bandorder="BSQ",overwrite=TRUE)


