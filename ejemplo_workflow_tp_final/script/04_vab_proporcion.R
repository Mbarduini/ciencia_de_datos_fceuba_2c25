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
peso_vab <- read_csv(file.path(instub,'peso_vab.csv'))
peso_vab <- peso_vab %>% 
  filter(variable == 'share_industrial_gdp')

# Filtrar paises de Asia seleccionados y promedio 
peso_vab <- peso_vab %>% 
  mutate(seleccionados = if_else(geocodigoFundar %in% c('CHN', 'JPN','KOR','IND','IDN','THA','VNM','FRA','USA','DEU','ITA','BRA','ARG','ESP','AUS'),
                                 'Seleccionados','Otros'))

# Agregar regiones y subregiones 
paises <- isocountry::isocountry %>% 
  select(alpha_3,region_name,subregion_name) %>% 
  distinct()

# Cambiar nombres de subregiones
paises <- paises %>% 
  mutate(subregion_es = recode(subregion_name,"Southern Asia" = "Asia del Sur",
                                                     "Northern Europe" = "Europa del Norte",
                                                     "Southern Europe" = "Europa del Sur",
                                                     "Northern Africa" = "África del Norte",
                                                     "Polynesia" = "Polinesia",
                                                     "Sub-Saharan Africa" = "África Subsahariana",
                                                     "Latin America and the Caribbean" = "América Latina y el Caribe",
                                                     "Western Asia" = "Asia Occidental",
                                                     "Australia and New Zealand" = "Australia y Nueva Zelanda",
                                                     "Western Europe" = "Europa Occidental",
                                                     "Eastern Europe" = "Europa del Este",
                                                     "Northern America" = "América del Norte",
                                                     "South-eastern Asia" = "Sudeste Asiático",
                                                     "Eastern Asia" = "Este de Asia",
                                                     "Melanesia" = "Melanesia",
                                                     "Micronesia" = "Micronesia",
                                                     "Central Asia" = "Asia Central",
                                                     .default = subregion_name))

# Calcular promedios 
peso_vab <- peso_vab %>% 
  left_join(paises,by=c('geocodigoFundar'='alpha_3'))
peso_vab <- peso_vab %>%
  group_by(anio,subregion_es) %>% 
  summarize(valor = mean(valor,na.rm=T))
peso_vab <- peso_vab %>% 
  filter(anio >= 1970 & anio < 2024)

# Guardar csv 
write_csv(peso_vab,file.path(outstub,'04_vab_proporcion.csv'))
