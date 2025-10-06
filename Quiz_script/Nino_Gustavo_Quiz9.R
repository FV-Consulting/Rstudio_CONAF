##Geog 489--Quiz9
##Gustavo Enrique Nino

##First we set the folder

setwd("C:/Users/genin/OneDrive/Documents/UIUC/Courses/Spring 2020/Programming GIS/Lectures and files/Week 12/lecture21_RasterAnalysis1_data")

##Calculate the Lidar height
highest_hit_raster <- raster("tahoe_lidar_highesthit.tif")
bareearth_raster <- raster("tahoe_lidar_bareearth.tif")
lidar_height <- highest_hit_raster - bareearth_raster
summary(lidar_height)

##Calculate the index

tahoe_highrez_brick <- brick("tahoe_highrez.tif")
index <- function(x) { x[1]/x[2]}
tahoe_index <- calc(tahoe_highrez_brick,index)

# Create the sample
tahoe_highrez_training_points <- sampleRandom(tahoe_highrez_brick,size=50,sp=TRUE)

##Extract the data
lidar_height_extract <- extract(lidar_height,tahoe_highrez_training_points,df=TRUE)
index_extract <- extract(tahoe_index, tahoe_highrez_training_points,df=TRUE)

##Cbind and names
height_vs_index_data <- cbind(index_extract,lidar_height_extract)
names(height_vs_index_data) <-c("ID.1","index","ID.2","lidar_height")

plot(height_vs_index_data$index,height_vs_index_data$lidar_height)

##Linear regression
index_height_lm <- lm(lidar_height ~ index, data=height_vs_index_data)

##There is a problem with inf
height_vs_index_data <- subset(height_vs_index_data, height_vs_index_data$index != "Inf") 

##Linear regression
index_height_lm <- lm(lidar_height ~ index, data=height_vs_index_data)

###Testing Data
tahoe_highrez_testing_points <- sampleRandom(tahoe_highrez_brick,size=50,sp=TRUE)

lidar_height_extract_test <- extract(lidar_height,tahoe_highrez_testing_points ,df=TRUE)
index_extract_test <- extract(tahoe_index,tahoe_highrez_testing_points ,df=TRUE)

height_vs_index_data_test <- cbind(index_extract_test,lidar_height_extract_test)
names(height_vs_index_data_test) <- c("ID.1","index","ID.2","lidar_height")

############ predict the test
predict_lm_test <-predict(index_height_lm,height_vs_index_data_test)

test <- as.data.frame(cbind(predict_lm_test,lidar_height_extract_test$layer))
names(test) <- c("prediction","observed")

test<- na.omit(subset(test, test$prediction != "Inf"))
# correlation
cor(test$prediction, test$observed)



