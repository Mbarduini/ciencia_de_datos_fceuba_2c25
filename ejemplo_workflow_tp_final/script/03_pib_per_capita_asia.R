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
pib_pc <- read_csv(file.path(instub,'pib_pc.csv'))
pib_pc$gdp_indust_pc_indice <- NULL

# Paises Asia 
paises_asia <- paises %>% 
  select(alpha_3,region_name) %>% 
  distinct() %>% 
  filter(region_name == 'Asia')

# Calcular promedio de Asia 
pib_asia <- pib_pc %>% 
  filter(geocodigoFundar%in% paises_asia$alpha_3)
pib_asia <- pib_asia %>% 
  group_by(anio) %>% 
  summarize(gdp_indust_pc = mean(gdp_indust_pc,na.rm=T)) %>% 
  ungroup() %>% 
  mutate(geocodigoFundar = 'ASIA',
         geonombreFundar = 'Promedio simple países de Asia')
pib_pc <- bind_rows(pib_pc,pib_asia)
# Dividir paises por el PIB per capita de USA 
pib_pc <- pib_pc %>% 
  filter(anio < 2024)
pib_pc <- pib_pc %>% 
  group_by(anio) %>% 
  mutate(gdp_indust_pc_vs_usa = gdp_indust_pc / gdp_indust_pc[geocodigoFundar == 'USA'])

# Filtrar paises de Asia seleccionados y promedio 
pib_pc <- pib_pc %>% 
  filter(geocodigoFundar %in% c('CHN', 'JPN','KOR','IND','IDN','THA','VNM','ASIA'))

# Guardar csv 
write_csv(pib_pc,file.path(outstub,'03_pib_per_capita_asia.csv'))
