# Descargar archivos 

# Librerias
library(tidyverse)

# Definir Working directory 
# Yo estoy trabajando en un mi disco D y en la carpeta del curso
# Asi que voy a definir todo el path hasta las carpetas que estoy usando
# setwd(r'(D:\Docencia\UBA\Ciencia de datos\ciencia_de_datos_fceuba_2c25\ejemplo_workflow_tp_final)')
# La fila anterior está comentada para que cada uno pueda cambiarlo por su path de trabajo

# Defino las rutas de trabajo para poder tener un manejo de los archivos mas eficiente 
# Y menos dependiente de las rutas  
outstub <- 'raw'

# Cargar datos 
pib <- read_csv('https://argendata.fund.ar/data/INDUST/participacion_arg_pib_ind_mundial.csv')
composicion_expo <- read_csv('https://argendata.fund.ar/data/INDUST/expo_industriales.csv')
pib_pc <- read_csv('https://argendata.fund.ar/data/INDUST/pib_indust_per_capita_comparado.csv')
peso_vab <- read_csv('https://argendata.fund.ar/data/INDUST/peso_industria_empleo_prod_historico.csv')
# Pese a que puedan descargarse directamente desde la web para incorporarlos
# es conveniente guardarlos en el entorno local para poder trabajar si no hay internet 
# si se cae el servidor que los contiene 
# O bien, si son actualizados, ya que muchas veces los datos cambian 
# Y si no estan descargados en el raw, todo lo siguiente va a cambiar 
# Y no va a ser reproducible 

# Una vez cargados, si no hay que hacerles una pequeña transformacion, los guardamos 
write_csv(pib,file.path(outstub,'pib_argendata.csv'))
write_csv(composicion_expo,file.path(outstub,'composicion_expo.csv'))
write_csv(pib_pc,file.path(outstub,'pib_pc.csv'))
write_csv(peso_vab,file.path(outstub,'peso_vab.csv'))

# Una vez ejecutado lo voy a guardar como 00_descarga_raw.R en la carpeta de script


