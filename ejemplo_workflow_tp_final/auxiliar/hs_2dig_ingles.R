# Armar datos a dos digitos de que importamos y exportamos 

#Librerias
library(tidyverse)
library(jsonlite)

# Rutas 
# setwd(r'(C:\Users\nlsid\OneDrive\Documentos\Fundar\)')
auxiliar <- 'indust_notas/comex/auxiliar'

# Leer JSON (reemplazá con tu método)
json_data <- fromJSON("https://comtradeapi.un.org/files/v1/app/reference/H2.json")

# Extraer solo capítulos (2 dígitos)
hs2 <- json_data$results %>%
  filter(aggrlevel == 2) %>%
  select(id, text) %>%
  rename(codigo = id, descripcion = text)

# Guardar
write_csv(hs2, file.path(auxiliar,"hs2002_capitulos.csv"))
