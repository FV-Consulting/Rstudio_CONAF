#### GEOG 489: Programming for GIS
#### Chunyuan Diao
#### Lecture 23: Species Distribution Models


######## SPECIES DISTRIBUTION MODELS ########

# There is a class of models which are developed
# to predict the probability of something being
# present at a given location.  These are typically
# used to predict species presence/absence, so 
# we will refer to them as species distribution
# models, but note that this class of model
# can be used for just about any continuous variable.

# The basic process of developing an SDM is:
#	1) Collect data on the presence/abscence
#		of a species (typically) with field
#		work at specific locations x,y.  
#		Code these as 0 (absent) or 1 (present). 
#	2) Develop raster/vector surfaces that may 
#		be related to the distribution of a species.
#	3) Extract the raster/vector info at each location
#		where the presence/absence data was collected.
#	4) Construct a model relating the probabilty of
#		presence as a function of the extracted
#		raster/vector variables.
#	5) Perform accuracy assessment/goodness of fit
#		analysis.
#	6) (Optional) tweak the model/inputs and repeat
#		steps 1-5.
#	7) Apply the model to the raster/vector layers
#		to produce a map of species distributions.

# First, we will read in a dataset of species 
#	presence/absence for a somewhat rare plant
#	species Pinus albicaulis (Whitebark pine)
#	that is found in the high Sierra Nevada Mountains.

# set the working directory that contains the lab data
setwd("C:/Users/genin/OneDrive/Documents/UIUC/Courses/Spring 2020/Programming GIS/Lectures and files/Week 13/Lecture 23 R data")
data<-read.csv("tahoe_spp_subset.csv",head=T)
summary(data)
# Let's create a SpatialPointsDataFrame of this:
require("sp")
coordinates(data) <- c("xcoord","ycoord")
head(data)

# We have a number of possible environmental/
#	topographic predictors of Whitebark pine,
#	which we'll read in:
require("raster")
elev <- raster("tahoedems_nad83_30m.img")
rad <- raster("tahoe_rad_reproj.tif")
tci <- raster("tahoedems_tci.img")

# Let's map out the data distribution:
plot(elev,zlim=c(1000,3500))
points(data)
legend("bottomleft","plot location",pch=1,bty="n")

# Time to extract the data!  First, let's stack the 
#	rasters to make it a bit easier:


# ensure the rasters have the same projection
projection(elev)
projection(rad)
projection(tci)
projection(elev) <- projection(rad) <- projection(tci)

predictor_stack <- stack(elev,rad,tci)
predictor_stack
# Let's go ahead and "fix" the min/max:
predictor_stack <- setMinMax(predictor_stack)
# Like with most models, we need to make sure
# the layer names are properly named:
names(predictor_stack) <- c("elev","rad","tci")

# Now we'll extract the data:
extracted_predictors <- extract(predictor_stack,data,df=TRUE)

# We'll spCbind the data back:
require("maptools")
data_w_predictors <- spCbind(data,extracted_predictors)
# There's an NA in there, let's get rid of it:
data_w_predictors <-data_w_predictors[
  !is.na(data_w_predictors$elev),]



### Logistic regression:
# Ok, so now we have a data set where if PIAL = 1, a Whitebark
#	pine was present at that location, and if PIAL = 0, the
#	species was absence.  So, what if we just regress this field
#	against, say, elevation:

lm_notransform <- lm(PIAL ~ elev,data=data_w_predictors)
plot(data_w_predictors$elev,data_w_predictors$PIAL,xlab="elev",ylab="probability of species presence")
abline(lm_notransform,col="red")

# Some notes:
#	1) The input data isn't really continuous.
#	2) The linear model predicts probabilities
#		< 0 or > 1, which is not possible.
#	3) The variance isn't constant across X.
#	4) Significance test of the regression coefficients
#		assumes the errors in prediction are normally
#		distributed (which is clearly not the case).

# We can take advantage of a generalized linear models
#	(glm) and define a different error distribution, 
#	in this case, a binomial distribution.  To fit
#	this distribution, we use a "logit link function"
#	to transform our input data such that:
# ln( P / (1-P) ) = a + bX

# Before we push on with this, let's do some exploratory
#	data analysis.  First, a histogram of our data:
hist(data_w_predictors$PIAL,col=grey(.8),border="white")
# Notice we have lots of absences, and not a ton of 
#	presences (the species is relatively uncommon).

# Now we'll look at the predictor variables:
par(mfrow=c(1,3))
boxplot(data_w_predictors$elev,
		axes=T,
		xlab="elev",
		cex.lab=3,
		col=grey(.5))

boxplot(data_w_predictors$rad,
		axes=T,
		xlab="rad",
		cex.lab=3,
		col=grey(.5))

boxplot(data_w_predictors$tci,
		axes=T,
		xlab="tci",
		cex.lab=3,
		col=grey(.5))

# GLMs really need the variables to be (somewhat)
#	uncorrelated.  Let's look at the pairwise
#	correlations:

data_w_predictors_only <- data.frame(
		elev=data_w_predictors$elev,
		rad=data_w_predictors$rad,
		tci=data_w_predictors$tci)
?pairs
pairs(data_w_predictors_only,
		panel=panel.smooth,
		cex=1.5,
		bg=grey(.8))

# Good, they look pretty uncorrelated.

# Ok, time to fit the model.  We will use
# 	the Generalized Linear Model function:
?glm
# Note, although we could construct
#	the model setting data=data_w_predictors,
#	subsequent plotting gets confused.  
#	We'll play it safe and convert the 
#	SpatialPointsDataFrame to a data.frame.
pial.sdm <- glm(PIAL~elev+rad+tci,
	family=binomial(link=logit),
	data=as.data.frame(data_w_predictors))

summary(pial.sdm)

# Some things to note:
#	The coefficients allow us to see the impacts
#		of the predictor in the probability of
#		its presence/absence. 
#	Elevation has a significant, positive relationship
#		on PIAL being present.  This means that
#		as elevation increases, the probability of finding
#		that species increases.
#	TCI and radiation are less significant, and also
#		have small negative coefficients.

# We can look at the impacts of each predictor on the
#	response, holding the other predictors constant via:
?termplot
pial.sdm
par(mfrow=c(1,3))
termplot(pial.sdm,partial.resid=T)

# Now, we can apply this model to our predictor rasters!
pial.surf <- predict(predictor_stack,
    pial.sdm,type="response")
par(mfrow=c(1,1))
plot(pial.surf)

# One of the applications of SDMs is to look at climate
#	change impacts on species.  Let's try this now.
#	First, let's use an actual climate variable, not
#	a topographic one.  A simple model is that
#	temperature decreases with elevation.  We can
#	use a lapse rate model to describe this.

# We need a reference elevation and a lapse rate 
#	(the change in temperature per unit elevation
#	increase).  

# At the lake shore, annual average temperatures are
#	around 6 deg C.  The lake is at 1900m above sea level.
# The elevational lapse rate was found to be 5.3 deg C/km
# We can convert our elevation map to temperature by:
reference_elevation = 1.900
reference_temperature = 6
lapse_rate = 5.3 # From Dobrowski et al. 2009
temperature = reference_temperature - 
  (lapse_rate*(elev/1000 - reference_elevation))
temperature[elev < 1800] <- NA
plot(temperature)
# Now, let's re-run our model using temperature instead
#	of elevation:

projection(temperature) <- projection(rad) <- projection(tci)
predictor_stack <- stack(temperature,rad,tci)
predictor_stack
# Let's go ahead and "fix" the min/max:
predictor_stack <- setMinMax(predictor_stack)
# Like with most models, we need to make sure
# the layer names are properly named:
names(predictor_stack) <- c("temperature","rad","tci")

# Now we'll extract the data:
extracted_predictors <- extract(predictor_stack,data,df=TRUE)

# We'll spCbind the data back:
require("maptools")
data_w_predictors <- spCbind(data,extracted_predictors)
# There's an NA in there, let's get rid of it:
data_w_predictors <-data_w_predictors[!is.na(data_w_predictors$tci),]

pial.sdm <- glm(PIAL~temperature+rad+tci,
		family=binomial(link=logit),
		data=as.data.frame(data_w_predictors))

# This will look the same:
pial.surf_wtemp <- predict(predictor_stack,pial.sdm,type="response")
summary(pial.surf_wtemp)
plot(pial.surf_wtemp)

# Ok, now let's simulate a 1.0 deg C regional warming:
temperature_future <- temperature + 1.0
plot(temperature_future)
# We will make a new stack with this:
future_stack <- stack(temperature_future,rad,tci)
# But use the same variable names:
names(future_stack) <- c("temperature","rad","tci")

# Now, let's predict the distribution of Whitebark
#	pine using this novel climate:
pial.surf_future <- predict(future_stack,
      pial.sdm,type="response")
par(mfrow=c(1,2))
plot(pial.surf_wtemp)
plot(pial.surf_future)

# Notice the probabilities decreased.  Let's calculate
#	the change in area.

# First, we'll assume that a prob > 0.7 
# is "Whitebark pine habitat":

present_PIAL <- rasterToPolygons(pial.surf_wtemp,
	function(x) { x > 0.7 },dissolve=TRUE)

par(mfrow=c(1,1))
plot(elev)
plot(present_PIAL,add=TRUE)

# We can calculate the sum of the areas and convert to hectares:
sum(sapply(slot(present_PIAL, "polygons"), 
    slot, "area"))*0.0001 

# Now repeat with the future:
future_PIAL <- rasterToPolygons(pial.surf_future,
		function(x) { x > 0.7 },dissolve=TRUE)


par(mfrow=c(1,1))
plot(elev)
plot(future_PIAL,add=TRUE)
sum(sapply(slot(future_PIAL, "polygons"), slot, "area"))*0.0001 

# Wow!  That's a huge change in area with a 1 deg warming.

