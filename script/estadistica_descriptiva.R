# Titulo : Ayudantia n°3 - Econometria para la gestion
# Objetivo: Cargar datos y aplicar estadistica descriptiva.
# Ayudante: Manuel Rojas Labraña
# Docente: Fernando Crespo

# Cargar paquetes ---------------------------------------------------------

install.packages("readxl")
library(readxl)
install.packages("dplyr")
library(dplyr)
install.packages("ggplot2")
library(ggplot2)
install.packages("moments")
library(moments)

# Cargar datos  -----------------------------------------------------------

auto_peso_consumo <- read_excel("C:/Users/manue/OneDrive 
                                - Universidad Alberto Hurtado/8vo_semestre/
                                ayu_econometria/data/auto_peso_consumo_mr.xlsx")

View(auto_peso_consumo)


# Trabajamos en la data ---------------------------------------------------

  #seccion 1: estadistica descriptiva con dplyr
  #seccion 2: histogramas con ggplot2
  #seccion 3: boxplot
  #seccion 4: Relacion entre variables 

# 1. Estadística descriptiva con dplyr ----

    #*nota* _ na.rm = TRUE significa "remove NAs" 
      #le estamos diciendo a la función que ignore los valores faltantes
      #(NA) antes de calcular

estadisticas <- auto_peso_consumo %>%
  summarise(
    # Medidas de tendencia central
    media_peso = mean(peso_libras, na.rm = TRUE),        # Promedio del peso
    mediana_peso = median(peso_libras, na.rm = TRUE),    # Valor central del peso
    
    # Medidas de dispersión
    var_peso = var(peso_libras, na.rm = TRUE),           # Varianza
    sd_peso = sd(peso_libras, na.rm = TRUE),             # Desviación estándar
    
    # Valores extremos
    min_peso = min(peso_libras, na.rm = TRUE),           # Mínimo
    max_peso = max(peso_libras, na.rm = TRUE),           # Máximo
    
    # Cuartiles
    q25_peso = quantile(peso_libras, 0.25, na.rm = TRUE),# 1er cuartil (25%)
    q75_peso = quantile(peso_libras, 0.75, na.rm = TRUE),# 3er cuartil (75%)
    
    # Forma de la distribución
    curtosis_peso = kurtosis(peso_libras, na.rm = TRUE), # Curtosis: qué tan “picuda” o “achatada” es la distribución
    asimetria_peso = skewness(peso_libras, na.rm = TRUE),# Asimetría: hacia qué lado se sesga la distribución
    
    # Repetimos lo mismo para consumo
    media_consumo = mean(consumo_millas_por_galon, na.rm = TRUE),
    mediana_consumo = median(consumo_millas_por_galon, na.rm = TRUE),
    var_consumo = var(consumo_millas_por_galon, na.rm = TRUE),
    sd_consumo = sd(consumo_millas_por_galon, na.rm = TRUE),
    min_consumo = min(consumo_millas_por_galon, na.rm = TRUE),
    max_consumo = max(consumo_millas_por_galon, na.rm = TRUE),
    q25_consumo = quantile(consumo_millas_por_galon, 0.25, na.rm = TRUE),
    q75_consumo = quantile(consumo_millas_por_galon, 0.75, na.rm = TRUE),
    curtosis_consumo = kurtosis(consumo_millas_por_galon, na.rm = TRUE),
    asimetria_consumo = skewness(consumo_millas_por_galon, na.rm = TRUE)
  )

print(estadisticas)   # Mostrar tabla de resultados

        # Nota: esta tabla resume TODAS las estadísticas en una sola salida

 #TAREA: HACER DOS TABLAS SEPARADAS DE ESTADISTICA DESCRIPTIVA PARA CADA VARIABLE

# 2. Histogramas ----


# Nos permiten ver la distribución de los datos
ggplot(auto_peso_consumo, aes(x = peso_libras)) +
  geom_histogram(binwidth = 500, fill = "skyblue", color = "black") +
  labs(title = "Distribución del peso (libras)", x = "Peso en libras", y = "Frecuencia")

ggplot(auto_peso_consumo, aes(x = consumo_millas_por_galon)) +
  geom_histogram(binwidth = 2, fill = "lightgreen", color = "black") +
  labs(title = "Distribución del consumo (mpg)", x = "Consumo (millas/galón)", y = "Frecuencia")

# Nota: cambiar "binwidth" modifica el ancho de las barras (nivel de detalle)

# 3. Boxplots ----

# Muy útiles para detectar valores extremos (outliers)

ggplot(auto_peso_consumo, aes(y = peso_libras)) +
  geom_boxplot(fill = "orange") +
  labs(title = "Boxplot del peso", y = "Peso en libras")

ggplot(auto_peso_consumo, aes(y = consumo_millas_por_galon)) +
  geom_boxplot(fill = "purple") +
  labs(title = "Boxplot del consumo", y = "Consumo (mpg)")

    # Nota: La línea del medio es la mediana, la caja representa el 
    #rango intercuartílico (Q1 - Q3)

# 4. Relación entre variables ----

# Scatterplot para ver si existe relación entre peso y consumo

ggplot(auto_peso_consumo, aes(x = peso_libras, y = consumo_millas_por_galon)) +
  geom_point(color = "darkblue") +
  geom_smooth(method = "lm", se = FALSE, color = "red") + # Línea de regresión
  labs(title = "Relación entre peso y consumo", x = "Peso (libras)", y = "Consumo (mpg)")

    # Nota: Si la línea es descendente, significa que a mayor peso, 
    # menor consumo (relación negativa)
