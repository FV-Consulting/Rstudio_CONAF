##Assigment 5 GEOG 489
#Gustavo Enrique Nino

#Define the dataframe of X and Y
set.seed(10)
n <- 10
df <- data.frame(xpos=runif(n,0,360),ypos=runif(n,-90,90))
df

##Creation of the function
hemisphereSummary<-function(df,projargs="+proj=longlat +datum=WGS84"){ ##Define the function
  library(sp)
  library(foreach)
  df<-SpatialPointsDataFrame(coords = df, data = df, proj4string = CRS(projargs)) ##Create the data frame with the coordinates
  names(df)<-c("EWhemisphere","NShemisphere")
  registerDoSEQ()
foreach(i=1:dim(df)[1]) %do% ##Assign the hemispheres 
  if (df[[2]][i]>= 0) {df[[2]][i]= "N"} else {df[[2]][i]= "S"}
  if (df[[1]][i]>= 180) {df[[1]][i]= "W"} else {df[[2]][i]= "E"}

return(df)
}

##Test of the function

outHemisphere <- hemisphereSummary(df=df)
outHemisphere
summary(outHemisphere)
as.data.frame(outHemisphere)


