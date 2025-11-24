# Librerias 
library(tidyverse)

# Rutas 
# setwd(r'(D:\Docencia\UBA\Ciencia de datos\ciencia_de_datos_fceuba_2c25\ejemplo_workflow_tp_final)')
# Vuelvo a cargar el working directory, por las dudas de que haya cerrado la sesion
auxiliar <- 'auxiliar'
instub <- 'raw'
outstub <- 'data/input'

# Cargar datos 
pib <- read_csv(file.path(instub,'pib_argendata.csv'))

# Paises 
paises <- isocountry::isocountry
paises <- paises %>% 
  select(alpha_3,region_name) %>% 
  distinct()
# Agregar continente 
pib <- pib %>% 
  left_join(paises,by=c('geocodigoFundar'='alpha_3'))

# Chequear paises mas importantes actuales de Asia 
pib_aux <- pib %>% 
  filter(anio == max(anio)) %>% 
  filter(region_name == 'Asia') %>% 
  arrange(desc(industry_gdp))
pib_aux <- pib_aux %>% 
  filter(geocodigoFundar %in% c('CHN', 'JPN','KOR','IND','IDN','THA','VNM')) %>% 
  pull(geocodigoFundar)

# Agregar Otros de Asia 
pib <- pib %>% 
  mutate(agregados = if_else(region_name == 'Asia' & !geocodigoFundar %in% pib_aux,'Otros',geonombreFundar))

pib <- pib %>% 
  group_by(anio,region_name,agregados) %>% 
  summarize(industry_gdp = sum(industry_gdp,na.rm=T)) %>% 
  ungroup() %>% 
  group_by(anio) %>% 
  mutate(prop_industry_gdp = industry_gdp / sum(industry_gdp))

# Filtrar por Asia 
pib <- pib %>% 
  filter(region_name == 'Asia')

# Guardar csv 
write_csv(pib,file.path(outstub,'01_peso_asia_pib_manufacturero.csv'))
