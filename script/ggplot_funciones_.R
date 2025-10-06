#funciones basicas de ggplot2

https://r-graph-gallery.com/ 
# paquetes --------------------------------------------------------------

library(ggplot2)
# data --------------------------------------------------------------------

data = mtcars
# geom_point ------------------------------------------------------------

  # geom_point(): la geometría o tipo de gráfico puede ser de muchas maneras, 
  # en este caso es de tipo punto aes(): “aesthetic”, como las variables serán 
  # visualizadas facet_grid()

#ejemplo: 
ggplot(data = mtcars) + 
  geom_point(aes(mpg, qsec, colour = factor(am))) + # variables y colores
  facet_grid(~vs) # como las variables sera VISULIZADAS


# geom_histogram ----------------------------------------------------------

ggplot(data = mtcars) + 
  geom_histogram(aes(x=qsec, #limita el rango 
                     fill=factor(am)), # divide categorias
                 bins=10, #asigan transparencia
                 position = "stack", # pisiciona las barras 
                 alpha = 0.5, #trasparencia
                 binwidth=0.3) 


# geom_density ------------------------------------------------------------


ggplot(data = mtcars) + 
  geom_density(aes(x=qsec,fill=factor(am)),
               bins=10, position = "identity",
               alpha = 0.5)

