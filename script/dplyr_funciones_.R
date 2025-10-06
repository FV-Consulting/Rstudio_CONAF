#funciones basicas de dplyr del universo tydiverse

# https://rsanchezs.gitbooks.io/rprogramming/content/chapter9/mutate.html



# instalar paquetes -------------------------------------------------------

install.packages("tidyverse")
library(tidyverse)
install.packages("datos")
library(datos)


# Data --------------------------------------------------------------------

?vuelos
vuelos

# exploracion de funciones basicas dplyr ----------------------------------

##tipos de datos dentro de una base

  # int significa enteros.
  # dbl significa dobles, o números reales.
  # chr significa vectores de caracteres o cadenas.
  # dttm significa fechas y horas (una fecha + una hora)

##cinco funciones clave de dplyr

  # 1. Filtrar o elegir las observaciones por sus valores (filter() — del inglés filtrar).

  # 2. Reordenar las filas (arrange() — del inglés organizar).

  # 3. Seleccionar las variables por sus nombres (select() — del inglés seleccionar).

  # 4. Crear nuevas variables con transformaciones de variables existentes 
  #    (mutate() — del inglés mutar o transformar).

  # 5. Contraer muchos valores en un solo resumen (summarise() — del inglés resumir).

#Todas estas funciones se pueden usar junto con group_by() (del inglés agrupar por),
#que cambia el alcance de cada función para que actúe ya no sobre todo el conjunto de datos 
#sino de grupo en grupo.


# 1- Filtrar (filter()) ---------------------------------------------------

##filter(df,argumentos a filtrar), ej: 

filter(vuelos, mes == 1, dia == 1) #filtra el mes 1 con el dia 1 de cada mes 

  # para convertir ese filtro en una nueva data se debe poner un nombre antes
  # por ejemplo "mes 1"<- (funcion)

## Notacion de comparacion == (igual), >, >=, <, <=, != (no igual)

##Operadores logicos para simplificar el filtro 

  # Para otros tipos de combinaciones necesitarás usar operadores Booleanos: 
  # & es “y”, | es “o”, y ! es “no”. 
  # ejemplo: buscar vuelos que salieron en noviembre o diciembre 

filter(vuelos, mes == 11 | mes ==12) # vuelos en los meses 11 o 12

  # otra forma de escribirlo mas similar al lenguaje español en cuanto a estructura: 

filter(vuelos, mes %in% c(11,12)) # vuelos que salieron en los meses 11 y 12 

  # ejemplo con notacion "no", ">", y o. 
  # vuelos que no se atrasaron mas de 2 horas en salir  llagar

filter(vuelos, !(atraso_llegada >120 | atraso_salida >120 ))

## valores desconocidos NAs se encuentran con is.na(df)

is.na(vuelos) # sia rroja TRUE es por hay, FALSE es porque no hay 


# Ejercicio Filtrar y operadores basicos ----------------------------------

  # 1. Tuvieron un retraso de llegada de dos o más horas

filter(vuelos, atraso_llegada>=120)



# 2- arrange() reodernar --------------------------------------------------

  # sirve para ordenar columnas o filas de interes y armar un df con ellas 
  # Ej: 

arrange(vuelos, anio, mes, dia) #pone primero esas columnas en el df

arrange(vuelos, desc(atraso_salida)) # desc, ordena en froma decesendente segun la 
                                     # columna señalada dentro de la funcion

  # en caso de tener Na en una columna, llamala usando is.na(columna) y con
  # arrange y desc posicionara primero los valores NA, ejemplo: 

df<-tibble(x = c(5, 2, NA))

arrange(df, x)

arrange(df, desc(is.na(x)))


# 3-select() ----------------------------------------------------------------

  #select sirve en elegir un subconjunto de columnas del fichero

select(vuelos, destino, origen) #solo escogi esas dos columnas 

select(vuelos, anio:destino) # con el comando ":" selecciono un rango 

select(vuelos, -anio) # con el comando "-" alimino una columna 

select(vuelos, contains("atraso")) #con "contains" selecciono todo lo que contiene


# SITAXIS O encadenar %>% -------------------------------------------------

  # Primero se escribe el nombre del fichero y luego las acciones en el orden 
  # en que se realizan separadas por el operador %>%
  # (que podríamos leer como entonces)

  #ejemplo: destinos, con atrasos de mas de 2 horas, respecto al menor atraso.

vuelos %>%
  select(atraso_llegada, destino)%>%
  filter(atraso_llegada >120)%>%
  arrange(desc(atraso_llegada))



# 4- mutate -> crear nuevas variables -------------------------------------

  # mutate(df, nombre variable nueva = (funcion o combinacion de variales))
  # en la parte de funciones podemos usar otras acciones de otros paquetes: 

  # ejemplo comsum() del paquete bas, calcula frecuencias absolutas



# 5- sumarrise -------------------------------------------------

  # a función summarise() funciona de forma análoga a la función mutate, 
  # excepto que en lugar de añadir nuevas columnas crea un nuevo data frame.

## funciones de estadistica descriptiva de summarise: 

  # max()	Valores max y min
  # mean()	media
  # median()	mediana
  # sum()	suma de los valores
  # var, sd()	varianza y desviación típica

##funciones de dplyr usables en summarise

  # first()	primer valor en un vector
  # last()	el último valor en un vector
  # n()	el número de valores en un vector
  # n_distinct()	el número de valores distintos en un vector
  # nth()	Extrar el valor que ocupa la posición n en un vector

# ejemlo: 
summarise(vuelos, mediana = median(salida_programada), variance = var(salida_programada))

#ejemplo con operador pipline: 

vuelos %>% summarise(mediana = median(salida_programada), variance = var(salida_programada))



# group.by ----------------------------------------------------------------

  # Usamos summarise() para aplicar comandos a variables. Normalmente se usa en 
  # combinación con group_by() de manera que se calculen estadísticos para 
  # subgrupos de observaciones

# ejemplo: 
        # pollution %>%  group_by(city) %>%  #llama al subgrupo
            #+   summarise(mean = mean(amount), sum = sum(amount), n = n())
            #+   le aplica estadisitca descriptiva 



#ejemplo con varias variables: 
    # summarise_each() en la que se consideran varias variables a la vez. 
    # Un ejemplo es el siguiente, en el que se calculan las medias de cada una 
    # de las medidas del pétalo y para cada una de las tres especies:
        
                # lirios %>%
                #group_by(Species) %>%
                # summarise_each(funs(mean), contains('Petal'))
