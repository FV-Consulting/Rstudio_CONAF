
# AYUDANTÍA DE ECONOMETRÍA - REGRESIÓN LINEAL MÚLTIPLE 

# AYUDANTE: Manuel Rojas

# 1. LIMPIEZA Y PREPARACIÓN -------------------------------------------------------------------------


# Limpiar el entorno de trabajo
rm(list = ls())   # Elimina todos los objetos de la sesión

# Cargar librerías necesarias
install.packages("car")       # Para VIF y otras utilidades
install.packages("lmtest")    # Para test de heterocedasticidad
install.packages("corrplot")  # Para gráficos de correlación
library(car)
library(lmtest)
library(corrplot)

# Cargar el dataset 'mtcars', incluido en R

data("mtcars")

head(mtcars)  # Muestra las primeras filas de la base

# NOTA: mtcars contiene información de 32 autos de 1974.
# Variables de interés:
# mpg = millas por galón (rendimiento)
# wt  = peso en 1,000 libras
# hp  = caballos de fuerza
# cyl = número de cilindros



# 2. AJUSTE DE MODELO INICIAL----------------------------


# Queremos explicar mpg (rendimiento) a partir de wt (peso) y hp (potencia)

modelo <- lm(mpg ~ wt + hp, data = mtcars)

# Resumen de resultados

summary(modelo)


# INTERPRETACIÓN ESPERADA:

# - Intercepto: mpg esperado cuando wt=0 y hp=0 (no muy realista, pero necesario)

# - wt: efecto marginal del peso sobre mpg, manteniendo hp constante.

# - hp: efecto marginal de la potencia sobre mpg, manteniendo wt constante.

# - R-squared: proporción de variabilidad explicada por el modelo.

# - p-valores: si son < 0.05, el efecto es estadísticamente significativo.



# 3. VERIFICACIÓN DE SUPUESTOS Y DIAGNÓSTICOS-------------------

# 3.1 MATRIZ DE CORRELACIÓN

  # Ver relación entre las variables explicativas para detectar multicolinealidad

cor_matrix <- cor(mtcars[, c("wt", "hp")])

print(cor_matrix)

# Graficar la matriz de correlación
corrplot(cor_matrix, method = "number", type = "upper")

# EXPLICACIÓN:

  # La correlación mide qué tan relacionadas están las variables explicativas.
  
  # Si dos variables están muy correlacionadas (cerca de 1 o -1), puede haber
  # multicolinealidad, lo que dificulta interpretar los coeficientes.

# 3.2 TEST DE HETEROCEDASTICIDAD (BREUSCH-PAGAN)

bptest(modelo)

# INTERPRETACIÓN:

  # H0: Los errores son homocedásticos (varianza constante).
  
  # Si p-valor < 0.05, rechazamos H0 y concluimos que hay heterocedasticidad.
  
  # En ese caso, los errores estándar de los coeficientes podrían ser incorrectos
  # y deberíamos considerar usar errores robustos.

# 3.3 TEST DE SIGNIFICANCIA GLOBAL DEL MODELO

  # La salida de summary(modelo) ya incluye el "F-statistic".
  # Para enfatizar su importancia:

anova(modelo)

# INTERPRETACIÓN:
# H0: Todos los coeficientes (excepto el intercepto) son iguales a 0.
# Si p-valor < 0.05, el modelo en su conjunto es estadísticamente significativo.
# Es decir, al menos una variable explicativa realmente afecta a mpg.



# 4. AGREGAR UNA VARIABLE AL MODELO--------------------


# Ahora incluimos el número de cilindros (cyl) como variable explicativa

  modelo2 <- lm(mpg ~ wt + hp + cyl, data = mtcars)

# Resumen de resultados

  summary(modelo2)

# Repetimos pruebas de heterocedasticidad y significancia global

  bptest(modelo2)      # Test de Breusch-Pagan para el nuevo modelo

  anova(modelo, modelo2)  # Compara si agregar cyl mejora el ajuste

# PREGUNTAS :
# 1) ¿Aumenta o disminuye el R² ajustado?
# 2) ¿Los coeficientes siguen siendo significativos?
# 3) ¿Cómo cambia el signo o la magnitud de los coeficientes de wt y hp?

  

  # 5. EJERCICIOS PROPUESTOS----------------------------


# EJERCICIO 1:
  
  # Estimen un modelo que explique mpg usando wt, hp y drat (relación final).
  # Interpreten los coeficientes y comparen el R² ajustado con modelo2.

# EJERCICIO 2:
  
  # Estimen un modelo usando TODAS las variables de mtcars excepto mpg.
  # Pista: lm(mpg ~ ., data = mtcars)
  # Analicen cuáles variables son significativas y eliminen las que no lo sean.

# EJERCICIO 3:
  
  # Verifiquen los supuestos del modelo final elegido usando:
    # - cor() para ver correlación entre variables
    # - bptest() para heterocedasticidad
    # - R cuadrado
    # - anova
