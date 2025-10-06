#### GEOG 489: Programming for GIS
#### Chunyuan Diao
#### Lecture 21: Raster Analysis 1: Continuous Variables

#### Pre-class announcement
# Assignment 5 is due by the end of today (April 16)
# Assignment 6 (optional) is on Compass and will be due April 23, 2020 at midnight.



######## RASTER MODELS ########
# For most models, you can use raster's predict() 
# function.  Remember that unlike the generic
# predict function, the first entry in raster's
# predict() is the input raster/brick/stack, and the
# second entry is the model object.

# First off, R models.  Let's perform a simple linear regression,
#	but using extracted data.
# We are interested in seeing if Lidar derived vegetation 
#	height is linearly related to NDVI:

# Will need set up the working directory to your lecture data folder
setwd("C:/Users/genin/OneDrive/Documents/UIUC/Courses/Spring 2020/Programming GIS/Lectures and files/Week 12/lecture21_RasterAnalysis1_data")

library("raster")
library("rgdal")
library("spatial.tools")
library("sp")

# Calculate Lidar height:
highest_hit_raster <- raster("tahoe_lidar_highesthit.tif")
bareearth_raster <- raster("tahoe_lidar_bareearth.tif")
lidar_height <- highest_hit_raster - bareearth_raster
plot(lidar_height)
summary(lidar_height)

# Calculate NDVI:
tahoe_highrez_brick <- brick("tahoe_highrez.tif")
ndvi <- function(x) { (x[1] - x[2])/(x[1] + x[2])}
tahoe_ndvi <- calc(tahoe_highrez_brick,ndvi)

# Extract data using our points vector:
tahoe_highrez_training_points <- 
  readOGR(dsn=system.file("external", 
  package="spatial.tools"),layer="tahoe_highrez_training_points")

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
plot(height_vs_ndvi_data$ndvi,height_vs_ndvi_data$lidar_height)
# Meh, not so great, but then again I wasn't expecting it to be....

# Let's do a simple linear regression:
?lm
# Before we do this, we need to understand
#	R's formula coding.  The generic 
#	format is:
# response variable ~ explanatory variables
# 	or, for our example:
# lidar_height ~ ndvi

ndvi_height_lm <- lm(
  height_vs_ndvi_data$lidar_height ~ 
  height_vs_ndvi_data$ndvi)
ndvi_height_lm
class(ndvi_height_lm)

# Most statistical models in R have a parameter
#	"data" that allows you to set the data frame,
#	and just use the column names in the formula.
#	This makes it a bit easier to write:
ndvi_height_lm <- lm(lidar_height ~ ndvi, 
    data=height_vs_ndvi_data)
# summary() will give us a lot more info:
summary(ndvi_height_lm)
plot(height_vs_ndvi_data$ndvi,height_vs_ndvi_data$lidar_height)
abline(ndvi_height_lm)

plot(ndvi_height_lm)
# This gives us up to 6 plots:
#	1) Residuals vs. fitted values
#	2) Scale-Location plot of sqrt(residuals) vs. fitted
#	3) Normal Q-Q plot
#	4) Cook's distances vs. row labels
#	5) Residuals vs. leverages
#	6) Cook's distance vs. leverage/1-leverage)
#	By default, #s 1,2,3 and 5 are plotted.

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
ndvi_sequence = as.data.frame(seq(from=-1, to=1, by=0.05))
# You usually need to make sure that the variables are named
#	the same as in the model:
names(ndvi_sequence) <- "ndvi" 
predicted_height <- predict(ndvi_height_lm,newdata=ndvi_sequence)
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

### Tranforming variables in formulas
# Ok, let's look at our plot again:
plot(height_vs_ndvi_data$ndvi,height_vs_ndvi_data$lidar_height)
# Hmm, maybe we actually want to log transform the height data.  
# Maybe that will fix it.
?log
plot(height_vs_ndvi_data$ndvi,
  log(height_vs_ndvi_data$lidar_height))
# Interesting, looks a bit better.  We can use this in a formula:
ndvi_height_lm_loght <- lm(log(lidar_height) 
    ~ ndvi, data=height_vs_ndvi_data)
summary(ndvi_height_lm_loght)
abline(ndvi_height_lm_loght)
# Notice the R2 is higher than:
summary(ndvi_height_lm)

# Ok, how do we apply this to the image, since the log is on
#	the response variable side.
# Simple, we first predict the model, then raise the result to e:
tahoe_height_log_pred <- 
  (predict(tahoe_ndvi,ndvi_height_lm_loght))^exp(1)
plot(tahoe_height_log_pred)
# Notice NDVI was able to see variability in tree heights up to
# about 2-2.5m.  Above this, there is no signal to use.

### Multiple regression
# Ok, let's use all the bands at our disposal:
all_bands_extract <- extract(tahoe_highrez_brick,
      tahoe_highrez_training_points,df=TRUE)
summary(all_bands_extract)

# We'll append this to our current training data:
height_vs_ndvi_vs_allbands_data <- cbind(height_vs_ndvi_data,
    all_bands_extract)
# We'll make this a bit easier to read:
names(height_vs_ndvi_vs_allbands_data)[6:8] <- c("B1","B2","B3")
# Don't forget to change the layer names for prediction:
names(tahoe_highrez_brick)<- c("B1","B2","B3")

# A straight multiple regression takes this form:
ndvi_height_lm_multi <- 
  lm(lidar_height ~ ndvi + B1 + B2 + B3, 
    data=height_vs_ndvi_vs_allbands_data)
summary(ndvi_height_lm_multi)

# Ok, but now our data sources come from TWO different files:
tahoe_highrez_brick
tahoe_ndvi
# We need to stack() these up to use in a predict() call:
tahoe_multi <- stack(tahoe_highrez_brick,tahoe_ndvi)
# Make sure the names are still there:
names(tahoe_multi) # Make sure the names are correct.
# names(tahoe_multi) <- c("B1","B2","B3","ndvi")
# Now we can predict:
tahoe_multi_pred <- predict(tahoe_multi,ndvi_height_lm_multi)
plot(tahoe_multi_pred)
# Interesting, looks like the max tree height that
#	could be detected is higher than just using
#	ndvi alone.  However, note that the heights
#	go negative.  We could "fix" this by:

ndvi_height_lm_multi <- lm(log(lidar_height) 
    ~ ndvi + B1 + B2 + B3, data=height_vs_ndvi_vs_allbands_data)
tahoe_multi_pred <- predict(tahoe_multi,ndvi_height_lm_multi)^exp(1)
plot(tahoe_multi_pred) # Not so believable outputs.  Oh well.

### RandomForests
# Maybe our predictors have non-linear effects on
#	the response variable.  Let's try out a 
#	machine learning algorithm called 
#	"Random Forests".
install.packages("randomForest")
library("randomForest")
?randomForest
# Notice that most models take on a similar form:
tahoe_height_rf <- randomForest(lidar_height ~ 
    ndvi + B1 + B2 + B3,
	data=height_vs_ndvi_vs_allbands_data)
tahoe_height_rf
# We can look at which variables are most important:
tahoe_height_rf <- randomForest(lidar_height ~ 
  ndvi + B1 + B2 + B3,
	data=height_vs_ndvi_vs_allbands_data,
	importance=TRUE,ntrees=500)
importance(tahoe_height_rf)
varImpPlot(tahoe_height_rf) 

# Interesting, b3 was the most important,
#	and ndvi the least.
# Let's predict!
tahoe_rf_pred <- predict(tahoe_multi,tahoe_height_rf)
plot(tahoe_rf_pred) # Vs:
plot(lidar_height)
# Interesting, seems to be a bit better!

### Testing models
# For all of these models, we often do some form
#	of independent testing.  Let's randomly choose
#	50 points to test:

randomSample <- sampleRandom(tahoe_multi,size=50,sp=TRUE)
# Use this to extract the height data
randomSample_ht <- extract(lidar_height,randomSample,df=TRUE)

randomSample_all <- cbind(randomSample_ht,as.data.frame(randomSample))
# Remember to check the names:
names(randomSample_all)
names(randomSample_all)[2] <- "lidar_height"

# Ok, let's check each of the models using independent data:
predict_lm_randomSample_all <-
  predict(ndvi_height_lm,randomSample_all)
# Now let's plot the predicted vs actual:
plot(predict_lm_randomSample_all,randomSample_ht$layer)
cor(predict_lm_randomSample_all,randomSample_ht$layer)
# Ick, not good.  

# Let's check the log transformed model:
predict_lmlog_randomSample_all <- 
  predict(ndvi_height_lm_loght,randomSample_all)
# Remember this was log transformed:
predict_lmlog_randomSample_all <- 
  exp(predict_lmlog_randomSample_all)
plot(predict_lmlog_randomSample_all,randomSample_ht$layer)
cor(predict_lmlog_randomSample_all,randomSample_ht$layer)
# Actually worse than the previous one...

# How about the multi-band linear model ?
predict_lmmulti_randomSample_all <- 
  predict(ndvi_height_lm_multi,randomSample_all)
plot(predict_lmmulti_randomSample_all,randomSample_ht$layer)
cor(predict_lmmulti_randomSample_all,randomSample_ht$layer)
# Still not better than the NDVI-only linear model. 

# Finally, the RandomForest model:
tahoe_height_rf
predict_rf_randomSample_all <- 
  predict(tahoe_height_rf,randomSample_all)
plot(predict_rf_randomSample_all,randomSample_ht$layer)
cor(predict_rf_randomSample_all,randomSample_ht$layer)
# Ick.  

# Key note: Higher R^2/goodness of fit measures (for training data) do 
# not necessarily mean a model
# 	will work better on independent testing data.
# Independent testing data are needed to evaluate the model performance

### Summary:
# R provides many ways to perform continuous variable
#	extraction.  The basic order of ops is typically:
#	1) Collect training and testing data
#	2) Extract pixel values at the location of the 
#		training data.
#	3) Perform transforms on the pixel values (e.g.
#		calculate NDVI and other indices).
#	4) Try several models out with different input
#		predictors.
#	5) Extract pixel values at the location of the
#		testing data.
#	6) Apply models to test data to predict the 
#		variable.
#	7) Compare the predicted variable vs. the 
#		measured variable for the various
#		models and predictor combinations.
#	8) Pick the best model and...
#	9) Apply (predict) the model to the raster.
#		Note that you may need to generate
#		new layers or stack datasets together.