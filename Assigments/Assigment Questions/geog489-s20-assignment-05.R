#### GEOG 489: Programming for GIS
#### Chunyuan Diao, chunyuan@illinois.edu
#### Assignment 5
#### Due Thursday, April 16, 2020 at midnight.

# Your goal is to:
#	1) Convert a data frame of x,y coordinates into a SpatialPoints object.
#	2) Loop through each point using a foreach statement (with sequential backend) and determine the
#		hemispheres (North/South and East/West) of each point.
#	3) Create a SpatialPointsDataFrame object with the hemispheres as 
#		attributes.

# Requirements:
#	1) The function should be named "hemisphereSummary" and have the following
#		parameters:
#		df : the input data frame (two columns) containing x and y values.
#		projargs: the character string of projection arguments, and should
#			default to "+proj=longlat +datum=WGS84".
#	2) Within the function, you can (and should) load the libraries "sp" and 
#		"foreach".  No other libraries may be used.
#	3) Within the function, register a sequential backend to foreach.
#		Hint: help(package="foreach")
#	4) Before determining the hemispheres, the input data frame must be 
#		converted to a SpatialPoints object (with the correct projection
#		arguments).
#	5) The SpatialPoints object (not the input data frame) should be examined 
#		one point at a time using a foreach loop.  
#	6) The loop should determine whether a point is in the northern or southern 
#		hemisphere (we will count equatorial points as "north"), returned as
#		a factor "N" or "S".
#	7) The loop should also determine whether a point is in the eastern or western
#		hemisphere (prime meridian points should be "east"), returned as a factor
#		"E" or "W".
#	8) The final SpatialPointsDataFrame should have two attributes, "NShemisphere"
#		and "EWhemisphere", rownames should be set to NULL, and be returned from the function.
#	9) Comment your code in at least 3 places.
#	10) The code should be submitted tom Compass 2g as a single function with the filename:
#		LastName-FirstName-geog489-s20-assignment-05.R
#	and should have at the top:
#	[Your name]
#	Assignment #5

# Some hints:
#	- Don't forget to load the needed packages in the foreach call (?foreach for details).
#	- The hemisphere detection phase can be coded as a nested function (that foreach will
#		call).


# Tests:
set.seed(10)
n <- 10
df <- data.frame(xpos=runif(n,0,360),ypos=runif(n,-90,90))
df
#	xpos      ypos
#1  182.69215  27.29802
#2  110.43666  12.19280
#3  153.68676 -69.56838
#4  249.51675  17.26655
#5   30.64895 -25.55100
#6   81.15718 -12.81430
#7   98.83099 -80.65740
#8   98.02982 -42.44802
#9  221.69855 -18.21767
#10 154.68175  60.50415

outHemisphere <- hemisphereSummary(df=df)
outHemisphere
#			coordinates EWhemisphere NShemisphere
#1    (182.692, 27.298)            W            N
#2   (110.437, 12.1928)            E            N
#3  (153.687, -69.5684)            E            S
#4   (249.517, 17.2666)            W            N
#5   (30.6489, -25.551)            E            S
#6  (81.1572, -12.8143)            E            S
#7   (98.831, -80.6574)            E            S
#8   (98.0298, -42.448)            E            S
#9  (221.699, -18.2177)            W            S
#10  (154.682, 60.5041)            E            N

summary(outHemisphere)
#Object of class SpatialPointsDataFrame
#Coordinates:
#			min       max
#xpos  30.64895 249.51675
#ypos -80.65740  60.50415
#Is projected: FALSE 
#proj4string : [+proj=longlat +datum=WGS84]
#Number of points: 10
#Data attributes:
#EWhemisphere NShemisphere
#E:7          N:4         
#W:3          S:6    

as.data.frame(outHemisphere)
#	EWhemisphere NShemisphere      xpos      ypos
#1             W            N 182.69215  27.29802
#2             E            N 110.43666  12.19280
#3             E            S 153.68676 -69.56838
#4             W            N 249.51675  17.26655
#5             E            S  30.64895 -25.55100
#6             E            S  81.15718 -12.81430
#7             E            S  98.83099 -80.65740
#8             E            S  98.02982 -42.44802
#9             W            S 221.69855 -18.21767
#10            E            N 154.68175  60.50415



