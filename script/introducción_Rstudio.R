
#contexto
#los datos utilizados son ficticios orientados a la empresa de buses hualpen en el area de mantenimiento 
# de buses, en la base de santiago. Los datos buscan ejemplificar una muestra de trabajadores del area
#de mantenimiento de maquinarias.
# paquetes ----------------------------------------------------------------

install.packages("psych") 
library(psych)
install.packages("scatterplot3d")
library(scatterplot3d)
install.packages("readxl")
# SECCION A ---------------------------------------------------------------
p <- as.Date("2022-08-22")
q <- as.Date("2019-04-21")
r <- as.Date("2023-03-16")
s <- as.Date("2021-06-16")
t <- as.Date("2020-04-18")



Nombres <- c("manuel", "daniel", "roberto", "alfonso", "jaime", "ignacio", "andres", "maximiliano", "patricio", 
"josue", "alejandro", "felipe", "Tulio", "humberto","nelson")

"Horas extras diarias" <- c(6,8,9,5,2,4,7,1,2,3,6,5,3,2,1)
"Horas de trabajo semanales" <- c(48,56,52,49,60,48,58,49,50,46,48,49,40,50,66) #Horas semanales
"Comuna de residencia"<- c("maipu","maipu","pudahuel","cerrillos","lampa","san miguel","quilicura","quilicura","san miguel","el castillo","santiago","lampa","el bosque","la pintana","ñuñoa") #comuna de residencia
"Cargo"<- c("Mecanico tecnico","Mecanico Lider","Electrico","Supervisor","Mecanico asistente","Mecanico tecnico","Mecanico Lider","Electrico","Supervisor","Mecanico asistente","Mecanico tecnico","Mecanico Lider","Electrico","Supervisor","Mecanico asistente") #cargos
"Antiguedad laboral" <- c(2,5,1,3,4,2,5,1,3,4,2,5,1,3,4) #antiguedad laboral
"Sueldo base"<- c(700000,1500000,1000000,2000000,500000,700000,1500000,1000000,2000000,500000,700000,1500000,1000000,2000000,500000) #sueldo base
"Ingreso a la empresa"<- c(p,q,r,s,t,p,q,r,s,t,p,q,r,s,t)

trabajadoresdestacados <- data.frame(Nombres,`Horas extras diarias`,`Horas de trabajo semanales`,`Comuna de residencia`,Cargo,`Antiguedad laboral`,
                                        `Sueldo base`,`Ingreso a la empresa`)

trabajadoresdestacadosR <- data.frame(rbind(Nombres,`Horas extras diarias`,`Horas de trabajo semanales`,`Comuna de residencia`,Cargo,`Antiguedad laboral`,
                                                `Sueldo base`,`Ingreso a la empresa`))

trabajadoresdestacadosC <- data.frame(cbind(Nombres,`Horas extras diarias`,`Horas de trabajo semanales`,`Comuna de residencia`,Cargo,`Antiguedad laboral`,
                                                `Sueldo base`,`Ingreso a la empresa`))

fix(trabajadoresdestacados)


# seccion b ---------------------------------------------------------------

ls(trabajadoresdestacados) #cuantos obj estan creados
str(trabajadoresdestacados) #estructura de datos
nrow(trabajadoresdestacados) #numero de filas
ncol(trabajadoresdestacados) #numero d columnas
dim(trabajadoresdestacados) #numero de columnas y filas
colnames(trabajadoresdestacados) #nombre de columnas
rownames(trabajadoresdestacados) #nombre de filas
head(trabajadoresdestacados,6) #primeras 6 obs 
tail(trabajadoresdestacados,6) #ultomas 6 obs
describe(trabajadoresdestacados) #describe estructura 
summary(trabajadoresdestacados) #describe estructura
sapply(trabajadoresdestacados, class)

# seccion c ---------------------------------------------------------------


summary(trabajadoresdestacados$Horas.extras.diarias)

min(trabajadoresdestacados$Horas.extras.diarias)
max(trabajadoresdestacados$Horas.extras.diarias)
sum(trabajadoresdestacados$Horas.extras.diarias)
quantile(trabajadoresdestacados$Horas.extras.diarias)
quantile(trabajadoresdestacados$Horas.extras.diarias,0.25)
quantile(trabajadoresdestacados$Horas.extras.diarias,0.90)
quantile(trabajadoresdestacados$Horas.extras.diarias, na.rm = T, probs = c(0.3,0.6,0.8,0.999))
median(trabajadoresdestacados$Horas.extras.diarias)
mean(trabajadoresdestacados$Horas.extras.diarias)
quantile(trabajadoresdestacados$Horas.extras.diarias,0.5)
sd(trabajadoresdestacados$Horas.extras.diarias
)
var(trabajadoresdestacados$Horas.extras.diarias)

# seccion d ---------------------------------------------------------------


barplot(`Horas extras diarias`, main = "Cantidad de horas extras por trabajador", xlab="trabajadores", ylab = "cantidad de horas", col = "blue")


boxplot(trabajadoresdestacados$Horas.extras.diarias, main="Boxplot horas extras por trabajador", 
        ylab="canitidad de  horas", col="red")

hist(trabajadoresdestacados$Horas.extras.diarias, main="Histograma de horas extras", xlab="horas extras diarias")
