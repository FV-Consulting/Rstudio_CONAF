###Quiz 8
##Gustavo Enrique Nino GEOG 489
library(sp)

##I create the new polygon
rhw = cbind(c(180000,180000,181000,181000,180000),c(331000,330000,330000,331000,331000))
rhw

srhw=Polygons(list(Polygon(rhw)),"HW") ##I create the polygon first

srhwsp=SpatialPolygons(list(srhw)) ##Now, I assign the polygon as spatial polygon

srhwdata=SpatialPolygonsDataFrame(srhwsp,data.frame(c(1000000),row.names=c("HW")))##Now, We assign the values of the spatial polygon

polygon(rhw)

plot(srhwdata)

#Now, I get the data from the polygon
data(meuse)
coordinates(meuse) = ~x+y
#Now, I show the information for each point
over(meuse,srhwdata)


