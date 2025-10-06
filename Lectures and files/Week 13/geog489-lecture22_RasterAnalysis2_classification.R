#### GEOG 489: Programming for GIS
#### Chunyuan Diao
#### Lecture 22: Raster Analysis 2: Classification


######## RASTER CLASSIFICATION ########
# Today we'll show a few different types
# of classification models.  Creating and
# applying these models in a GIS framework
# follows a similar pattern as deriving
# continuous variable models:
#	1) Collect training and testing data of classes.
#	2) Extract pixel values at the location of the 
#		training data.
#	3) Perform transforms on the pixel values (e.g.
#		calculate NDVI and other indices).
#	4) Try several classification models out 
# 		with different input predictors.
#	5) Extract pixel values at the location of the
#		testing data and link with class information.
#	6) Apply models to test data to predict the 
#		variable.
#	7) Compare the predicted variable vs. the 
#		measured variable for the various
#		models and predictor combinations.
#	8) Pick the best model and...
#	9) Apply (predict) the model to the raster.
#		Note that you may need to generate
#		new layers or stack datasets together.

require("raster")
require("rgdal")
require("spatial.tools")

# set the working directory that has the lab data
setwd("C:/Users/genin/OneDrive/Documents/UIUC/Courses/Spring 2020/Programming GIS/Lectures and files/Week 12/lecture21_RasterAnalysis1_data")

tahoe_highrez_training_points <- 
  readOGR(dsn=system.file("external", 
  package="spatial.tools"),layer="tahoe_highrez_training_points")
tahoe_highrez_brick <- brick("tahoe_highrez.tif")

plotRGB(tahoe_highrez_brick)
plot(tahoe_highrez_training_points,add=TRUE,col="yellow")

# We'll extract our spectral data:
tahoe_highrez_training_points_spectral <- extract(tahoe_highrez_brick,
		tahoe_highrez_training_points,df=TRUE)

require("maptools")
?spCbind # Makes it easier to cbind to a Spatial*DataFrame
tahoe_highrez_training_points_w_spectra <- 
  spCbind(tahoe_highrez_training_points,
		tahoe_highrez_training_points_spectral)

# We'll make some test data by doing some random samples 
# based on the height:
highest_hit_raster <- raster("tahoe_lidar_highesthit.tif")
bareearth_raster <- raster("tahoe_lidar_bareearth.tif")
lidar_height <- highest_hit_raster - bareearth_raster

### Manual classifiction using ranges of values:
# Recall that a class is represented, in a Raster,
# as an integer.  We can define a set of "breaks"
# to place a raster into.  Let's define three classes:
#	Ground: height is less than 0.5m
#	Shrub: height is greater than or equal to 0.5m, 
#		but less than 2m.
#	Tree: height is greater than or equal to 2m.
?cut
class_breaks <- c(0,0.5,2,cellStats(lidar_height,max)) 
lidar_height_class <- cut(lidar_height,breaks=class_breaks)
plot(lidar_height_class)

# What if we wanted to change the numerical ID of tree 
# from class # 3 to class #4?
?subs
# We need to define a lookup table:
class_sub_table <- data.frame(id=1:3,newid=c(1,2,4))
lidar_height_reclass <- subs(lidar_height_class,class_sub_table,
		by="id",which="newid")

plot(lidar_height_reclass)

# Ok, let's make some testing data
?sampleStratified
tahoe_highrez_test_points <- 
  sampleStratified(lidar_height_class,size=10,sp=TRUE)
# We'll extract the spectral data:
tahoe_highrez_test_points_spectral <- extract(
  tahoe_highrez_brick,
	tahoe_highrez_test_points,df=TRUE)


tahoe_highrez_test_points_w_spectra <- spCbind(
  tahoe_highrez_test_points,
		tahoe_highrez_test_points_spectral)

# We need to create factors from the raster IDs:
?cut # Use the "base" version:
tahoe_highrez_test_points_w_spectra$SPECIES <- cut(
		x=tahoe_highrez_test_points_w_spectra$layer,
		breaks=c(0,1,2,3),
		labels=c("Non-vegetation","Shrub","Tree"))

# We'll use this to see how well our classifers are performing.
# A good package to begin with (although a bit hard to deal
#	with re: GIS) is "class"
install.packages("class")

require(class)
help(package="class")

### k-Nearest Neighbor Classification
# This algorithm calculates each class' centroid
# in multidimensional space, and then determines
# the class of each unknown value based on its
# Euclidean distance proximity to the class centroid.
?knn

# We need to setup training and testing/prediction
#	in a very specific way, for this model:
names(tahoe_highrez_training_points_w_spectra)
names(tahoe_highrez_test_points_w_spectra)
tahoe_knn_training <- data.frame(
	tahoe_highrez_training_points_w_spectra$tahoe_highrez.1,
	tahoe_highrez_training_points_w_spectra$tahoe_highrez.2,
	tahoe_highrez_training_points_w_spectra$tahoe_highrez.3)
tahoe_knn_training_classes <- 
	tahoe_highrez_training_points_w_spectra$SPECIES
tahoe_knn_test <- data.frame(
		tahoe_highrez_test_points_w_spectra$tahoe_highrez.1,
		tahoe_highrez_test_points_w_spectra$tahoe_highrez.2,
		tahoe_highrez_test_points_w_spectra$tahoe_highrez.3
		)
		
# Generate model:
set.seed(1)
tahoe_knn <- knn(train=tahoe_knn_training,
		test=tahoe_knn_test,cl=tahoe_knn_training_classes)

### Testing the accuracy of the model
# In general, we need to have two components to 
# test classification accuracy: the predicted class
# (from the model), and the "true" class (from 
# testing data).  There are a few ways to generate
# classification stats in R.  We'll use one in the 
# "caret" package:
install.packages("caret")
install.packages("e1071")

require("caret")
require("e1071")
?confusionMatrix
tahoe_knn_confusionMatrix <- 
		confusionMatrix(
	data=tahoe_knn,
	reference=tahoe_highrez_test_points_w_spectra$SPECIES)
tahoe_knn_confusionMatrix
# Let's look at the confusionMatrix:
names(tahoe_knn_confusionMatrix)
tahoe_knn_confusionMatrix$table 
# The diagonal is what we got right (not much)
# We got a 57% overall accuracy and a 0.35 kappa 
# (Note: yours may be different,
# depending on the testing samples selected)
# "Sensitivity" is the same 
# as the Producer's accuracy.  

# Ok, not great, but let's figure out how to
# apply this to an image.  We don't have
# a "predict" statement to work with, but 
# we know that the "pixels" are fed into
# the model as a data frame (or matrix).  Let's
# see if we can calc to do what we want:

knn_calc_function <- function(x)
{
  # We'll set a seed just in case there is a random part:
  set.seed(1)
	# x is a single pixel, in calc.  knn recognizes
	# is.vector(x) as a single case, so this works:
	tahoe_knn_factors <- knn(train=tahoe_knn_training,
			test=x,cl=tahoe_knn_training_classes)
	return(as.numeric(tahoe_knn_factors))
}

tahoe_knn_raster <- calc(tahoe_highrez_brick,
      knn_calc_function)
plot(tahoe_knn_raster)
summary(tahoe_knn_raster)


### Classification (and regression) trees (CART)
# A basic classification tree takes the predictor
# variables and recursively partition them into binary
# splits to best predict the response variable (a class,
# in our case).
# A CART output model is a set of binary splits
#  on the predictor variables (e.g. Band 1 > 50?  Y/N)
#  that terminate in the predicted category (hence, it
#  looks like a tree).  

install.packages("tree") 
# Note there is a similar package called "rpart"
require("tree")
?tree
# Construct the tree model:
tahoe_tree <- tree(SPECIES ~ 
	tahoe_highrez.1 + tahoe_highrez.2 + tahoe_highrez.3,
	data=tahoe_highrez_training_points_w_spectra)
tahoe_tree
summary(tahoe_tree) # Wow, it has no misclassification
#	errors! (I should be saying this sarcastically,
# 	tree models will overfit/perfectly fit the inputs).
plot(tahoe_tree)
text(tahoe_tree) # To get the labels
# A couple things to notice: not all bands were used!
# tree models can be helpful if you want to test a
# lot of bands that MIGHT be useless, e.g. transforms
# such as NDVI.  For instance:
tahoe_highrez_training_points_w_spectra$ndvi <- 
		(tahoe_highrez_training_points_w_spectra$tahoe_highrez.1-
		tahoe_highrez_training_points_w_spectra$tahoe_highrez.2)/
		(tahoe_highrez_training_points_w_spectra$tahoe_highrez.1+
		tahoe_highrez_training_points_w_spectra$tahoe_highrez.2)

tahoe_tree <- tree(SPECIES ~ 
	tahoe_highrez.1 + tahoe_highrez.2 + tahoe_highrez.3 + ndvi,
	data=tahoe_highrez_training_points_w_spectra)
plot(tahoe_tree)
text(tahoe_tree) 
# NDVI didn't help, so we don't need to calculate NDVI
# for the final model.

tahoe_tree <- tree(SPECIES ~ 
				tahoe_highrez.1 + tahoe_highrez.2 + tahoe_highrez.3,
		data=tahoe_highrez_training_points_w_spectra)

# Let's test this using our independent dataset:
?predict.tree
# Make sure you have the correct names:
names(tahoe_highrez_test_points_w_spectra)
tahoe_tree_test <- 
  predict(tahoe_tree,tahoe_highrez_test_points_w_spectra)
tahoe_tree_test 
# Notice it gives a prob per class.  This isn't
# 	exactly what we want.  We want the class outputs (type="class"):
tahoe_tree_test <- predict(tahoe_tree,
        tahoe_highrez_test_points_w_spectra,
		type="class")
tahoe_tree_test

# There we go.  Now let's test the accuracy:

tahoe_tree_confusionMatrix <- 
	confusionMatrix(
	data=tahoe_tree_test,
	reference=tahoe_highrez_test_points_w_spectra$SPECIES)

tahoe_tree_confusionMatrix
tahoe_tree_confusionMatrix$table
# Overall accuracy and kappa were a bit worse than the
# k-nearest neigbor model.  

# Alright, prediction time.
# This does have a predict statement, so let's see if we can
# get predict() working?
tahoe_tree_raster <- predict(tahoe_highrez_brick,tahoe_tree)
plot(tahoe_tree_raster)
# Nope...  Oops, we forgot to modify the type.  We can
# 	pass arbitrary arguments to the predict.tree:
tahoe_tree_raster <- predict(tahoe_highrez_brick,tahoe_tree,type="class")
plot(tahoe_tree_raster)


### RandomForests
# RandomForests are an extension of CARTs that improve
# on many of the shortcomings of a CART, most notably
# overfitting.  It is also considered one of the best
# classifiers available.

# The way it basically works is that it generates 
# a set of trees ("forest") by dropping samples from 
# the training data and running a new tree.

# Each tree can be applied to a test sample, and
# (oversimplifying this) the class predicted by
# the most number of trees is "voted" to be the 
# best.

# As we saw before, RandomForests can be used
# for non-parameteric regression, but we'll see here
# it used for classification:
install.packages("randomForest")
require("randomForest")
?randomForest

# Looks mighty similar to the "tree" call:
tahoe_randomForest <- randomForest(SPECIES ~ 
	tahoe_highrez.1 + tahoe_highrez.2 + tahoe_highrez.3,
	data=tahoe_highrez_training_points_w_spectra,
	importance=TRUE) 
# set  importance=TRUE to check for variable importance

tahoe_randomForest
importance(tahoe_randomForest)
varImpPlot(tahoe_randomForest)

# Apply it to the test data:
?predict.randomForest
tahoe_randomForest_test <- 
  predict(tahoe_randomForest,tahoe_highrez_test_points_w_spectra)

# Now calculate the confusionMatrix and accuracy statistics:
tahoe_randomForest_confusionMatrix <- 
		confusionMatrix(
				data=tahoe_randomForest_test,
				reference=tahoe_highrez_test_points_w_spectra$SPECIES)

tahoe_randomForest_confusionMatrix
tahoe_randomForest_confusionMatrix$table
# Notice the accuracy is 50% with a kappa of 0.25.

# Looks good, now time to create the raster:
tahoe_tree_raster <- predict(tahoe_highrez_brick,tahoe_randomForest)
plot(tahoe_tree_raster)

### Raster to Vector
# What if we now want to create polygons from the class information?
?rasterToPolygons
# Don't forget dissolve=TRUE or you'll end up with one poly per pixel.
tahoe_randomForest_polys <- 
  rasterToPolygons(tahoe_tree_raster,dissolve=TRUE)
# This can take awhile.
tahoe_randomForest_polys
# Subset out the trees only:
tahoe_randomForest_trees <- 
  tahoe_randomForest_polys[
    tahoe_randomForest_polys$layer==3,]
plot(lidar_height,col=grey.colors(16))
plot(tahoe_randomForest_trees,add=TRUE,col="green",border="green")
