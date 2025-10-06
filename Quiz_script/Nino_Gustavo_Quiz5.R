##Quiz 5
##Gustavo Nino

##First we create the input to prove the function

x<- "Programming NA GIS NA"

##We create the function, it is used "NA" as initial value

removeNA<- function(variable = x, Extract = "NA") return(gsub(Extract,"",x))

##Proof of the function

removeNA(variable = x)

## This is the output

y<-removeNA(variable = x) 