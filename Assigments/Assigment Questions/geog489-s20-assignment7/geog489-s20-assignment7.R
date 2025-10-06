#### GEOG 489: Programming for GIS
#### Chunyuan Diao
#### Assignment 7 (Optional)
#### Due THURSDAY, April 30, 2020 at midnight.

# Your goal this week is to use a neural
#	net classifier to classify an image
# 	and report the overall accuracy, kappa
# 	coefficient, and confusion matrix of
#	the classification.

# The following packages will be needed:
#	nnet
#	caret
#	raster
#	sp
#	rgdal
# You can use any other package you want, however.

# In your function, you can assume the band names are:
#	"tahoe_highrez.1" "tahoe_highrez.2" "tahoe_highrez.3"

# Requirements:
#	1) The function should be named "machine_learning_classification"
#		and have the following parameters (no defaults):
#		x: the input multispectral file
#		training: a SpatialPointsDataFrame with known SPECIES
#			to be used to train the classifier.
#		testing: a SpatialPointsDataFrame with known SPECIES
#			to be used to perform accuracy assessment.
#	2) The function should extract the 3-bands of data 
#		at the training and testing locations.
#	3) The function nnet(), which is part of the package
#		nnet (you will need to install it) should be 
#		used to create the classifier based on the 
#		training data.  All function parameters should
#		be left to their default values except:
#		number of units in the hidden layer: 2
#		initial random weights on [-rang,rang]: 0.1
#		weight decay parameter: 5e-4
#		maximum number of iterations: 1000
#	4) Use the output model to predict the SPECIES from
#		the testing dataset pixel values.
#	5) A confusion matrix and accuracy stats should be 
#		generated using the nnet predicted SPECIES 
#		and the testing SPECIES.
#		Use the confusionMatrix function in package
#		'caret'.
#	6) The nnet model is applied to the input raster (1 point of extra credit).
#	7) The function should return a list with two elements
#		named "confusion_matrix" and "classified_image"
#		which are the confusionMatrix() function output,
#		and the classified raster (for the extra credit).
#	8) Comment your code in at least 3 places.
#	9) The code should be submitted tom Compass 2g as a single function with the filename:
#		LastName-FirstName-geog489-s20-assignment7.R
#	and should have at the top:
#	[Your name]
#	Assignment #7

# HINTS:
#	- see lecture 22 (raster analysis classification) for classification intro
# - Pay attention to the type= parameter when using predict.nnet.
#	- You are not likely to be able to use raster's predict, because
#		nnet's predict function returns the character value of the
#		class.  You will likely need to combine nnet's predict with
#		a calc() statement (see the k-Nearest Neighbor example).
#	- NNET HAS A RANDOM COMPONENT, SO YOUR RESULTS MAY NOT BE
#		IDENTICAL TO MINE.


# Tests:
# Note that these directories are specific to my computer, you will need to 
#	change them on your computer:
setwd("Z:/Teaching/GISProgramming/geog489-s19-assignment7/")
require("raster")
require("rgdal")
x <- brick("tahoe_highrez.tif")
training <- readOGR(dsn=getwd(),layer="tahoe_highrez_training_points")
testing <- readOGR(dsn=getwd(),layer="tahoe_highrez_testing_points")

my_nnet <- machine_learning_classification(x=x,training=training,testing=testing)
# NOTE: YOURS MAY LOOK A BIT DIFFERENT.
## weights:  17
#initial  value 32.855848 
#iter  10 value 31.564340
#iter  20 value 27.958299
#iter  30 value 11.155419
#iter  40 value 11.149260
#iter  50 value 11.148422
#iter  60 value 11.142807
#iter  70 value 11.026870
#iter  80 value 9.385754
#iter  90 value 9.367819
#iter 100 value 9.366580
#iter 110 value 9.365720
#iter 120 value 9.365497
#iter 130 value 6.835043
#iter 140 value 5.860590
#iter 150 value 5.858456
#iter 160 value 5.857581
#iter 170 value 5.857228
#iter 180 value 5.856806
#iter 190 value 5.856652
#final  value 5.856644 
#converged

my_nnet$confusion_matrix
#Confusion Matrix and Statistics
#
#Reference
#Prediction       Non-vegetation Shrub Tree
#Non-vegetation              3     1    0
#Shrub                       2     0    0
#Tree                        5     9   10
#
#Overall Statistics
#
#Accuracy : 0.4333          
#95% CI : (0.2546, 0.6257)
#		No Information Rate : 0.3333          
#P-Value [Acc > NIR] : 0.166011        
#
#Kappa : 0.15            
#Mcnemar's Test P-Value : 0.002485        
#		
#		Statistics by Class:
#		
#		Class: Non-vegetation Class: Shrub Class: Tree
#		Sensitivity                         0.3000      0.00000      1.0000
#		Specificity                         0.9500      0.90000      0.3000
#		Pos Pred Value                      0.7500      0.00000      0.4167
#		Neg Pred Value                      0.7308      0.64286      1.0000
#		Prevalence                          0.3333      0.33333      0.3333
#		Detection Rate                      0.1000      0.00000      0.3333
#		Detection Prevalence                0.1333      0.06667      0.8000
#		Balanced Accuracy                   0.6250      0.45000      0.6500

my_nnet$classified_image
#class       : RasterLayer 
#dimensions  : 400, 400, 160000  (nrow, ncol, ncell)
#resolution  : 5.472863e-06, 5.472863e-06  (x, y)
#extent      : -119.9328, -119.9306, 39.28922, 39.29141  (xmin, xmax, ymin, ymax)
#coord. ref. : +proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0 
#data source : in memory
#names       : layer 
#values      : 1, 3  (min, max)
#attributes  :
#		ID          value
#1           Tree
#2          Shrub
#3 Non-vegetation

plot(my_nnet$classified_image)
# Check "nnet_class.pdf"

