#### GEOG 489: Programming for GIS
#### Chunyuan Diao, chunyuan@illinois.edu
#### Assignment 6 (Optional)
#### Due April 23, 2020 at midnight.

# Your goal is to manipulate SpatialLines and SpatialPolygons (lecture 16)
#	and perform simple plotting.

# Requirements:
#	1) The function should be named "plotLinesOrPolygons" and have the following
#		parameters:
#		lines_vector : an input SpatialLines object (assumption: one Line 
#			per Lines object)
#		whichPlot: a character value that can be "lines" or "polygons" or
#			(for the extra credit) "linesToPolygons".  The default should 
#			be "lines".
#		filename: an output pdf filename, should default to "lines.pdf"
#	2) If whichPlot=="lines", the function should subset out all Lines 
#		objects which CANNOT be polygons (1st coordinate does not match
#		last coordinate).
#	3) If whichPlot=="polygons", the function should subset out all Lines
#		objects which CAN be polygons (1st coordinate matches the last
#		coordinate), and converts these to a SpatialPolygons object.
#	4) (Extra Credit) If whichplot=="linesToPolygons", the function should
#		subset out all of the lines (requirement #3), and add a new node
#		to each line that equals the first node, and then convert these lines
#		to a SpatialPolygons object.
#	5) Whatever subset the whichplot creates, it should be plotted using
#		the default axes.  SpatialLines should be plotted in red, and
#		SpatialPolygons should be plotted with the outline in black and
#		filled with red.  These plots should be saved to the pdf filename.
#	6) The function should return the subset.
# 7) You may use any packages used in the class.  In all likelihood, you
#		should only need sp and rgdal, and maptools to run the example.
#	8) Comment your code in at least 3 places.
#	9) The code should be submitted tom Compass 2g as a single function with the filename:
#		LastName-FirstName-geog489-s20-assignment-06.R
#	and should have at the top:
#	[Your name]
#	Assignment #6

# 1 point of extra credit for implementing the whichPlot=="linesToPolygons"

# Hint: USE THE EXAMPLE FROM THE BOOK/LECTURE in your code (lecture 16 and section 2.6)!  

# Tests:
library(maptools)
# Input data:
llCRS <- CRS("+proj=longlat +ellps=WGS84")
auck_shore <- MapGen2SL("auckland_mapgen.dat",llCRS)
class(auck_shore)

summary(plotLinesOrPolygons(lines_vector=auck_shore,whichPlot="lines",filename="lines.pdf"))
#Object of class SpatialLines
#Coordinates:
#		min   max
#x 174.2 175.3
#y -37.5 -36.5
#Is projected: FALSE 
#proj4string : [+proj=longlat +ellps=WGS84]
# See lines.pdf for plotting output.

summary(plotLinesOrPolygons(lines_vector=auck_shore,whichPlot="polygons",filename="polygons.pdf"))
#Object of class SpatialPolygons
#Coordinates:
#		min       max
#x 174.30297 175.22791
#y -37.43877 -36.50033
#Is projected: FALSE 
#proj4string : [+proj=longlat +ellps=WGS84]
# See polygons.pdf for plotting output.

# Extra credit:
summary(plotLinesOrPolygons(lines_vector=auck_shore,whichPlot="linesToPolygons",filename="linesToPolygons.pdf"))
#Object of class SpatialPolygons
#Coordinates:
#		min   max
#x 174.2 175.3
#y -37.5 -36.5
#Is projected: FALSE 
#proj4string : [+proj=longlat +ellps=WGS84]
# See linesToPolygons.pdf for plotting output.