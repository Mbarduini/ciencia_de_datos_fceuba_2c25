# Librerias 
library(tidyverse)
options(scipen=999)

# Rutas 
# setwd(r'(D:\Docencia\UBA\Ciencia de datos\ciencia_de_datos_fceuba_2c25\ejemplo_workflow_tp_final)')
# Vuelvo a cargar el working directory, por las dudas de que haya cerrado la sesion
auxiliar <- 'auxiliar'
instub <- 'raw'
outstub <- 'data/input'


# Cargar datos 
composicion_expo <- read_csv(file.path(instub,'composicion_expo.csv'))
composicion_expo$prop <- NULL

# Agregar region 
paises <- isocountry::isocountry
paises <- paises %>% 
  select(alpha_3,region_name) %>% 
  distinct()
composicion_expo <- composicion_expo %>% 
  left_join(paises,by=c('geocodigoFundar'='alpha_3'))

# Agregar datos por continente 
composicion_expo <- composicion_expo %>% 
  group_by(anio,region_name,lall_desc_full) %>% 
  summarize(exportaciones = sum(exportaciones_industriales,na.rm=T)) %>% 
  ungroup() %>% 
  group_by(anio,lall_desc_full) %>% 
  mutate(prop_exportaciones = exportaciones / sum(exportaciones,na.rm=T)) %>% 
  ungroup() %>% 
  filter(region_name == 'Asia')

# Guardar csv 
write_csv(composicion_expo,file.path(outstub,'02_peso_asia_expo_industrial.csv'))
